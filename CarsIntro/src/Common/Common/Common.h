//
//  NSDictionary+Argument.h
//  Common
//
//  Created by BanShengGua01 on 12/18/12.
//  Copyright (c) 2012 BanShengGua. All rights reserved.
//

#ifndef _H_COMMON
#define _H_COMMON

#ifdef __cplusplus
extern "C" {
#endif
	void myNSLog(NSString *log);
#ifdef __cplusplus
}
#endif


#ifndef NS_BLOCK_ASSERTIONS // release是为1
#	define _DEBUG
#endif

#import "UIViewController+common.h"
#import "UINavigationBar+custom.h"
#import "UITabBarController+Hide.h"
#import "GTMNSString+URLArguments.h"
#import "NSDictionary+Argument.h"
#import "PathUtils.h"
#import "NSMutableDictionary+type.h"
#import "NSObject+type.h"
#import "Logger.h"


#ifndef _DEBUG
#define NSLog(a, ...) \
{ \
	NSString *__s = [NSString stringWithFormat:a, ##__VA_ARGS__]; \
	myNSLog(__s); \
}
#endif

#endif

