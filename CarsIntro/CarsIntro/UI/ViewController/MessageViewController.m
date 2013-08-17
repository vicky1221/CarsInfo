//
//  MessageViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-14.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MessageViewController.h"
#import "JSON.h"
#import "iToast.h"
@interface MessageViewController ()<ASIHTTPRequestDelegate>

@end

@implementation MessageViewController

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
    [self performSelector:@selector(sendAPI)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:550];
}

- (void)sendAPI {
//    http://www.ard9.com/qiche/index.php?c=channel&molds=xunzhang&a=info_json&id=编号
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=xunzhang&a=info_json&id=%@", self.memberCenter.centerID] andArgs:nil delegate:self andTag:550];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    
    if ([[dic objectForKey:@"result"] isEqualToString:@"FAILURE"]) {
        [[iToast makeText:[dic objectForKey:@"msg"]] show];
    } else {
        [self.webView loadHTMLString:[dic objectForKey:@"title"] baseURL:nil];
        self.titleLabel.text = [dic objectForKey:@"title"];
        self.timeLabel.text = [[dic objectForKey:@"addtime"] dateStringSince1970];
        self.senderLabel.text = [dic objectForKey:@"user"];
    }
    NSLog(@"%@",dic);
}

- (void)requestFailed:(ASIHTTPRequest *)request {
                                                              
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_memberCenter release];
    [_messageBody release];
    [_titleLabel release];
    [_senderLabel release];
    [_timeLabel release];
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setSenderLabel:nil];
    [self setTimeLabel:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
