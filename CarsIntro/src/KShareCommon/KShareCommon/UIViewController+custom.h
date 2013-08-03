//
//  UIViewController+custom.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioRequestObj;

@interface UIViewController (custom)
- (void)showSimpleHUD;
- (void)removeSimpleHUD;
- (void)showSimpleHUDWithPerform:(int)performTime;
- (void)setTitleBoard:(RadioRequestObj *)board delegate:(id)delegate;
@end
