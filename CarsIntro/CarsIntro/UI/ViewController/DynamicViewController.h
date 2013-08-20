//
//  DynamicViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-31.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface DynamicViewController : KBaseViewController

@property (retain, nonatomic) NSString *infoID;
@property (assign, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) IBOutlet UIView *bottomView; //bottom底部
@property (assign, nonatomic) IBOutlet UIView *shareview;
@property (retain, nonatomic) IBOutlet UIView *sinaView;
@property (assign, nonatomic) IBOutlet UITextView *sinaTextView;
@property (assign, nonatomic) BOOL isFromInfoVC;    //判断是从infoVC还是特别推荐进入的当前界面
- (IBAction)buttomButton:(id)sender;

- (IBAction)share:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *leftButton;

@property (retain, nonatomic) IBOutlet UIButton *rightButton;

@end
