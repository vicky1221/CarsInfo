//
//  UITabBarController+Hide.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITabBarController+Hide.h"

#define tabHeight 49

@implementation UITabBarController (myTab)

static BOOL isHidden = NO;
static BOOL isFullScreen = NO;

+ (void)setFullScreen:(BOOL)isFull {
	isFullScreen = isFull;
}

#pragma mark - UITabBar hide and show
- (void) hideTabBar:(BOOL)hidden {
	if (isFullScreen) {
		[self hideTabBarFullScreen:hidden];
		return;
	}
	/*
	static BOOL isHidden = NO;
	if (isHidden == hidden)
		return;
	if (hidden)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"hideCustomTabBar" object:self];
	else
		[[NSNotificationCenter defaultCenter] postNotificationName:@"bringCustomTabBarToFront" object:self];
	isHidden = hidden;
	 */
		
	
    
    if (hidden && !isHidden) {
        isHidden = !isHidden;
        
        for(UIView *view in self.view.subviews)
        {
//            NSLog(@"before hide %@", view);
            if([view isKindOfClass:[UITabBar class]])
            {
                view.hidden = hidden;
				[[NSNotificationCenter defaultCenter] postNotificationName:@"hideCustomTabBar" object:self];
            } 
            else 
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + tabHeight)];
            }
//            NSLog(@"after hide %@", view);
        }
    } else if (!hidden && isHidden) {
        isHidden = !isHidden;
        
        for(UIView *view in self.view.subviews)
        {
//            NSLog(@"before show %@", view);
            
            if([view isKindOfClass:[UITabBar class]])
            {
                view.hidden = hidden;
				[[NSNotificationCenter defaultCenter] postNotificationName:@"bringCustomTabBarToFront" object:self];
            } 
            else 
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height - tabHeight)];
            }
//            NSLog(@"after show %@", view);
        }
    }
}

- (void) hideTabBarFullScreen:(BOOL)hidden {
	
	static BOOL isFull = NO;
	isHidden = YES;
    
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
		}
		else
		{
			if (!isFull) {
				[view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + tabHeight)];
			}
		}
	}
	isFull = YES;
	if (hidden) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"hideCustomTabBar" object:self];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"bringCustomTabBarToFront" object:self];
	}
}

@end

