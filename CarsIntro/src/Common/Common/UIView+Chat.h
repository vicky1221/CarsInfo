//
//  UIView+Chat.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Chat)
- (void) addChatImage:(UIImage *)chatImage point:(CGPoint)point;
- (void)beginIndicatorView;
- (void)stopShowIndicatorView;

- (void)showBadgeView:(CGRect)rect badgeString:(NSString *)badgeString;

- (UIImage *)snapshot;
@end
