//
//  globalm.mm
//  KWPlayer
//
//  Created by YeeLion on 11-1-10.
//  Copyright 2011 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "globalm.h"

// common function helper
BOOL IsEmptyString(NSString* string) {
    return string == nil || ([string length] <= 0);
}

CGColorRef CreateDeviceGrayColor(CGFloat w, CGFloat a)
{
	CGColorSpaceRef gray = CGColorSpaceCreateDeviceGray();
	CGFloat comps[] = {w, a};
	CGColorRef color = CGColorCreate(gray, comps);
	CGColorSpaceRelease(gray);
	return color;
}

CGColorRef CreateDeviceRGBColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat comps[] = {r, g, b, a};
	CGColorRef color = CGColorCreate(rgb, comps);
	CGColorSpaceRelease(rgb);
	return color;
}

UIColor* UIColorFromRGBA(unsigned char red, unsigned char green, unsigned char blue, unsigned char alpha) {
    return [UIColor colorWithRed:(float)red/255.0
                           green:(float)green/255.0
                            blue:(float)blue/255.0
                           alpha:(float)alpha/100.0];
}

UIColor* UIColorFromRGB(unsigned char red, unsigned char green, unsigned char blue) {
    return [UIColor colorWithRed:(float)red/255.0
                           green:(float)green/255.0
                            blue:(float)blue/255.0
                           alpha:1.0];
}

UIColor* UIColorFromRGBValue(NSUInteger rgbValue) {
    return UIColorFromRGB((rgbValue & 0xFF0000) >> 16, 
                          (rgbValue & 0x00FF00) >> 8, 
                          (rgbValue & 0x0000FF)); 
}

UIColor* UIColorFromRGBAValue(NSUInteger rgbValue, int alpha) {
    return UIColorFromRGBA((rgbValue & 0xFF0000) >> 16, 
                           (rgbValue & 0x00FF00) >> 8, 
                           (rgbValue & 0x0000FF),
                           alpha);
}

//
CGFloat GetRValue(CGColorRef color) {
    //NSCAssert( 1 < CGColorGetNumberOfComponents(color) );
    return CGColorGetComponents(color)[0];
}

CGFloat GetGValue(CGColorRef color) {
    NSCAssert( 1 < CGColorGetNumberOfComponents(color), @"Unexpected CGColor value!" );
    return CGColorGetComponents(color)[1];
}

CGFloat GetBValue(CGColorRef color) {
    NSCAssert( 1 < CGColorGetNumberOfComponents(color), @"Unexpected CGColor value!" );
    return CGColorGetComponents(color)[2];
}

CGFloat GetAValue(CGColorRef color) {
    return CGColorGetAlpha(color);
}

UIColor* GetGradentColor(UIColor* color1, UIColor* color2, unsigned int step, unsigned int total)
{
	//ASSERT(total > 0 && step <= total);
	float scale2 = (float)step / total;
	float scale1 = 1 - scale2;
    CGColorRef clr1 = color1.CGColor;
    CGColorRef clr2 = color2.CGColor;
    UIColor* color = [UIColor colorWithRed:GetRValue(clr1) * scale1 + GetRValue(clr2) * scale2
                                     green:GetGValue(clr1) * scale1 + GetGValue(clr2) * scale2
                                      blue:GetBValue(clr1) * scale1 + GetBValue(clr2) * scale2
                                     alpha:GetAValue(clr1) * scale1 + GetAValue(clr2) * scale2];
	return color;
}


UIImage* UIImageTransparentOfSize(CGFloat width, CGFloat height) 
{
	// create the bitmap context
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0, colorSpace,kCGImageAlphaPremultipliedLast);
	CFRelease(colorSpace);
	
	//	create an arrow image
	// set the fill color
	CGColorRef fillColor = [[UIColor clearColor] CGColor];
	CGContextSetFillColor(context, CGColorGetComponents(fillColor));
	
	// convert the context into a CGImageRef
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	UIImage* imageTransparent = [UIImage imageWithCGImage:image];
	[imageTransparent drawInRect:CGRectMake(0, 0, width, height)];
	CGImageRelease(image);
	return imageTransparent;
}


