//
//  NSString+Date.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)
- (NSString *)dateStringSince1970;
- (NSString *)dateStringSinceNow;
+ (NSString *)stringWithSeconds:(float)seconds;
@end
