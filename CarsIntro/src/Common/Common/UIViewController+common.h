//
//  UIViewController+common.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class RadioRequestObj;

@interface UIViewController (common)
- (void)showActivityIndicator;
- (void)hideActvityIndicator;
- (void)adjustIndicator;

- (void)pushView:(UIViewController *)viewController;
- (void)popView;
- (void)popViewWithoutAnimation;
- (void)popToSelf:(BOOL)animated;
- (void)popToSelf;
- (void)popView:(UIViewController *)viewController;
- (void)popView:(UIViewController *)viewController animated:(BOOL)animated;
- (void)hideNavBar:(BOOL)bHide;
- (void)hideTabBar:(BOOL)bHide;

- (void)popToRoot;
- (void)popToRoot:(BOOL)animated;
- (void)tabToIndex:(NSInteger)index;
- (void)gotoHome;
- (void)setNavBarItem:(id)navBarItem;
- (void)setNavBarTitle:(UIView *)titleView;

- (void)setToolBar:(UIToolbar *)toolBar;
- (void)hideToolBar:(BOOL)bHide;

/* 自定义UINavigation Controller */
- (void)setNavBarFrame:(CGRect)rect;
- (void)setNavBarFrameHeight:(CGFloat)height;
- (void)setTopHeight:(CGFloat)height;

- (void)setNavBarBackground:(UIImage *)image;

/* 返回最顶层ViewController */
- (UIViewController *)topController;

/* 自定义动画 */
- (void) pushController: (UIViewController *)controller animationInfo: (NSDictionary *)animationInfo;
- (void) popControllerWithAnimation: (NSDictionary *)animationInfo;
@end
