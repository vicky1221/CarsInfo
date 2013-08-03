//
//  NSDictionary+type.m
//  Common
//
//  Created by BanShengGua01 on 1/15/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import "NSDictionary+type.h"

@implementation NSDictionary (type)

- (NSArray *)arrayForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSArray class]])
		return [self objectForKey:key];
	return nil;
}

- (BOOL)boolForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSString class]] || [v isKindOfClass:[NSNumber class]])
		return [[self objectForKey:key] boolValue];
	return false;
}
- (NSData *)dataForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSData class]])
		return [self objectForKey:key];
	return nil;
}
- (NSDictionary *)dictionaryForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSDictionary class]])
		return [self objectForKey:key];
	return nil;
}
- (float)floatForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSString class]] || [v isKindOfClass:[NSNumber class]])
		return [[self objectForKey:key] floatValue];
	return 0.;
}
- (int)integerForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSString class]] || [v isKindOfClass:[NSNumber class]])
		return [[self objectForKey:key] integerValue];
	return 0;
}
- (NSArray *)stringArrayForKey:(NSString *)key
{
	NSArray *v = [self arrayForKey:key];
	if (v == nil)
		return nil;
	
	NSMutableArray *ret = [NSMutableArray array];
	
	for (NSObject *o in v) {
		[ret addObject:[o description]];
	}
	
	return [NSArray arrayWithArray:ret];
}
- (NSString *)stringForKey:(NSString *)key
{
	NSObject *obj = [self objectForKey:key];
	if ([obj isKindOfClass:[NSNumber class]]) {
		return [obj description];
	} else if ([obj isKindOfClass:[NSString class]]) {
		return (NSString *)obj;
	} else if (obj) {
		return [obj description];
	}
	return nil;
}
- (NSString *)BSGStringForKey:(NSString *)key
{
	NSObject *obj = [self objectForKey:key];
	if ([obj isKindOfClass:[NSNumber class]]) {
		return [obj description];
	} else if ([obj isKindOfClass:[NSString class]]) {
		return (NSString *)obj;
	} else if (obj) {
		return [obj description];
	}
	return nil;
}
- (double)doubleForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSString class]] || [v isKindOfClass:[NSNumber class]])
		return [[self objectForKey:key] doubleValue];
	return 0.;
}
- (NSURL *)URLForKey:(NSString *)key
{
	NSObject *v = [self objectForKey:key];
	if ([v isKindOfClass:[NSURL class]])
		return [self objectForKey:key];
	else if ([v isKindOfClass:[NSString class]]) {
		return [NSURL URLWithString:(NSString *)v];
	}
	return nil;
}
- (BOOL)hasKey:(NSString *)key
{
	return [self objectForKey:key] ? YES : NO;
}

@end
