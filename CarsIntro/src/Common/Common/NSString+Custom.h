//
//  NSString+Custom.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+MD5.h"
#import "NSString+Date.h"

#define XOR_PASSWD @"banshenggua2012"

@interface NSString(custom)
+ (NSDictionary *)createEmoji:(NSString *)filename;
- (NSString *)stripSpace;
- (NSString *)stripEditSpace;
- (NSString *)replaceEmoji;
- (NSString *)replaceEmojiBin;
- (NSString *)base64EncodeXOR:(NSString *)XorString;
- (NSString *)base64EncodeXOR;
- (NSDictionary *)queryDict;
+ (NSString *)toString:(id)object;
@end