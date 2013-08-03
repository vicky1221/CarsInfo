//
//  DynamicViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-31.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface DynamicViewController : KBaseViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UITextView *text;

@property (retain, nonatomic) NSString *infoID;
-(void)loadWebPageWithString:(NSString *)urlString;

@end
