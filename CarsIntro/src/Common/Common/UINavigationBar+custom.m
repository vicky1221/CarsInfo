//
//  UINavigationBar+custom.m
//  KaraokeShare
//
//  Created by Li juan on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+custom.h"

@implementation UINavigationBar (custom)

#pragma mark -  
#pragma mark 重载navigationBar的背景图片 

//iOS4 UINavigationBar custom background
-(void)drawRect:(CGRect)rect{  
    NSLog(@"drawRect");  
	if (self.barStyle == UIBarStyleBlackTranslucent) {
		[super drawRect:rect];
		return;
	}
    UIImage *image = [UIImage imageNamed:@"nav_bg"];  
    [image drawInRect:CGRectMake(0,0,self.frame.size.width,self.frame.size.height + 2)];  
}

//iOS 5 new UINavigationBar custom background
- (void)setBackgroundImage {
	if([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
		UIImage *bg = [UIImage imageNamed:@"nav_bg"];
//		bg = [bg stretchableImageWithLeftCapWidth:20 topCapHeight:20];
		[self setBackgroundImage:bg forBarMetrics: UIBarMetricsDefault];
	}
}

@end
