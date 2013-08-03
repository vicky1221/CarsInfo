//
//  FileDownloadManager.h
//  KaraokeShare
//
//  Created by Li juan on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PlayList.h"

@class FileDownloadManager;
@protocol DownloadDelegate <NSObject>

@optional
- (void)progressChanged:(FileDownloadManager *)manager item:(id<PlayItemDelegate>)item progress:(float)progress;
- (void)downloadFinished:(FileDownloadManager *)manager item:(id<PlayItemDelegate>)item;
- (void)downloadError:(FileDownloadManager *)manager item:(id<PlayItemDelegate>)item;

@end

@interface FileDownloadManager : NSObject
+ (FileDownloadManager *)sharedManager;
- (void)download:(id<PlayItemDelegate>)item withDelegate:(id)delegate;
- (void)pause:(id<PlayItemDelegate>)item;
- (void)attach:(id<PlayItemDelegate>)item withDelegate:(id)delegate;
- (void)unattachDelegateForItem:(id<PlayItemDelegate>)item;
- (void)unattachAllDelegates;
- (void)unattachDelegate:(id)delegate;
- (BOOL)query:(id<PlayItemDelegate>)item withDelegate:(id)delegate;
- (void)removeAll;
- (void)removeItem:(id<PlayItemDelegate>)item;
- (void)removeItem:(id<PlayItemDelegate>)item keepDelegate:(BOOL)keepDelegate;
- (NSString *)localPathofItem:(id<PlayItemDelegate>)item;
- (BOOL)hasLocalItem:(id<PlayItemDelegate>)item;
- (BOOL)hasPartialDownloaded:(id<PlayItemDelegate>)item;
- (BOOL)isDownloading:(id<PlayItemDelegate>)item;
- (BOOL)isPaused:(id<PlayItemDelegate>)item;
- (NSURL *)urlForItem:(id<PlayItemDelegate>)item;
- (CGFloat)progressForItem:(id<PlayItemDelegate>)item;
@end
