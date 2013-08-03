//
//  UIViewController+common.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+common.h"
#import "UITabBarController+Hide.h"
#import "UINavigationBar+custom.h"
#import "QuartzCore/QuartzCore.h"

#define AI_TAG ((int)self + 0)
#define AI_TAGHUD ((int)self + 1)
#define AI_TAGBOARD ((int)self + 2)

@implementation UIViewController (common)

- (void)showActivityIndicator {
	
	UIView *v0 = [self.view viewWithTag:AI_TAG];
	if (v0)
		return;
	
	CGRect f = self.view.frame;
	int size = 100;
	v0 = [[[UIView alloc] initWithFrame:CGRectMake(f.size.width/2 - size/2, f.size.height/2 - size/2, size, size)] autorelease];
	v0.tag = AI_TAG;
	v0.backgroundColor = [UIColor blackColor];
	v0.alpha = 0.5;
	v0.layer.masksToBounds = YES;
	v0.layer.cornerRadius = 4;
	v0.autoresizingMask = 0;
	
	UIActivityIndicatorView *v = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	v.tag = -3;
    [v setCenter:CGPointMake(size/2, size/2)];
	[v0 addSubview:v];
    [self.view addSubview:v0];
    [v startAnimating];
	
	[self performSelector:@selector(hideActvityIndicator) withObject:nil afterDelay:10.0];
}

- (void)hideActvityIndicator {
	UIView *v0 = nil;
	do {
		v0 = [self.view viewWithTag:AI_TAG];
		if (v0 == nil)
			break;
		UIActivityIndicatorView *av = [[v0 subviews] objectAtIndex:0];
		if ([av isKindOfClass:[UIActivityIndicatorView class]]) {
			[av stopAnimating];
		}
		[v0 removeFromSuperview];
	} while (1);
}

- (void)adjustIndicator {
	CGRect f = self.view.frame;
	int size = 100;
	UIView *v0 = nil;
	v0 = [self.view viewWithTag:AI_TAG];
	v0.frame = CGRectMake(f.size.width/2 - size/2, f.size.height/2 - size/2, size, size);
}

- (void)pushView:(UIViewController *)viewController {
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)popView {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)popViewWithoutAnimation {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)popView:(UIViewController *)viewController {
    [self popView:viewController animated:YES];
}

- (void)popView:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController popToViewController:viewController animated:animated];
}

- (void)popToSelf {
    [self popView:self animated:YES];
}

- (void)popToSelf:(BOOL)animated {
    [self popView:self animated:animated];
}

- (void)hideNavBar:(BOOL)bHide {
	self.navigationController.navigationBarHidden = bHide;
}

- (void)hideTabBar:(BOOL)bHide {
	if (self.tabBarController == nil)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBar" object:[NSNumber numberWithBool:bHide]];
	[self.tabBarController hideTabBar:(bHide)];
}

- (void)popToRoot {
    [self popToRoot:YES];
}

- (void)popToRoot:(BOOL)animated {
	[self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)tabToIndex:(NSInteger)index {
//	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:index];
	self.tabBarController.selectedIndex = index;
}

- (void)gotoHome {
	UIViewController *rootVC = [self.navigationController.viewControllers objectAtIndex:0];
//	[self.navigationController setViewControllers:[NSArray arrayWithObject:rootVC]];
	[self popToRoot];
	[rootVC tabToIndex:0];
	[rootVC.tabBarController.tabBar setNeedsDisplay];
}

- (void)setNavBarItem:(id)_navBarItem {
	UINavigationItem *navBarItem = _navBarItem;
	UINavigationItem *vcNavItem = self.navigationItem;
	// hack
	if ([self.navigationController respondsToSelector:@selector(navItemForViewController:)]) {
		vcNavItem = [self.navigationController performSelector:@selector(navItemForViewController:) withObject:self];
	}
    if ([vcNavItem class] != [navBarItem class]) {
        return;
    }
	if (navBarItem.leftBarButtonItem)
		vcNavItem.leftBarButtonItem = navBarItem.leftBarButtonItem;
	if (navBarItem.rightBarButtonItem)
		vcNavItem.rightBarButtonItem = navBarItem.rightBarButtonItem;
	if (navBarItem.titleView)
		vcNavItem.titleView = navBarItem.titleView;
}

- (void)setNavBarTitle:(UIView *)titleView {
	UINavigationItem *vcNavItem = self.navigationItem;
	// hack
	if ([self.navigationController respondsToSelector:@selector(topNavItem)]) {
		vcNavItem = [self.navigationController performSelector:@selector(topNavItem)];
	}
	if (titleView) {
		vcNavItem.titleView = titleView;
	}
}

- (void)setToolBar:(UIToolbar *)toolBar {
	self.toolbarItems = toolBar.items;
}

- (void)hideToolBar:(BOOL)bHide {
	[self.navigationController setToolbarHidden:bHide animated:YES];
}

- (void)setNavBarFrame:(CGRect)rect {
	self.navigationController.navigationBar.frame = rect;
}

- (void)setNavBarFrameHeight:(CGFloat)height {
	CGRect rect = self.navigationController.navigationBar.frame;
	self.navigationController.navigationBar.frame = CGRectMake(rect.origin.x, height, rect.size.width, rect.size.height);
}

- (void)setTopHeight:(CGFloat)height {
	[self setNavBarFrameHeight:height];
	CGRect rect = self.view.frame;
	self.view.frame = CGRectMake(rect.origin.x, height, rect.size.width, rect.size.height - height);
}


- (void)setNavBarBackground:(UIImage *)image {
	[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 遍历Controller
- (UIViewController *)topController
{
	if ([self isKindOfClass:[UITabBarController class]]) {
		UIViewController *vc1 = [((UITabBarController *)self) selectedViewController];
		return [vc1 topController];
	} else if ([self isKindOfClass:[UINavigationController class]]) {
		return [((UINavigationController *)self) topViewController];
	} else if ([self respondsToSelector:@selector(topViewController)]) {
		return [self performSelector:@selector(topViewController)];
	}
	
	return self;
}

#pragma mark - 自定义push动画
- (void) pushController: (UIViewController *)controller animationInfo: (NSDictionary *)animationInfo
{
	CAAnimation *animation = [animationInfo objectForKey:@"animation"];
	if ([self.navigationController respondsToSelector:@selector(pushController:animationInfo:)]) {
		[self.navigationController performSelector:@selector(pushController:animationInfo:) withObject:controller withObject:animationInfo];
	} else {
		[self pushController:controller withAnimation:animation];
	}
}

- (void) pushController: (UIViewController*) controller
         withAnimation: (CAAnimation *) animation
{
	[self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void) popWithAnimation: (CAAnimation *) animation
{
	[self.navigationController.view.layer addAnimation:animation forKey:nil];
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)popControllerWithAnimation:(NSDictionary *)animationInfo
{
	CAAnimation *animation = [animationInfo objectForKey:@"animation"];
	if ([self.navigationController respondsToSelector:@selector(popControllerWithAnimation:)]) {
		[self.navigationController performSelector:@selector(popControllerWithAnimation:) withObject:animationInfo];
	} else {
		[self popWithAnimation:animation];
	}
}

@end
