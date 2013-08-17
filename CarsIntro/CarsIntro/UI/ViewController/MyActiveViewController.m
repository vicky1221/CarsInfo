//
//  MyActiveViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/17/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "MyActiveViewController.h"
#import "JSON.h"
#import "Activity.h"

@interface MyActiveViewController ()<ActivitiesTableDelegate, TableEGODelegate> {
    BOOL isStart;
}

@end

@implementation MyActiveViewController

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
    myActive.ActivitiesDelegate = self;
    myActive.kdelegate = self;
    [myActive createEGOHead];
    if (self.Type == 101) {
        titleLabel.text = @"我的活动";
    } else {
        titleLabel.text = @"我的优惠券";
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:101];
    [[WebRequest instance] clearRequestWithTag:102];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendAPI{
    isStart = YES;
    if (self.Type == 101) {
        ASIHTTPRequest * request = [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=24&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self];
        request.tag = 101;
    } else {
        ASIHTTPRequest * request = [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=25&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self];
        request.tag = 102;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    myActive.activityArray = [NSMutableArray arrayWithCapacity:0];
    myActive.couponArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    for (NSDictionary *d in array) {
        Activity * activity = [[Activity alloc] init];
        [activity fromDic:d];
        if (request.tag == 101) {
            [myActive.activityArray addObject:activity];
            myActive.isActivityData = YES;
        }
        if (request.tag == 102) {
            [myActive.couponArray addObject:activity];
            myActive.isActivityData = NO;
        }
        [activity release];
    }
    [myActive reloadData];
    [myActive finishEGOHead];
    isStart = NO;
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [myActive finishEGOHead];
    isStart = NO;
}

#pragma mark - ActivitiesTableDelegate
-(UIViewController *)viewController
{
    return self;
}

- (BOOL)shouldEgoHeadLoading:(UITableView *)tableView {
    return isStart;
}
- (void)triggerEgoHead:(UITableView *)tableView {
    [self sendAPI];
}

- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
