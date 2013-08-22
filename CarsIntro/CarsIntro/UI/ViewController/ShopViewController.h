//
//  ShopViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "CIntroduceViewController.h"
#import <MessageUI/MessageUI.h>
@interface ShopViewController : KBaseViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, assign) BOOL isPhoneActionSheet;

@property (retain, nonatomic) IBOutlet UIButton *phoneButton;

@property (retain, nonatomic) IBOutlet UIButton *emaileButton;

@property (retain, nonatomic) IBOutlet UIButton *newsButton;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UIButton *introduceButton;

@property (retain, nonatomic) IBOutlet UIButton *locationButton;
@end
