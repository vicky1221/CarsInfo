//
//  UIView+badgeView.m
//  KaraokeShare
//
//  Created by zhao guangyu on 12-10-19.
//
//

#import "UIView+badgeView.h"
#import "UIBadgeView.h"

@implementation UIView (badgeView)

// 在按钮上显示badgeview
- (void)showBadgeView:(NSString *)badgeString
{
	[self showBadgeView:badgeString withFrame:CGRectMake(10 + self.bounds.size.width/2, self.bounds.size.height/2, 40, 20)];
}

- (void)showBadgeView:(NSString *)badgeString withFrame:(CGRect)frame
{
	UIBadgeView *badgeView = nil;
	for (UIView *v in self.subviews) {
		if ([v isMemberOfClass:[UIBadgeView class]]) {
			badgeView = (UIBadgeView *)v;
		}
	}
	if (badgeView == nil) {
		badgeView = [[UIBadgeView alloc] initWithFrame:frame];
//		badgeView.badgeColor = [UIColor redColor];
		badgeView.delegate = self;
		badgeView.userInteractionEnabled = NO;
		[self addSubview:badgeView];
		[badgeView release];
	}
	badgeView.badgeString = badgeString;
}

// 移除按钮中的badgeview
- (void)hideBadgeView
{
	for (UIView *v in self.subviews) {
		if ([v isMemberOfClass:[UIBadgeView class]]) {
			[v removeFromSuperview];
		}
	}
}

@end
