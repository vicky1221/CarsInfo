//
//  UIViewController+custom.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+custom.h"
#import "UIViewController+common.h"
#import "MBProgressHUD.h"
//#import "RadioRequestObj.h"
#import "TitleBoard.h"

#define AI_TAG ((int)self + 0)
#define AI_TAGHUD ((int)self + 1)
#define AI_TAGBOARD ((int)self + 2)

@implementation UIViewController (custom)

- (void)showSimpleHUD {
	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	[self showSimpleHUDWithPerform:10];
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	//	HUD.delegate = self;
}

- (void)showSimpleHUDWithPerform:(int)performTime {
    MBProgressHUD *HUD = (MBProgressHUD *)[self.view viewWithTag:AI_TAGHUD];
	
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
		HUD.tag = AI_TAGHUD;
        [self.view addSubview:HUD];
		[HUD release];
		
		HUD.dimBackground = YES;
		[HUD show:YES];
    }
	if (performTime > 0) {
        [self performSelector:@selector(removeSimpleHUD) withObject:nil afterDelay:performTime];
    }
}

- (void)removeSimpleHUD {
	MBProgressHUD *HUD = (MBProgressHUD *)[self.view viewWithTag:AI_TAGHUD];
	[HUD removeFromSuperview];
}

//- (void)setTitleBoard:(RadioRequestObj *)board delegate:(id)delegate {
//	if (board == nil || board.itemCount == 0) {
//		return;
//	}
//	
//	NSMutableArray *a = [NSMutableArray arrayWithCapacity:board.itemCount];
//	
//	for (RadioItem *i in board.items) {
//		TitleBoardItem *ti = [[[TitleBoardItem alloc] init] autorelease];
//		ti.title = i.title;
//		[a addObject:ti];
//	}
//	
//	// TODO, titleboard存在了？？
//	
//	TitleBoard *t = nil;
//	t = (TitleBoard *)[self.view viewWithTag:AI_TAGBOARD];
//	if (t == nil) {
//		t = [[TitleBoard alloc] initWithFrame:CGRectMake(46, 0, 145, 44)];
//		t.delegate = delegate;
//		t.tag = AI_TAGBOARD;
//		[self setNavBarTitle:t];
//	}
//	[t updateView:a selectIndex:board.selected];
//}
@end
