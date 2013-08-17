//
//  MDetailsViewController.m
//  CarsIntro
//
//  Created by cs on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MDetailsViewController.h"
#import "JSON.h"
#import "iToast.h"
#import "WebRequest.h"
@interface MDetailsViewController ()<ASIHTTPRequestDelegate>

@end

@implementation MDetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(senderAPI)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:570];
}

//  http://www.ard9.com/qiche/index.php?c=channel&molds=xunzhang&a=info_json&id=编号

-(void)senderAPI
{
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=xunzhang&a=info_json&id=%@", self.medal.medalID ] andArgs:nil delegate:self andTag:570];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic = [[request responseString] JSONValue];
    if ([[dic objectForKey:@"result"] isEqualToString:@"FAILURE"]) {
        [[iToast makeText:[dic objectForKey:@"msg"]] show];
    } else {
        [self.webView loadHTMLString:[dic objectForKey:@"title"] baseURL:nil];
        self.titleLabel.text = [dic objectForKey:@"title"];
        self.timeLabel.text = [[dic objectForKey:@"addtime"] dateStringSince1970];
        self.userLabel.text = [dic objectForKey:@"user"];
    }
    NSLog(@"%@",dic);
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"网络连接错误.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [_medal release];
    [_titleLabel release];
    [_userLabel release];
    [_timeLabel release];
    [_webView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setUserLabel:nil];
    [self setTimeLabel:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
