//
//  NSMutableDictionary+type.m
//  Common
//
//  Created by BanShengGua01 on 1/15/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import "NSMutableDictionary+type.h"

@implementation NSMutableDictionary (type)

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
	[self setObject:[NSString stringWithFormat:@"%d", value] forKey:key];
}
- (void)setFloat:(float)value forKey:(NSString *)key
{
	[self setObject:[NSString stringWithFormat:@"%f", value] forKey:key];
}
- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
	[self setObject:[NSString stringWithFormat:@"%d", value] forKey:key];
}
- (void)setDouble:(double)value forKey:(NSString *)key
{
	[self setObject:[NSString stringWithFormat:@"%f", value] forKey:key];
}
- (void)setURL:(NSURL *)url forKey:(NSString *)key
{
	if (url == nil)
		return;
	[self setObject:url forKey:key];
}
- (void)setString:(NSString *)value forKey:(NSString *)key
{
	if (value == nil)
		return;
	if (![value isKindOfClass:[NSString class]]) {
		value = [value description];
	}
	[self setObject:value forKey:key];
}
- (void)setDictionary:(NSDictionary *)value forKey:(NSString *)key
{
	if (value == nil || ![value isKindOfClass:[NSDictionary class]])
		return;
	[self setObject:value forKey:key];
}
- (void)setArray:(NSArray *)value forKey:(NSString *)key
{
	if (value == nil || ![value isKindOfClass:[NSArray class]])
		return;
	[self setObject:value forKey:key];
}

@end
