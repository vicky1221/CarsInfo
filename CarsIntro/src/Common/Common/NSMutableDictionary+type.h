//
//  NSMutableDictionary+type.h
//  Common
//
//  Created by BanShengGua01 on 1/15/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+type.h"

@interface NSMutableDictionary (type)
- (void)setBool:(BOOL)value forKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;
- (void)setInteger:(NSInteger)value forKey:(NSString *)key;
- (void)setDouble:(double)value forKey:(NSString *)key;
- (void)setURL:(NSURL *)url forKey:(NSString *)key;
- (void)setString:(NSString *)value forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)value forKey:(NSString *)key;
- (void)setArray:(NSArray *)value forKey:(NSString *)key;
@end
