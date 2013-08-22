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
#import "NSDictionary+type.h"

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

-(void)viewWillAppear:(BOOL)animated
{
    self.navLabel.text = self.activeTitle;
    NSLog(@"%@", self.navLabel.text);
    if ([self.navLabel.text isEqualToString:@"活动"]) {
        self.titleBtn.hidden= YES;
    }else {
        self.titleBtn.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(sendAPI:) withObject:@"103"];
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

-(void)sendAPI:(NSString *)requestNumber
{
    if ([requestNumber isEqualToString:@"103"]) {
        //    http://www.ard9.com/qiche/index.php?c=channel&molds=huodong&a=info_json&id=编号
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=huodong&a=info_json&id=%@", self.activityID] andArgs:nil delegate:self andTag:103];
    }
    if ([requestNumber isEqualToString:@"104"]) {
        //    http://www.ard9.com/qiche/index.php?c=member&a=youhuijuan&uid=&yhjid=
        //uid 用户编号  yhjid优惠劵编号
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=youhuijuan&uid=%@&yhjid=", self.activityID] andArgs:nil delegate:self andTag:104];
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"dic,,,%@",dic);
    if (request.tag == 104) {
        [[iToast makeText:[dic stringForKey:@"msg"]] show];
    }
    if (request.tag == 103) {
        if ([[dic objectForKey:@"result"] isEqualToString:@"FAILURE"]) {
            [[iToast makeText:[dic stringForKey:@"msg"]] show];
        } else {
            NSString *str = [dic objectForKey:@"content"];
            str = [str stringByReplacingOccurrencesOfString:@"/qiche" withString:@"http://www.ard9.com/qiche"];
            [self.webView loadHTMLString:str baseURL:nil];
            self.titleLabel.text = [dic objectForKey:@"title"];
            self.timeLabel.text = [[dic objectForKey:@"addtime"] dateFormateSince1970];
            NSLog(@"jzsj,,,,%@", [dic objectForKey:@"jzsj"]);
            if ([[dic objectForKey:@"jzsj"] integerValue]<[[NSDate date] timeIntervalSince1970]||[[dic objectForKey:@"sysl"] integerValue]>=[[dic objectForKey:@"zsl"] integerValue]) {
                [self.titleBtn setTitle:@"已过期" forState:UIControlStateNormal];
                self.titleBtn.enabled = NO;
                [self.titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            } else {
                [self.titleBtn setTitle:@"可参加" forState:UIControlStateNormal];
                self.titleBtn.enabled = NO;
                [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            self.numberLabel.text = [NSString stringWithFormat:@"%@/%@", [dic stringForKey:@"sysl"], [dic objectForKey:@"zsl"]];
        }

    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [[iToast makeText:@"网络返回错误"] show];
}

#pragma mark - buttonAction

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)attentActive:(id)sender {
    //[self performSelector:@selector(sendAPI)];
    [self performSelector:@selector(sendAPI:) withObject:@"104"];
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
