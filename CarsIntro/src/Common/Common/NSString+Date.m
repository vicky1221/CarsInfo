//
//  NSString+Date.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

- (NSString *)dateFormateSince1970 {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [formate stringFromDate:date];
    [formate release];
    return str;
}

- (NSString *)dateStringSince1970 {
	NSDate * date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSString *atime = [NSString stringWithFormat:@"%@", localeDate];
    NSString *ttime = [atime substringWithRange:NSMakeRange(2,18)]; 
    return ttime;
}

- (NSString *)dateStringSinceNow {
	NSString *ret = nil;
	NSDate *now = [NSDate date];
	NSTimeInterval delta = now.timeIntervalSince1970 - [self intValue];

	if (delta / 60 < 1) {
		ret = @"刚刚";
	} else if (delta / 3600 < 1) {
		ret = [NSString stringWithFormat:@"%d分钟前", (int)delta/60];
	} else {
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self intValue]];
		
		
		NSDateFormatter *nsdf2=[[[NSDateFormatter alloc] init]autorelease];
		nsdf2.dateStyle = NSDateFormatterShortStyle;
		nsdf2.timeZone = [NSTimeZone systemTimeZone];
		nsdf2.dateFormat = @"yy'-'MM'-'dd' 'HH':'mm";
		
		NSString *nowStr = [nsdf2 stringFromDate:now];
		NSString *timeStr = [nsdf2 stringFromDate:date];
		
		if ([[nowStr substringToIndex:8] isEqualToString:[timeStr substringToIndex:8]]) {
			ret = [NSString stringWithFormat:@"今天 %@", [timeStr substringFromIndex:9]];
		} else {
			ret = timeStr;
		}
	}
	return ret;
}

+ (NSString *)stringWithSeconds:(float)seconds {
    int s = (int)seconds;
    NSString *ret = @"";
    
    if (s == 0)
        return @"00:00";
    
    ret = [ret stringByAppendingFormat:@"%02d:%02d", (s / 60) % 60, s % 60];
    
    return ret;
}

@end
