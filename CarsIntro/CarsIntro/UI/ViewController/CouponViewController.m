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
#import "LoginViewController.h"

@interface CouponViewController ()<ASIHTTPRequestDelegate>
{
    UINavigationController * loginNav;
}
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
    self.navLabel.text = self.activeTitle;
    [self performSelector:@selector(sendAPI:) withObject:@"103"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:103];
    [[WebRequest instance] clearRequestWithTag:104];
    [[WebRequest instance] clearRequestWithTag:105];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendAPI:(NSString *)requestNumber
{
    if ([requestNumber isEqualToString:@"103"]) {
        //    http://www.ard9.com/qiche/index.php?c=channel&molds=yhj&a=info_json&id=编号
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=yhj&a=info_json&id=%@", self.activityID] andArgs:nil delegate:self andTag:103];
    }
    if ([requestNumber isEqualToString:@"104"]) {
        //    http://www.ard9.com/qiche/index.php?c=member&a=youhuijuan&uid=&yhjid=&tid=
        //uid 用户编号  yhjid优惠劵编号  tid   活动类型  25 优惠劵  56 活动信息  
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=youhuijuan&uid=%@&yhjid=%@&tid=%@", [DataCenter shareInstance].accont.loginUserID, self.activityID, @"56"] andArgs:nil delegate:self andTag:104];
    }
    if([requestNumber isEqualToString:@"105"]) {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=youhuijuan&uid=%@&yhjid=%@&tid=%@", [DataCenter shareInstance].accont.loginUserID, self.activityID, @"25"] andArgs:nil delegate:self andTag:105];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"dic,,,%@",dic);
    if (request.tag == 104) {
        [[iToast makeText:[dic stringForKey:@"msg"]] show];
    }
    if (request.tag == 105) {
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
            self.timeLabel.text = [[dic objectForKey:@"jzsj"] dateFormateSince1970];
            NSLog(@"jzsj,,,,%@", [dic objectForKey:@"jzsj"]);
            if ([[dic objectForKey:@"jzsj"] integerValue]<[[NSDate date] timeIntervalSince1970]||[[dic objectForKey:@"yysl"] integerValue]>=[[dic objectForKey:@"zsl"] integerValue]) {
                [self.titleBtn setTitle:@"已过期" forState:UIControlStateNormal];
                self.titleBtn.enabled = NO;
                [self.titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            } else {
                [self.titleBtn setTitle:@"可参加" forState:UIControlStateNormal];
                self.titleBtn.enabled = YES;
                [self.titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            self.numberLabel.text = [NSString stringWithFormat:@"%d/%d", [[dic objectForKey:@"zsl"] integerValue] - [[dic stringForKey:@"yysl"] integerValue], [[dic objectForKey:@"zsl"] integerValue]];
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
    NSLog(@"%@",self.navLabel.text);
    if ([[DataCenter shareInstance].accont isAnonymous]) {
        if (loginNav) {
            [self pushCurrentViewController:self toNavigation:loginNav isAdded:YES Driection:3];
        } else {
            LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginNav.navigationBarHidden = YES;
            [loginVC release];
            [self pushCurrentViewController:self toNavigation:loginNav isAdded:NO Driection:3];
        }
    } else if ([self.navLabel.text isEqualToString:@"活动"]) {
        [self performSelector:@selector(sendAPI:) withObject:@"104"];
    } else{
        NSLog(@"点击了优惠劵");
        [self performSelector:@selector(sendAPI:) withObject:@"105"];
    }
}

- (void)dealloc {
    [loginNav release];
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
