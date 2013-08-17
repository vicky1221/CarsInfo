//
//  MOrderViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MOrderViewController.h"
#import "WebRequest.h"
#import "DataCenter.h"
#import "UIView+custom.h"
#import "JSON.h"
#import "Order.h"
@interface MOrderViewController ()<ASIHTTPRequestDelegate>

@end

@implementation MOrderViewController
#define Button_Width    100
#define Button_Height   30

-(void)addButtons
{
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.tag = 1;
    float x1 = VIEW_WIDTH(self.view)/2 - Button_Width;
    float y1 = VIEW_HEIGHT(self.view) - Button_Height;
    button1.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    button1.center = CGPointMake(x1, y1);
    [button1 setTitle:@"预约试驾" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"backGround_btn"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];

    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 2;
    float x2 = VIEW_WIDTH(self.view)/2;
    float y2 = VIEW_HEIGHT(self.view) - Button_Height;
    button2.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    button2.center = CGPointMake(x2, y2);
    [button2 setTitle:@"预约保养" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"backGround_btn"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.tag = 3;
    float x3 = VIEW_WIDTH(self.view)/2 + Button_Width;
    float y3 = VIEW_HEIGHT(self.view) - Button_Height;
    button3.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    button3.center = CGPointMake(x3, y3);
    [button3 setTitle:@"预约维修" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"backGround_btn"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
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
    [self addButtons];
    self.requestNumber = 1;
    [self performSelector:@selector(senderAPI)];
    self.mOrderTable.backgroundColor = [UIColor clearColor];
    self.mOrderTable.backgroundView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:105];
    [[WebRequest instance] clearRequestWithTag:106];
    [[WebRequest instance] clearRequestWithTag:107];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//http://www.ard9.com/qiche/index.php?c=channel&a=type_json&tid=35[&uid=]
                                                                    
-(void)senderAPI
{
    switch (self.requestNumber) {
        case 1:{
            [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=34&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:105];
        }
            break;
        case 2:{
            [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=35&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:106];
        }
            break;
        case 3:{
            [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&a=type_json&tid=36&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:107];
        }
            break;
        default:
            break;
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self.mOrderTable.mOrderArray removeAllObjects];
    NSArray * array = [NSArray arrayWithArray:[[request responseString] JSONValue]];    
    for (NSDictionary *d in array) {
        Order * order = [[Order alloc] init];
        [order fromDic:d];
        if (self.requestNumber == 1) {
            order.type = @"预约试驾";
        } else if(self.requestNumber == 2) {
            order.type = @"预约保养";
        } else if(self.requestNumber == 3) {
            order.type = @"预约维修";
        }
        [self.mOrderTable.mOrderArray addObject:order];
        [order release];
    }
    [self.mOrderTable reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"请求失败");
}

#pragma mark - button Action
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonPressed:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 1: {
            self.requestNumber = 1;
            [self performSelector:@selector(senderAPI)];
            break;
        }
        case 2: {
            self.requestNumber = 2;
            [self performSelector:@selector(senderAPI)];
            break;
        }
        case 3: {
            self.requestNumber = 3;
            [self performSelector:@selector(senderAPI)];
            break;
        }
        default:
            break;
    }
}
- (void)dealloc {
    [_mOrderTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMOrderTable:nil];
    [super viewDidUnload];
}
@end
