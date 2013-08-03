//
//  NSDictionary+Argument.m
//  Common
//
//  Created by BanShengGua01 on 12/18/12.
//  Copyright (c) 2012 BanShengGua. All rights reserved.
//

#import "NSDictionary+Argument.h"
#import "GTMNSString+URLArguments.h"

@implementation NSDictionary (Argument)

- (NSString *)paramString {
	NSString *ret = @"";
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *key in [self allKeys]) {
		[array addObject:[NSString stringWithFormat:@"%@=%@", [key gtm_stringByEscapingForURLArgument], [[[self objectForKey:key] description] gtm_stringByEscapingForURLArgument]]];
	}
	ret = [array componentsJoinedByString:@"&"];
	return ret;
}

- (NSURL *)urlWithDomain:(NSString *)domain {
	return [NSURL URLWithString:[self paramString] relativeToURL:[NSURL URLWithString:domain]];
}
@end
