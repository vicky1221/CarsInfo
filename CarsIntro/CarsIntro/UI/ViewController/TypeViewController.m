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
@interface TypeViewController ()<ASIHTTPRequestDelegate,TableEGODelegate>
{
    BOOL isStart;
}
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
//    self.tidsArray = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    if (self.isFromDynamicVC) {
        self.titleLabel.text = @"车款系列";
        [self performSelector:@selector(sendAPI2)];
    } else {
        self.titleLabel.text = self.title;
        [self performSelector:@selector(sendAPI)];
    }
    NSLog(@"%@", self.titleLabel.text);
    self.typeTable.viewController = self;
    [self.typeTable createEGOHead];
    self.typeTable.kdelegate = self;
}

//http://www.ard9.com/qiche/index.php?c=product&a=type_json&tid=38
//二手车
//http://www.ard9.com/qiche/index.php?c=channel&molds=esc&a=info_json&id=编号
- (void)sendAPI {
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=product&a=type_json&tid=%@", self.tid] andArgs:nil delegate:self andTag:600];
    isStart = YES;
}

- (void)sendAPI2 {
    for (NSString *aTid in self.tidsArray) {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=product&a=type_json&tid=%@", aTid] andArgs:nil delegate:self andTag:603];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == 600) {
        [self.typeTable.typeArray removeAllObjects];
        NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
        for (NSDictionary *d in array) {
            [self.typeTable.typeArray addObject:d];
        }
        [self.typeTable reloadData];
        isStart = NO;
        [self.typeTable finishEGOHead];
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
    } else {
        NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
        for (NSDictionary *d in array) {
            [self.typeTable.typeArray addObject:d];
        }
        [self.typeTable reloadData];
        isStart = NO;
        [self.typeTable finishEGOHead];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    isStart = NO;
    [self.typeTable finishEGOHead];
    NSLog(@"error!");
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [[WebRequest instance] clearRequestWithTag:600];
    [[WebRequest instance] clearRequestWithTag:603];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_tidsArray release];
    [_tid release];
    [_vehicleType release];
    [_titleLabel release];
    [_typeTable release];
    [super dealloc];
}

- (BOOL)shouldEgoHeadLoading:(UITableView *)tableView {
    return isStart;
}
- (void)triggerEgoHead:(UITableView *)tableView {
    if (self.isFromDynamicVC) {
        [self sendAPI2];
    } else {
        [self sendAPI];
    }

}

@end
