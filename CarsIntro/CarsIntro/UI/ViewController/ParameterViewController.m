//
//  ParameterViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "ParameterViewController.h"

@interface ParameterViewController ()

@end

@implementation ParameterViewController

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
    NSMutableArray * array1 = [NSMutableArray array];
    NSMutableArray * array2 = [NSMutableArray array];
    NSMutableArray * array3 = [NSMutableArray array];
    NSMutableArray * array4 = [NSMutableArray array];
    NSMutableArray * array5 = [NSMutableArray array];
    NSMutableArray * array6 = [NSMutableArray array];
    NSMutableArray * array7 = [NSMutableArray array];
    NSMutableArray * array8 = [NSMutableArray array];
    NSMutableArray * array9 = [NSMutableArray array];
    NSMutableArray * array10 = [NSMutableArray array];
    NSMutableArray * array11 = [NSMutableArray array];
    NSMutableArray * array12 = [NSMutableArray array];
    NSMutableArray * array13 = [NSMutableArray array];
    NSMutableArray * array14 = [NSMutableArray array];
    NSMutableArray * array15 = [NSMutableArray array];
    NSMutableArray * array16 = [NSMutableArray array];
    NSMutableArray * array17 = [NSMutableArray array];
    
    Parameter * parameter1 = [[Parameter alloc] init];
    parameter1.title = @"车款全名";
    parameter1.content = self.vehicleType.title;
    [array1 addObject:parameter1];
    [parameter1 release];
    
    Parameter * parameter2 = [[Parameter alloc] init];
    parameter2.title = @"指导价";
    parameter2.content = self.vehicleType.price;
    [array1 addObject:parameter2];
    [parameter2 release];
    
    for (int i=0; i<5; i++) {
        Parameter * parameter = [[Parameter alloc] init];
        parameter.title = @"aaaaa";
        parameter.content = @"bbbbb";
        [array1 addObject:parameter];
        [array2 addObject:parameter];
        [array3 addObject:parameter];
        [array4 addObject:parameter];
        [array5 addObject:parameter];
        [array6 addObject:parameter];
        [array7 addObject:parameter];
        [array8 addObject:parameter];
        [array9 addObject:parameter];
        [array10 addObject:parameter];
        [array11 addObject:parameter];
        [array12 addObject:parameter];
        [array13 addObject:parameter];
        [array14 addObject:parameter];
        [array15 addObject:parameter];
        [array16 addObject:parameter];
        [array17 addObject:parameter];
        [parameter release];
    }
    [self.parameterTable.parameterArray addObjectsFromArray:[NSArray arrayWithObjects:array1, array2, array3, array4, array5, array6, array7, array8, array9, array10, array11, array12, array13, array14, array15, array16, array17, nil]];
    [self.parameterTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self readDataSource];
    
    self.titleLabel.text = self.vehicleType.title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.parameterTable.parameterArray addObjectsFromArray:self.parameterArray];
    [self.parameterTable reloadData];
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
    [_parameterArray release];
    [_vehicleType release];
    [_titleLabel release];
    [_parameterTable release];
    [super dealloc];
}
@end
