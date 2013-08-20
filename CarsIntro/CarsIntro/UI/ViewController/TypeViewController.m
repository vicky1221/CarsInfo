//
//  TypeViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "TypeViewController.h"
#import "VehicleType.h"
#import "CarsViewController.h"
#import "JSON.h"
#import "WebRequest.h"
#import "iToast.h"
@interface TypeViewController ()<ASIHTTPRequestDelegate>

@end

@implementation TypeViewController

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
    self.titleLabel.text = self.title;
    NSLog(@"%@", self.titleLabel.text);
    [self performSelector:@selector(sendAPI)];
    self.typeTable.viewController = self;
}

//http://www.ard9.com/qiche/index.php?c=product&a=type_json&tid=38
//二手车
//http://www.ard9.com/qiche/index.php?c=channel&molds=esc&a=info_json&id=编号
- (void)sendAPI {
    
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=product&a=type_json&tid=%@", self.tid] andArgs:nil delegate:self andTag:600];
//    if (self.isNewCarData) {
//        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=product&a=type_json&tid=%d", self.usedCarInfo.usedCarTid.intValue+2] andArgs:nil delegate:self andTag:600];
//        NSLog(@"%d", self.usedCarInfo.usedCarTid.intValue + 2);
//    } else {
//        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=esc&a=info_json&id=%@", self.usedCarInfo.usedCarInfoId] andArgs:nil delegate:self andTag:601];
//    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self.typeTable.typeArray removeAllObjects];

    if (request.tag == 600) {
        NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
        for (NSDictionary *d in array) {
            [self.typeTable.typeArray addObject:d];
//            VehicleType * vehicleType = [[VehicleType alloc] init];
//            [vehicleType fromDic:d];
//            [self.typeTable.typeArray addObject:vehicleType];
//            [vehicleType release];
        }
    } else if (request.tag == 601) {
        NSDictionary * dic = [NSDictionary dictionaryWithDictionary:[[request responseString] JSONValue]];
        if ([[dic objectForKey:@"result"] isEqualToString:@"FAILURE"]) {
            [[iToast makeText:[dic objectForKey:@"msg"]] show];
        } else {
            VehicleType * vehicleType = [[VehicleType alloc] init];
            [vehicleType fromDic:dic];
            [self.typeTable.typeArray addObject:vehicleType];
            [vehicleType release];
        }
        NSLog(@"%@",dic);
    }
    [self.typeTable reloadData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"请求失败了");
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [[WebRequest instance] clearRequestWithTag:600];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_tid release];
    [_vehicleType release];
    [_titleLabel release];
    [_typeTable release];
    [super dealloc];
}
@end
