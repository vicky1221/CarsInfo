//
//  EDynamicViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface EDynamicViewController : KBaseViewController
@property (retain, nonatomic) NSString *infoID;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@end
