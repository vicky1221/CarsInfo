//
//  UIView+badgeView.h
//  KaraokeShare
//
//  Created by zhao guangyu on 12-10-19.
//
//

#import <UIKit/UIKit.h>

@interface UIView (badgeView)

- (void)showBadgeView:(NSString *)badgeString;
- (void)showBadgeView:(NSString *)badgeString withFrame:(CGRect)frame;
- (void)hideBadgeView;

@end
