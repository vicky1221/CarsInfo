//
//  NSDictionary+type.h
//  Common
//
//  Created by BanShengGua01 on 1/15/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (type)
- (NSArray *)arrayForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (int)integerForKey:(NSString *)key;
- (NSArray *)stringArrayForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)BSGStringForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (NSURL *)URLForKey:(NSString *)key;
- (BOOL)hasKey:(NSString *)key;
@end
