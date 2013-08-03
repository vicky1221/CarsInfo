//
//  UIView+Chat.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Chat.h"
#import "UIView+Custom.h"
#import "UIBadgeView.h"

@implementation UIView (Chat)
- (void)addChatImage:(UIImage *)chatImage point:(CGPoint)point {
	
	UIImageView *v = (UIImageView *)[self viewWithTag:(int)self + 0];
	if (!v) { // 经过此判断，可以反复调用该函数，而不用担心多次insertSubView造成的视图叠加了。
		
		UIImage *img = [chatImage stretchableImageWithLeftCapWidth:point.x topCapHeight:point.y];
		UIImageView *v = [[[UIImageView alloc] initWithImage:img] autorelease];
		v.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		v.tag = (int)self + 0;
		[self insertSubview:v atIndex:0];
	} else {
		UIImage *img = [chatImage stretchableImageWithLeftCapWidth:point.x topCapHeight:point.y];
		v.image = img;
		v.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
	}
}

// 显示旋转菊花，在控件中间位置
- (void)beginIndicatorView {
    // 防止用户点击两次
    UIActivityIndicatorView *_activityView = (UIActivityIndicatorView *)[self viewWithTag:(int)self + 1];
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.center = self.center;
        NSLog(@"beginIndicatorView x:%f y:%f width:%f height:%f", self.frame.origin.x, self.frame.origin.y,
			  self.frame.size.width, self.frame.size.height);
        _activityView.frame = CGRectMake(_activityView.frame.origin.x - self.frame
										 .origin.x, _activityView.frame.origin.y - self.frame
										 .origin.y, _activityView.frame.size.width, _activityView.frame.size.height);
        _activityView.tag = (int)self + 1;
		[self addSubview:_activityView];
        [_activityView startAnimating];
		[_activityView release];
    }
}

// 停止旋转菊花
- (void)stopShowIndicatorView {
//    NSLog(@"stopShowIndicatorView x:%f y:%f width:%f height:%f", self.frame
//		  .origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    UIActivityIndicatorView *_activityView = (UIActivityIndicatorView *)[self viewWithTag:(int)self + 1];
	
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];  // 注意此处要remove，切记
}


// 在按钮上显示badgeview
- (void)showBadgeView:(CGRect)rect badgeString:(NSString *)badgeString
{
	UIBadgeView *badgeView = nil;
	for (UIView *v in self.subviews) {
		if ([v isMemberOfClass:[UIBadgeView class]]) {
			badgeView = (UIBadgeView *)v;
		}
	}
	if (badgeView == nil) {
//		badgeView = [[UIBadgeView alloc] initWithFrame:rect];
		badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(20 + self.bounds.size.width/2, self.bounds.size.height/2 - 10, 30, 20)];// + self.bounds.size.width/2
//		badgeView.badgeColor = [UIColor redColor];
		//		badgeView.tag = self.selectedIndex;
		badgeView.delegate = self;
		badgeView.userInteractionEnabled = NO;
		[self addSubview:badgeView];
		[badgeView release];
	}
	badgeView.badgeString = badgeString;
}

- (UIImage *)snapshot
{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
//	UIGraphicsBeginImageContext(self.frame.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *parentImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return parentImage;
}

@end
