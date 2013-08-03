//
//  NSObject+type.m
//  Common
//
//  Created by BanShengGua01 on 1/24/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import "NSObject+type.h"

@implementation NSObject (type)

- (NSString *)stringValue
{
	return self.description;
}
- (NSArray *)arrayValue
{
	if ([self isKindOfClass:[NSArray class]]) {
		return (NSArray *)self;
	} else {
		return nil;
	}
}
- (NSDictionary *)dictionaryValue
{
	if ([self isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)self;
	} else {
		return nil;
	}
}

@end
