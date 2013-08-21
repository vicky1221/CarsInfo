//
//  MedalViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MedalViewController.h"
#import "JSON.h"
#import "WebRequest.h"
#import "iToast.h"
#import "Medal.h"
@interface MedalViewController ()<ASIHTTPRequestDelegate>

@end

@implementation MedalViewController

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
    self.medalTable.viewController = self;
    [self performSelector:@selector(senderAPI)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:560];
}

//  http://www.ard9.com/qiche/index.php?c=channel&a=type_json&tid=39&uid=
-(void)senderAPI
{
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=39&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:560];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSArray * array = [[request responseString] JSONValue];
    for (NSDictionary * dict in array) {
        Medal * medal = [[Medal alloc] init];
        [medal fromDic:dict];
        [self.medalTable.medalArray addObject:medal];
        [medal release];
    }
    [self.medalTable reloadData];
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

- (void)dealloc {
    [_medalTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMedalTable:nil];
    [super viewDidUnload];
}
@end
