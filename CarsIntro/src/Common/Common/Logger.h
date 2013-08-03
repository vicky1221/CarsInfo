//
//  Logger.h
//  Common
//
//  Created by BanShengGua01 on 2/21/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Log Level
 * I = 'Info'
 * D = 'Debug'
 * W = 'Warning'
 * E = 'Error'
 * V = 'Verbose'
 */

typedef enum {
	kLoggerLevel_None = 0,
	kLoggerLevel_Verbose = 1,
	kLoggerLevel_Info = 2,
	kLoggerLevel_Debug = 4,
	kLoggerLevel_Warning = 8,
	kLoggerLevel_Error = 16,
}LoggerLevel;

void setLogerLevel(LoggerLevel level);
void LogV(NSString *fmt, ...);
void LogI(NSString *fmt, ...);
void LogD(NSString *fmt, ...);
void LogE(NSString *fmt, ...);
void LogW(NSString *fmt, ...);
