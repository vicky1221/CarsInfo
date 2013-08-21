//
//  CenterViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CenterViewController.h"
#import "WebRequest.h"
#import "JSON.h"
#import "MemberCenter.h"
@interface CenterViewController ()<ASIHTTPRequestDelegate>

@end

@implementation CenterViewController

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
    self.centerTable.viewController = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:300];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  http://www.ard9.com/qiche/index.php?c=channel&a=type_json&tid=40&uid=
-(void)senderAPI
{
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=40&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:300];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSArray * array = [[request responseString] JSONValue];
    for (NSDictionary * dict in array) {
        MemberCenter * memberCenter = [[MemberCenter alloc] init];
        [memberCenter fromDic:dict];
        [self.centerTable.centerArray addObject:memberCenter];
        [memberCenter release];
    }
    [self.centerTable reloadData];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"网络连接错误.");
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    NSLog(@"123123");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_centerTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCenterTable:nil];
    [super viewDidUnload];
}
@end
