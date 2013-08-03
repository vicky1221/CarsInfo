//
//  UIBadgeView2.h
//  Common
//
//  Created by banshenggua03 on 2/22/13.
//  Copyright (c) 2013 BanShengGua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBadgeView2 : UIView {
	NSUInteger width;
	NSString *badgeString;
	
	UIFont *font;
	UITableViewCell *parent;
	
	UIColor *badgeColor;
	UIColor *badgeColorHighlighted;
}

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, retain) NSString *badgeString;
@property (nonatomic, assign) UITableViewCell *parent;
@property (nonatomic, assign) BOOL shadowEnabled;
@property (nonatomic, retain) UIColor *badgeColor;
@property (nonatomic, retain) UIColor *badgeColorHighlighted;
@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) UILabel       *notificationNumberLabel;
@property (nonatomic, retain) NSString      *numberString;


- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context
			  withRadius:(CGFloat) radius;



@end
