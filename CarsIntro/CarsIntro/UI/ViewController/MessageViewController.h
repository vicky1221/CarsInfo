//
//  MessageViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-14.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberCenter.h"
#import "MessageBody.h"
#import "KBaseViewController.h"
@interface MessageViewController : KBaseViewController

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *senderLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) MemberCenter * memberCenter;
@property (retain, nonatomic) MessageBody * messageBody;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end
