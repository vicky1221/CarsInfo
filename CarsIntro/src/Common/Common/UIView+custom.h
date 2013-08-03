//
//  UIView+custom.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define VIEW_LEFT(v) v.frame.origin.x
#define VIEW_TOP(v) v.frame.origin.y
#define VIEW_BOTTOM(v) (v.frame.origin.y + v.frame.size.height)
#define VIEW_RIGHT(v) (v.frame.origin.x + v.frame.size.width)
#define VIEW_WIDTH(v) v.frame.size.width
#define VIEW_HEIGHT(v) v.frame.size.height
#define LABEL_HEIGHT(v, t) ([t sizeWithFont:v.font constrainedToSize:CGSizeMake(v.frame.size.width, 2000) lineBreakMode:UILineBreakModeWordWrap].height)
#define TEXTVIEW_HEIGHT(v, t) ([t sizeWithFont:v.font constrainedToSize:CGSizeMake(v.frame.size.width-16, 2000) lineBreakMode:UILineBreakModeWordWrap].height)
#define LABEL_WIDTH(v, t) ([t sizeWithFont:v.font].width)
#define VIEW_FRAME_HB(v, shift, scale) CGRectMake(VIEW_LEFT(v), VIEW_TOP(v) + (shift), VIEW_WIDTH(v), VIEW_HEIGHT(v) + (scale))
#define VIEW_FRAME_WL(v, shift, scale) CGRectMake(VIEW_LEFT(v) - (scale) + (shift), VIEW_TOP(v), VIEW_WIDTH(v) + (scale), VIEW_HEIGHT(v))
#define VIEW_FRAME_WR(v, shift, scale) CGRectMake(VIEW_LEFT(v) + (shift), VIEW_TOP(v), VIEW_WIDTH(v) + (scale), VIEW_HEIGHT(v))

#import "UIView+Chat.h"