// CGRect helper
void OffsetRectToPoint(CGRect* lpRect, CGPoint point) {
    CHECK_POINTER(lpRect);
    lpRect->origin.x = point.x;
    lpRect->origin.y = point.y;
}

void OffsetRectToXY(CGRect* lpRect, float x, float y) {
    CHECK_POINTER(lpRect);
    lpRect->origin.x = x;
    lpRect->origin.y = y;
}

void OffsetRectX(CGRect* lpRect, float x) {
    CHECK_POINTER(lpRect);
    lpRect->origin.x += x;
}

void OffsetRectY(CGRect* lpRect, float y) {
    CHECK_POINTER(lpRect);
    lpRect->origin.y += y;
}

void OffsetRect(CGRect* lpRect, float x, float y) {
    CHECK_POINTER(lpRect);
    lpRect->origin.x += x;
    lpRect->origin.y += y;
}

void InflateRect(CGRect* lpRect, float left, float top, float right, float bottom) {
    CHECK_POINTER(lpRect);
    lpRect->origin.x -= left;
    lpRect->origin.y -= top;
    lpRect->size.width += left + right;
    lpRect->size.height += top + bottom;
}

void DeflateRect(CGRect* lpRect, float left, float top, float right, float bottom) {
    CHECK_POINTER(lpRect);
    lpRect->origin.x += left;
    lpRect->origin.y += top;
    lpRect->size.width -= left + right;
    lpRect->size.height -= top + bottom;
}

void InflateRectXY(CGRect* lpRect, float x, float y)
{
    CHECK_POINTER(lpRect);
    lpRect->origin.x -= x;
    lpRect->origin.y -= y;
    lpRect->size.width += x + x;
    lpRect->size.height += y + y;
}

void DeflateRectXY(CGRect* lpRect, float x, float y)
{
    CHECK_POINTER(lpRect);
    lpRect->origin.x += x;
    lpRect->origin.y += y;
    lpRect->size.width -= x + x;
    lpRect->size.height -= y + y;    
}

CGPoint CenterPoint(CGRect rect) {
    CGPoint point = {rect.origin.x + rect.size.width / 2,
                     rect.origin.y + rect.size.height / 2};
    return point;
}

CGPoint LeftTopPoint(CGRect rect) {
    return rect.origin;
}

CGPoint LeftButtomPoint(CGRect rect) {
    CGPoint pt = rect.origin;
    pt.y += rect.size.height;
    return pt;
}

CGPoint RightTopPoint(CGRect rect) {
    CGPoint pt = rect.origin;
    pt.x += rect.size.width;
    return pt;
}

CGPoint RightBottomPoint(CGRect rect) {
    CGPoint pt = rect.origin;
    pt.x += rect.size.width;
    pt.y += rect.size.height;
    return pt;
}

CGRect CenterRect(CGRect rect, float width, float height) {
    CGPoint pt = CenterPoint(rect);
    return CGRectMake(pt.x - width/2,
                      pt.y - height/2,
                      width,
                      height);
}

CGRect CenterRectForBounds(CGRect rect, CGRect bounds) {
    return CenterRect(bounds, rect.size.width, rect.size.height);
}

CGRect LeftRect(CGRect rect, float width, float offset) {
    return CGRectMake(rect.origin.x + offset,
                      rect.origin.y,
                      width,
                      rect.size.height);
}

CGRect RightRect(CGRect rect, float width, float offset) {
    return CGRectMake(rect.origin.x + rect.size.width - width - offset,
                      rect.origin.y,
                      width,
                      rect.size.height);
}

CGRect TopRect(CGRect rect, float height, float offset) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y + offset,
                      rect.size.width,
                      height);
}

