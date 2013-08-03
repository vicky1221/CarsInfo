//
//  FileDownloadManager.m
//  KaraokeShare
//
//  Created by Li juan on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileDownloadManager.h"
#import "NSString+MD5.h"
#import "Session.h"
#import "AFDownloadRequestOperation.h"
#import "Logger.h"
#import "MobClickLog.h"

@interface FileDownloadRequestOperation : AFDownloadRequestOperation
@property (nonatomic, assign) id<DownloadDelegate> progressDelegate;
@property (nonatomic, assign) float  currentProgress;
+ (NSString *)tempPathOf:(NSString *)targetPath;
@end
@implementation FileDownloadRequestOperation
+ (NSString *)tempPathOf:(NSString *)targetPath {
    NSString *tempPath = nil;
    if (targetPath) {
        NSString *md5URLString = [self md5StringForString:targetPath];
        tempPath = [[self cacheFolder] stringByAppendingPathComponent:md5URLString];
    }
    return tempPath;
}
@end

@implementation FileDownloadManager

static FileDownloadManager *defaultManager = nil;
static NSMutableDictionary *downloadQueue = nil;

+ (FileDownloadManager *)sharedManager {
	if (defaultManager == nil) {
		defaultManager = [[FileDownloadManager alloc] init];
		downloadQueue = [[NSMutableDictionary alloc] init];
	}
	return defaultManager;
}

+ (NSString *)playKey:(NSString *)playUid
{
    return [playUid MD5StringLowercase];
}

- (NSString *)localPathofItem:(id<PlayItemDelegate>)item
{
	// 兼容
	NSFileManager *fm = [NSFileManager defaultManager];
	NSURL *url = [item songURL];
	if ([url isFileURL] && [fm fileExistsAtPath:url.path]) {
		return url.path;
	}
	
	NSString *path = [[Session sharedSession] getPath:[item filePathType] file:[[self class] playKey:[item playUid]]];
    
	return [path stringByAppendingPathExtension:[item extension]];
}

- (NSString *)oldLocalPathofItem:(id<PlayItemDelegate>)item
{
	NSString *path = [[Session sharedSession] getPath:[item filePathType] file:[item playUid]];
	return [path stringByAppendingPathExtension:[item extension]];
}

- (BOOL)hasLocalItem:(id<PlayItemDelegate>)item
{
	NSString *path = [self localPathofItem:item];
    NSString *oldPath = [self oldLocalPathofItem:item];
	NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:oldPath]) {
        return YES;
    }
    
    if ([[item songURL] isFileURL] && [manager fileExistsAtPath:[[item songURL] path]]) {
        return YES;
    }
	if ([manager fileExistsAtPath:path]) {
		return YES;
	}
	return NO;
}

- (NSURL *)urlForItem:(id<PlayItemDelegate>)item
{
	if (![self hasLocalItem:item])
		return nil;
	NSString *path = [self localPathofItem:item];
	return [NSURL fileURLWithPath:path];
}

- (BOOL)isDownloading:(id<PlayItemDelegate>)item
{
	FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
	return op.isExecuting;
}

- (BOOL)isPaused:(id<PlayItemDelegate>)item
{
	if ([self hasLocalItem:item])
		return NO;
	FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
	if (op)
		return op.isPaused || op.isCancelled || (op && !op.isExecuting);
	
	NSString *tmpPath = [FileDownloadRequestOperation tempPathOf:[self localPathofItem:item]];
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:tmpPath]) {
		return YES;
	}
	return NO;
}

- (BOOL)hasPartialDownloaded:(id<PlayItemDelegate>)item
{
	NSString *tmpPath = [FileDownloadRequestOperation tempPathOf:[self localPathofItem:item]];
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:tmpPath]) {
		return YES;
	}
	return NO;
}

- (void)pause:(id<PlayItemDelegate>)item
{
	FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
	[op cancel];
}

