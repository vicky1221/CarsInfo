//
// Common.m
//  Common
//
//  Created by BanShengGua01 on 12/18/12.
//  Copyright (c) 2012 BanShengGua. All rights reserved.
//

#import "Common.h"
#import "GTMBase64.h"

#undef NSLog

#ifndef _DEBUG
void myNSLog(NSString *log) {
	int len = log.length;
	// 加密
	const char *utf8 = [log UTF8String];
	char tmp[len + 1];
	for (int i = 0; i < len; i++) {
		tmp[i] = utf8[i] ^ len;
	}

	NSData *data = [NSData dataWithBytes:tmp length:len];
	NSString *sec = [NSString stringWithFormat:@"%@", [GTMBase64 stringByEncodingData:data]];
	NSLog(@"%@", sec);
	//

	//	// 解密
	//	NSData *d = [GTMBase64 decodeString:[GTMBase64 stringByEncodingData:data]];
	//	const char *dc = [d bytes];
	//	for (int i = 0; i < d.length; i++) {
	//		tmp[i] = dc[i] ^ len;
	//	}
	//	tmp[d.length + 1] = 0;
	//	NSLog(@"-------%@", [NSString stringWithUTF8String:tmp]);
}
#endif
