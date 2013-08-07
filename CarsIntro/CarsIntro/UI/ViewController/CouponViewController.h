//
//  CouponViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-6.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface CouponViewController : KBaseViewController

@property (retain, nonatomic) IBOutlet UILabel *navLabel;

@property (retain, nonatomic) IBOutlet UIButton *titleBtn;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *numberLabel;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;


@property (retain, nonatomic) NSString * activityID;
@property (retain, nonatomic) NSString * tid;
@end
