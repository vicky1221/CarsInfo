//
//  DetailedViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-6.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "DetailedViewController.h"
#import "Parameter.h"
@interface DetailedViewController ()

@end

@implementation DetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)readDataSource
{
    NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray * array2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    Parameter * parameter1 = [[Parameter alloc] init];
    parameter1.title = @"交强险";
    parameter1.content = @"950元";
    [array1 addObject:parameter1];
    [parameter1 release];
    
    Parameter * parameter2 = [[Parameter alloc] init];
    parameter2.title = @"第三者责任险";
    parameter2.content = @"607元";
    [array1 addObject:parameter2];
    [parameter2 release];
    
    Parameter * parameter3 = [[Parameter alloc] init];
    parameter3.title = @"车辆损失险";
    parameter3.content = @"1179元";
    [array1 addObject:parameter3];
    [parameter3 release];
    
    Parameter * parameter4 = [[Parameter alloc] init];
    parameter4.title = @"不计免赔特约险";
    parameter4.content = @"426元";
    [array1 addObject:parameter4];
    [parameter4 release];
    
    Parameter * parameter5 = [[Parameter alloc] init];
    parameter5.title = @"合计";
    parameter5.content = @"3162元";
    [array1 addObject:parameter5];
    [parameter5 release];
    
    Parameter * parameter6 = [[Parameter alloc] init];
    parameter6.title = @"交通险";
    parameter6.content = @"950元";
    [array2 addObject:parameter6];
    [parameter6 release];
    
    Parameter * parameter7 = [[Parameter alloc] init];
    parameter7.title = @"第三者责任险";
    parameter7.content = @"607元";
    [array2 addObject:parameter7];
    [parameter7 release];
    
    Parameter * parameter8 = [[Parameter alloc] init];
    parameter8.title = @"车辆损失险";
    parameter8.content = @"1179元";
    [array2 addObject:parameter8];
    [parameter8 release];
    
    Parameter * parameter9 = [[Parameter alloc] init];
    parameter9.title = @"机动车盗抢险";
    parameter9.content = @"385元";
    [array2 addObject:parameter9];
    [parameter9 release];
    
    Parameter * parameter10 = [[Parameter alloc] init];
    parameter10.title = @"自燃险";
    parameter10.content = @"75元";
    [array2 addObject:parameter10];
    [parameter10 release];
    
    Parameter * parameter11 = [[Parameter alloc] init];
    parameter11.title = @"玻璃单独破碎险";
    parameter11.content = @"155元";
    [array2 addObject:parameter11];
    [parameter11 release];
    
    Parameter * parameter12 = [[Parameter alloc] init];
    parameter12.title = @"车上人员责任险";
    parameter12.content = @"145元";
    [array2 addObject:parameter12];
    [parameter12 release];
    
    Parameter * parameter13 = [[Parameter alloc] init];
    parameter13.title = @"车身划痕损失险";
    parameter13.content = @"400元";
    [array2 addObject:parameter13];
    [parameter13 release];
    
    Parameter * parameter14 = [[Parameter alloc] init];
    parameter14.title = @"不计免赔特约险";
    parameter14.content = @"426元";
    [array2 addObject:parameter14];
    [parameter14 release];
    
    Parameter * parameter15 = [[Parameter alloc] init];
    parameter15.title = @"合计";
    parameter15.content = @"4322元";
    [array2 addObject:parameter15];
    [parameter15 release];
    
    [self.detailedTable.detailedArray addObject:array1];
    [self.detailedTable.detailedArray addObject:array2];
    [array1 release];
    [array2 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self readDataSource];
    self.detailedTable.backgroundColor = [UIColor clearColor];
    self.detailedTable.backgroundView = nil;
    [self.detailedTable setShowsVerticalScrollIndicator:NO];
    //    [tableView setShowsHorizontalScrollIndicator:NO];
    //    [tableView setShowsVerticalScrollIndicator:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_detailedTable release];
    [super dealloc];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