- (void)download:(id<PlayItemDelegate>)item withDelegate:(id)delegate
{
	if ([self hasLocalItem:item]) {
		// 文件已存在
		if ([delegate respondsToSelector:@selector(downloadFinished:item:)]) {
			[delegate downloadFinished:self item:item];
		}
		return;
	}
	
	NSURL *url = [item songURL];
	
	[self unattachDelegateForItem:item];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
	NSString *path = [self localPathofItem:item];
	FileDownloadRequestOperation *op = [[FileDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
	op.shouldOverwrite = YES;
	[downloadQueue setObject:op forKey:[[self class] playKey:[item playUid]]];
	[op release];
	[self attach:item withDelegate:delegate];
	
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", [self localPathofItem:item]);
        if ([item verify:[self localPathofItem:item]]) {
            if ([op.progressDelegate respondsToSelector:@selector(downloadFinished:item:)]) {
                [op.progressDelegate downloadFinished:self item:item];
            }
			
			NSString *des = nil;
			des = [NSString stringWithFormat:@"class %@ uid=%@", [item class], [item playUid]];
			[MobClickLog mcEvent:SendPolicy_Everyday event:@"song downloaded" describe:des];
        } else {
			NSLog(@"download Error (checksum) %@, remove it", item);
            if ([op.progressDelegate respondsToSelector:@selector(downloadError:item:)]) {
                [op.progressDelegate downloadError:self item:item];
            }
			[self removeItem:item keepDelegate:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"download Error %@ %@", item, error);
		if ([op.progressDelegate respondsToSelector:@selector(downloadError:item:)]) {
			[op.progressDelegate downloadError:self item:item];
		}
    }];
    
    [op setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
		LogD(@"%@ download progress %f", item, percentDone);
        op.currentProgress = percentDone;
		if ([op.progressDelegate respondsToSelector:@selector(progressChanged:item:progress:)]) {
			[op.progressDelegate progressChanged:self item:item progress:percentDone];
		}
    }];
	[op start];
}

- (void)attach:(id<PlayItemDelegate>)item withDelegate:(id)delegate
{
	FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
	if (op) {
		op.progressDelegate = delegate;
	}
}

- (void)unattachDelegateForItem:(id<PlayItemDelegate>)item
{
	FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
	if (op) {
		op.progressDelegate = nil;
	}
}

- (void)unattachDelegate:(id)delegate
{
	for (FileDownloadRequestOperation *op in downloadQueue.allValues) {
		if (op.progressDelegate == delegate) {
			op.progressDelegate = nil;
		}
	}
}

- (void)unattachAllDelegates
{
	for (FileDownloadRequestOperation *op in downloadQueue.allValues) {
		op.progressDelegate = nil;
	}
}

- (BOOL)query:(id<PlayItemDelegate>)item withDelegate:(id)delegate
{
	FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
	return op.progressDelegate == delegate;
}

- (void)removeItem:(id<PlayItemDelegate>)item
{
	[self removeItem:item keepDelegate:NO];
}

- (void)removeItem:(id<PlayItemDelegate>)item keepDelegate:(BOOL)keepDelegate
{
	if (!keepDelegate) {
		FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
		op.progressDelegate = nil;
		[op cancel];
		[downloadQueue removeObjectForKey:[[self class] playKey:[item playUid]]];
	}
	
	NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = [[NSError alloc] init];
	NSString *tmpPath = [FileDownloadRequestOperation tempPathOf:[self localPathofItem:item]];
    if ([fm fileExistsAtPath:tmpPath]) {
		[fm removeItemAtPath:tmpPath error:&error];
		if (error.code != 0 )
			NSLog(@"%@ %@", self, error);
	}
	
	if ([fm fileExistsAtPath:[self localPathofItem:item]]) {
		[fm removeItemAtPath:[self localPathofItem:item] error:&error];
		if (error.code != 0 )
			NSLog(@"%@ %@", self, error);
//		[fm createFileAtPath:[self localPathofItem:item] contents:nil attributes:nil];
	}
	[error release];
}

// TODO: type
- (void)removeAll {
	for (FileDownloadRequestOperation *op in downloadQueue.allValues) {
		op.progressDelegate = nil;
		[op cancel];
	}
	[downloadQueue removeAllObjects];
	
	NSString *dstPath = [[Session sharedSession] getPath:eFCPath file:nil];
	NSFileManager *fm = [NSFileManager defaultManager];
	
	NSError *error = [[NSError alloc] init];
	BOOL dir = YES;
	if ([fm fileExistsAtPath:dstPath isDirectory:&dir]) {
		[fm removeItemAtPath:dstPath error:&error];
		
		if (error.code != 0 )
			NSLog(@"%@ %@", self, error);
	}
	dir = YES;
	dstPath = [FileDownloadRequestOperation cacheFolder];
	if ([fm fileExistsAtPath:dstPath isDirectory:&dir]) {
		[fm removeItemAtPath:dstPath error:&error];
		
		if (error.code != 0 )
			NSLog(@"%@ %@", self, error);
	}
	[error release];
}

- (CGFloat)progressForItem:(id<PlayItemDelegate>)item
{
    FileDownloadRequestOperation *op = [downloadQueue objectForKey:[[self class] playKey:[item playUid]]];
    return op.currentProgress;
}

@end
