//
//  PersonViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface PersonViewController : KBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIView *titleView;

@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *ScoreLabel;
@property (assign, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logout:(id)sender;
@end
