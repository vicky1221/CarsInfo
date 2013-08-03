//
//  Logger.m
//  Common
//
//  Created by BanShengGua01 on 2/21/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import "Logger.h"

#ifndef NS_BLOCK_ASSERTIONS // release是为1
static LoggerLevel logLevel = kLoggerLevel_Verbose | kLoggerLevel_Info | kLoggerLevel_Debug | kLoggerLevel_Warning | kLoggerLevel_Error;
#else
static LoggerLevel logLevel = kLoggerLevel_None;
#endif

void setLogerLevel(LoggerLevel level)
{
	logLevel = level;
}
void LogV(NSString *fmt, ...)
{
	if (logLevel & kLoggerLevel_Verbose) {
		va_list l;
		va_start(l, fmt);
		va_end(l);
		NSLogv(fmt, l);
	}
}
void LogI(NSString *fmt, ...)
{
	if (logLevel & kLoggerLevel_Info) {
		va_list l;
		va_start(l, fmt);
		va_end(l);
		NSLogv(fmt, l);
	}
}
void LogD(NSString *fmt, ...)
{
	if (logLevel & kLoggerLevel_Debug) {
		va_list l;
		va_start(l, fmt);
		va_end(l);
		NSLogv(fmt, l);
	}
}
void LogE(NSString *fmt, ...)
{
	if (logLevel & kLoggerLevel_Error) {
		va_list l;
		va_start(l, fmt);
		va_end(l);
		NSLogv(fmt, l);
	}
}
void LogW(NSString *fmt, ...)
{
	if (logLevel & kLoggerLevel_Warning) {
		va_list l;
		va_start(l, fmt);
		va_end(l);
		NSLogv(fmt, l);
	}
}