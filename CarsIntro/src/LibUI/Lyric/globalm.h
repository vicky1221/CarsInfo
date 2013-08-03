//
//  globalm.h
//  KWPlayer
//
//  Created by YeeLion on 11-1-10.
//  Copyright 2011 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "debug.h"

#ifdef __cplusplus
extern "C" {
#endif

#define CHECK_POINTER(p)     NSCAssert( lpRect != NULL, @"Invalid pointer value!")
    
#define NSSTR(str) @##str
    
// common function helper
BOOL IsEmptyString(NSString* string);

CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a);    
CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
    
// alpha: 0~255
UIColor* UIColorFromRGBA(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha);

UIColor* UIColorFromRGB(unsigned char red, unsigned char green, unsigned char blue);

UIColor* UIColorFromRGBValue(NSUInteger rgbValue);
UIColor* UIColorFromRGBAValue(NSUInteger rgbValue, int alpha);

//
CGFloat GetRValue(CGColorRef color);
CGFloat GetGValue(CGColorRef color);
CGFloat GetBValue(CGColorRef color);
CGFloat GetAValue(CGColorRef color);
    
UIColor* GetGradentColor(UIColor* color1, UIColor* color2, unsigned int step, unsigned int total);
	
UIImage* UIImageTransparentOfSize(CGFloat width, CGFloat height);


// CGRect helper
void OffsetRectToXY(CGRect* lpRect, float x, float y);
void OffsetRectToPoint(CGRect* lpRect, CGPoint point);
void OffsetRectX(CGRect* lpRect, float x);
void OffsetRectY(CGRect* lpRect, float y);
void OffsetRect(CGRect* lpRect, float x, float y);
void InflateRect(CGRect* lpRect, float left, float top, float right, float bottom);
void DeflateRect(CGRect* lpRect, float left, float top, float right, float bottom);
void InflateRectXY(CGRect* lpRect, float x, float y);
void DeflateRectXY(CGRect* lpRect, float x, float y);

CGPoint CenterPoint(CGRect rect);
CGPoint LeftTopPoint(CGRect rect);
CGPoint LeftButtomPoint(CGRect rect);
CGPoint RightTopPoint(CGRect rect);
CGPoint RightBottomPoint(CGRect rect);

CGRect CenterRect(CGRect rect, float width, float height);
CGRect CenterRectForBounds(CGRect rect, CGRect bounds);
CGRect LeftRect(CGRect rect, float width, float offset);
CGRect RightRect(CGRect rect, float width, float offset);
CGRect TopRect(CGRect rect, float height, float offset);
CGRect BottomRect(CGRect rect, float height, float offset);
    
CGRect LeftTopRect(CGRect rect, float width, float height);
CGRect LeftBottomRect(CGRect rect, float width, float height);
CGRect RightTopRect(CGRect rect, float width, float height);
CGRect RightBottomRect(CGRect rect, float width, float height);

CGRect LeftCenterRect(CGRect rect, float width, float height, float offset);
CGRect RightCenterRect(CGRect rect, float width, float height, float offset);
CGRect TopCenterRect(CGRect rect, float width, float height, float offset);
CGRect BottomCenterRect(CGRect rect, float width, float height, float offset);
    
// time: time in millisecond, upRound: round up or down if less than 1 second
// mm:ss
NSString* TimeToString(NSInteger time, BOOL upRound);
// hh:mm:ss
NSString* TimeToString2(NSInteger time, BOOL upRound);

// mm:ss.fff
NSString* TimeToStringEx(NSInteger time);
// hh:mm:ss.fff
NSString* TimeToStringEx2(NSInteger time);


#ifdef __cplusplus
}
#endif