CGRect BottomRect(CGRect rect, float height, float offset) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y + rect.size.height - height - offset,
                      rect.size.width,
                      height);
}

CGRect LeftTopRect(CGRect rect, float width, float height) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y,
                      width,
                      height);
}

CGRect LeftBottomRect(CGRect rect, float width, float height) {
    return CGRectMake(rect.origin.x,
                      rect.origin.y + rect.size.height - height,
                      width,
                      height);
}

CGRect RightTopRect(CGRect rect, float width, float height) {
    return CGRectMake(rect.origin.x + rect.size.width - width,
                      rect.origin.y,
                      width,
                      height);
}

CGRect RightBottomRect(CGRect rect, float width, float height) {
    return CGRectMake(rect.origin.x + rect.size.width - width,
                      rect.origin.y + rect.size.height - height,
                      width,
                      height);
}

CGRect LeftCenterRect(CGRect rect, float width, float height, float offset) {
    return CGRectMake(rect.origin.x + offset,
                      rect.origin.y + (rect.size.height - height) / 2,
                      width,
                      height);
}

CGRect RightCenterRect(CGRect rect, float width, float height, float offset) {
    return CGRectMake(rect.origin.x + rect.size.width - offset - width,
                      rect.origin.y + (rect.size.height - height) / 2,
                      width,
                      height);
}

CGRect TopCenterRect(CGRect rect, float width, float height, float offset) {
    return CGRectMake(rect.origin.x + (rect.size.width - width) / 2,
                      rect.origin.y + offset,
                      width,
                      height);
}

CGRect BottomCenterRect(CGRect rect, float width, float height, float offset) {
    return CGRectMake(rect.origin.x + (rect.size.width - width) / 2,
                      rect.origin.y + rect.size.height - offset - height,
                      width,
                      height);
}

// time: time in millisecond, upRound: round up or down if less than 1 second
// mm:ss
NSString* TimeToString(NSInteger time, BOOL upRound) {
    NSMutableString* string = [NSMutableString stringWithCapacity:10];
	if(0==time) return @"00:00";
    if (time < 0) {
        [string appendString:@"-"];
        time = -time;
    }
    if (upRound) {
        time += 999;
    }
    int tmp = time / 1000;
    int sec = tmp % 60;
    int min = tmp /= 60;
    [string appendFormat:@"%02d:%02d", min, sec];
    return string;
}

// hh:mm:ss
NSString* TimeToString2(NSInteger time, BOOL upRound) {
    NSMutableString* string = [NSMutableString stringWithCapacity:10];
    if (time < 00) {
        [string appendString:@"-"];
        time = -time;
    }
    if (upRound) {
        time += 999;
    }
    int tmp = time / 1000;
    int sec = tmp % 60;
    tmp /= 60;
    int min = tmp % 60;
    tmp /= 60;
    int hour = tmp;
    [string appendFormat:@"%d:%02d:%02d", hour, min, sec];
    return string;
}

// mm:ss.fff
NSString* TimeToStringEx(NSInteger time) {
    NSMutableString* string = [NSMutableString stringWithCapacity:10];
    if (time < 0) {
        [string appendString:@"-"];
        time = -time;
    }
    int msec = time % 1000;
    int tmp = time / 1000;
    int sec = tmp % 60;
    int min = tmp /= 60;
    [string appendFormat:@"%02d:%02d.%03d", min, sec, msec];
    return string;
}

// hh:mm:ss.fff
NSString* TimeToStringEx2(NSInteger time) {
    NSMutableString* string = [NSMutableString stringWithCapacity:10];
    if (time < 0) {
        [string appendString:@"-"];
        time = -time;
    }
    int msec = time % 1000;
    int tmp = time / 1000;
    int sec = tmp % 60;
    tmp /= 60;
    int min = tmp % 60;
    tmp /= 60;
    int hour = tmp;
    [string appendFormat:@"%d:%02d:%02d.%03d", hour, min, sec, msec];
    return string;
}

