//
//  CarsViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CarsViewController.h"
#import "VehicleType.h"
#import "UsedCarInfo.h"
#import "UIView+custom.h"
#import "CarsCell.h"
#import "TypeViewController.h"
#import "JSON.h"
#import "UsedCarInfo.h"

@interface CarsViewController ()<ASIHTTPRequestDelegate, TableEGODelegate> {
    BOOL isStart;
}

@end

@implementation CarsViewController

#define Button_Width    152
#define Button_Height   36

- (void)addButtonsToChoiceView
{
    self.btnNew = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnNew.tag = 101;
    [self.btnNew setBackgroundImage:[UIImage imageNamed:@"newCar_1"] forState:UIControlStateNormal];
    float x = VIEW_WIDTH(self.choiceView)/2 - Button_Width/2;
    float y = VIEW_HEIGHT(self.choiceView)/2;
    self.btnNew.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    self.btnNew.center = CGPointMake(x, y);
    [self.btnNew addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceView addSubview:self.btnNew];
    
    self.btnUsed = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnUsed.tag = 102;
    [self.btnUsed setBackgroundImage:[UIImage imageNamed:@"usedCar_1"] forState:UIControlStateNormal];
    x = VIEW_WIDTH(self.choiceView)/2 + Button_Width/2;
    y = VIEW_HEIGHT(self.choiceView)/2;
    self.btnUsed.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    self.btnUsed.center = CGPointMake(x, y);
    [self.btnUsed addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceView addSubview:self.btnUsed];
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
    [self addButtonsToChoiceView];
    //self.carsTable.viewController = self;
    self.carsTable.isNewCarData = YES;
    [self performSelector:@selector(sendAPI)];
    self.carsTable.carsDelegate = self;
    [self.carsTable createEGOHead];
    self.carsTable.kdelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:101];
    [[WebRequest instance] clearRequestWithTag:102];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action
- (void)buttonPressed:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 101:
            [self.btnNew setBackgroundImage:[UIImage imageNamed:@"newCar_1"] forState:UIControlStateNormal];
            [self.btnUsed setBackgroundImage:[UIImage imageNamed:@"usedCar_1"] forState:UIControlStateNormal];
            self.carsTable.isNewCarData = YES;
            [self performSelector:@selector(sendAPI)];
            break;
        case 102:
            [self.btnNew setBackgroundImage:[UIImage imageNamed:@"newCar_2"] forState:UIControlStateNormal];
            [self.btnUsed setBackgroundImage:[UIImage imageNamed:@"usedCar_2"] forState:UIControlStateNormal];
            self.carsTable.isNewCarData = NO;
            [self performSelector:@selector(sendAPI)];
            break;
    }
    NSLog(@"%d", buttonTag);
}

- (void)sendAPI {
    if (self.carsTable.isNewCarData) {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=product&a=sub_type_json&tid=38" andArgs:nil delegate:self andTag:101];
    } else {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=channel&a=type_json&tid=26" andArgs:nil delegate:self andTag:102];
    }
    isStart = YES;
}

- (void)sendAPI:(NSString *)type tid:(NSString *)tid {
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self.carsTable.newCarsArray removeAllObjects];
    [self.carsTable.usedCarsArray removeAllObjects];
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    NSLog(@"array,,,%@",[array description]);
    for (NSDictionary *d in array) {
        UsedCarInfo *info = [[UsedCarInfo alloc] init];
        [info fromDic:d];
        if (request.tag == 101) {
            [self.carsTable.newCarsArray addObject:info];
        } else if(request.tag == 102) {
            [self.carsTable.usedCarsArray addObject:info];
        }
        [info release];
    }
    [self.carsTable reloadData];
    isStart = NO;
    [self.carsTable finishEGOHead];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    isStart = NO;
    [self.carsTable finishEGOHead];
    NSLog(@"error!");
}

- (IBAction)back:(id)sender {
    [self backToHomeView:self.navigationController];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_choiceView release];
    [_carsTable release];
    [super dealloc];
}

#pragma mark - CarsTableDelegate
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

@end
