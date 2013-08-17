//
//  ActivitiesViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "Activity.h"
#import "UIView+custom.h"
#import "JSON.h"

@interface ActivitiesViewController ()<ASIHTTPRequestDelegate, TableEGODelegate> {
    BOOL isStart;
    NSInteger currentIndex;
}

@end

@implementation ActivitiesViewController

#define Button_Width    152
#define Button_Height   36

- (void)addButtonsToChoiceView
{
    self.btnActivity = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnActivity.tag = 101;
    [self.btnActivity setBackgroundImage:[UIImage imageNamed:@"Activity_1"] forState:UIControlStateNormal];
    float x = VIEW_WIDTH(self.choiceView)/2 - Button_Width/2;
    float y = VIEW_HEIGHT(self.choiceView)/2;
    self.btnActivity.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    self.btnActivity.center = CGPointMake(x, y);
    [self.btnActivity addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceView addSubview:self.btnActivity];
    
    self.btnCoupon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnCoupon.tag = 102;
    [self.btnCoupon setBackgroundImage:[UIImage imageNamed:@"Coupon_1"] forState:UIControlStateNormal];
    x = VIEW_WIDTH(self.choiceView)/2 + Button_Width/2;
    y = VIEW_HEIGHT(self.choiceView)/2;
    self.btnCoupon.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    self.btnCoupon.center = CGPointMake(x, y);
    [self.btnCoupon addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceView addSubview:self.btnCoupon];
}

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
    [self addButtonsToChoiceView];
    [self performSelector:@selector(sendAPI:) withObject:@"activity"];
    self.activitiesTable.ActivitiesDelegate = self;
    self.activitiesTable.kdelegate = self;
    [self.activitiesTable createEGOHead];
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

- (void)dealloc {
    [_choiceView release];
    [_activitiesTable release];
    [super dealloc];
}

#pragma mark - Button Action
- (void)buttonPressed:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    currentIndex = buttonTag;
    switch (buttonTag) {
        case 101:
            [self.btnActivity setBackgroundImage:[UIImage imageNamed:@"Activity_1"] forState:UIControlStateNormal];
            [self.btnCoupon setBackgroundImage:[UIImage imageNamed:@"Coupon_1"] forState:UIControlStateNormal];
            [self performSelector:@selector(sendAPI:) withObject:@"activity"];
            break;
        case 102:
            [self.btnActivity setBackgroundImage:[UIImage imageNamed:@"Activity_2"] forState:UIControlStateNormal];
            [self.btnCoupon setBackgroundImage:[UIImage imageNamed:@"Coupon_2"] forState:UIControlStateNormal];
            [self performSelector:@selector(sendAPI:) withObject:@"coupon"];
            break;
    }
    NSLog(@"%d", buttonTag);
}

- (IBAction)back:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (void)sendAPI:(NSString *)str{
    isStart = YES;
    if ([str isEqualToString:@"activity"]) {
        //    http://www.ard9.com/qiche/index.php?c=channel&a=type_json&tid=24
        ASIHTTPRequest * request = [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=channel&a=type_json&tid=24" andArgs:nil delegate:self];
        request.tag = 101;
    } else if ([str isEqualToString:@"coupon"]) {
        //    http://www.ard9.com/qiche/index.php?c=channel&a=type_json&tid=25
        ASIHTTPRequest * request = [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=channel&a=type_json&tid=25" andArgs:nil delegate:self];
        request.tag = 102;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    self.activitiesTable.activityArray = [NSMutableArray arrayWithCapacity:0];
    self.activitiesTable.couponArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    for (NSDictionary *d in array) {
        Activity * activity = [[Activity alloc] init];
        [activity fromDic:d];
        if (request.tag == 101) {
            [self.activitiesTable.activityArray addObject:activity];
            self.activitiesTable.isActivityData = YES;
        }
        if (request.tag == 102) {
            [self.activitiesTable.couponArray addObject:activity];
            self.activitiesTable.isActivityData = NO;
        }
        [activity release];
    }    
    [self.activitiesTable reloadData];
    [self.activitiesTable finishEGOHead];
    isStart = NO;
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [self.activitiesTable finishEGOHead];
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
    switch (currentIndex) {
        case 101:
            [self sendAPI:@"activity"];
            break;
        case 102:
            [self sendAPI:@"coupon"];
            break;
    }
}

@end
