//
//  AudioUtils.c
//  KaraokeShare
//
//  Created by Peng Liangjin on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#include <Foundation/Foundation.h>
#include "PathUtils.h"

// labary/caches目录
NSString *GetLibrayCachPath()
{
	NSString *libaryCacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return libaryCacheDirectory;
}

// doucument路径
NSString *GetDocPath()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
    return documentsDirectory;
}

// doucument路径
NSString *GetAppPath()
{
	return [[NSBundle mainBundle] resourcePath];
}

NSString *getFileName(NSString *file)
{
    NSString *f = [[file pathComponents] lastObject];
    f = [[f componentsSeparatedByString:@"."] objectAtIndex:0];
    return [NSString stringWithString:f];
}

NSString *getFileExtension(NSString * file)
{
     return [file pathExtension];
}
