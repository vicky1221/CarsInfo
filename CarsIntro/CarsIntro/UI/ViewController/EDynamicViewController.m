//
//  EDynamicViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "EDynamicViewController.h"
#import "JSON.h"
#import "WebRequest.h"
#import "Information.h"
#import "NSString+Date.h"

@interface EDynamicViewController ()<ASIHTTPRequestDelegate>

@end

@implementation EDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(sendAPI)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:1000];
}

- (void)sendAPI {
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=article&a=info_json&id=%@", self.infoID] andArgs:nil delegate:self andTag:1000];
    //self.bottomView.hidden = YES;
    //[self showSimpleHUD];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
   // [self removeSimpleHUD];
    //self.bottomView.hidden = NO;
    NSLog(@"请求成功");
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"这是字典,%@", dic);
    self.titleLabel.text = [dic objectForKey:@"title"];
    self.timeLabel.text = [[dic objectForKey:@"addtime"] dateStringSince1970];
    NSString *str = [dic objectForKey:@"title"];
    [self.webView loadHTMLString:str baseURL:nil];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    //[self removeSimpleHUD];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButton:(id)sender {
    NSLog(@"分享");
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [_infoID release];
    [_webView release];
    [_titleLabel release];
    [_timeLabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setTitleLabel:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
}
@end
