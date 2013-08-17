//
//  CouponViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-6.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CouponViewController.h"
#import "JSON.h"
#import "UIView+custom.h"
#import "NSString+Date.h"
#import "iToast.h"

@interface CouponViewController ()<ASIHTTPRequestDelegate>

@end

@implementation CouponViewController

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
    self.navLabel.text = self.activeTitle;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:103];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendAPI {
    //    http://www.ard9.com/qiche/index.php?c=channel&molds=huodong&a=info_json&id=编号
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=huodong&a=info_json&id=%@", self.activityID] andArgs:nil delegate:self andTag:103];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"dic,,,%@",dic);
    if ([[dic objectForKey:@"result"] isEqualToString:@"FAILURE"]) {
        [[iToast makeText:[dic objectForKey:@"msg"]] show];
    } else {
        NSString *str = [dic objectForKey:@"content"];
        str = [str stringByReplacingOccurrencesOfString:@"/qiche" withString:@"http://www.ard9.com/qiche"];
        [self.webView loadHTMLString:str baseURL:nil];
        self.titleLabel.text = [dic objectForKey:@"title"];
        self.timeLabel.text = [[dic objectForKey:@"addtime"] dateStringSince1970];
        NSLog(@"jzsj,,,,%@", [dic objectForKey:@"jzsj"]);
        [self.titleBtn setTitle:[dic objectForKey:@"jzsj"] forState:UIControlStateNormal];
        self.numberLabel.text = [dic objectForKey:@"sysl"];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [[iToast makeText:@"网络返回错误"] show];
}

#pragma mark - buttonAction

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_activityID release];
    [_activeTitle release];
    [_navLabel release];
    [_titleBtn release];
    [_titleLabel release];
    [_timeLabel release];
    [_numberLabel release];
    [_webView release];
    [super dealloc];
}

@end
