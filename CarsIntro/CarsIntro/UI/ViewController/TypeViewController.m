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
@interface TypeViewController ()

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

-(void)readXfDataSource
{
    for (int i=0; i<5; i++) {
        VehicleType * vehicelType = [[VehicleType alloc] init];
        vehicelType.image = [NSString stringWithFormat:@"%d.jpg", i];
        vehicelType.title = [NSString stringWithFormat:@"XF123456%d", i];
        vehicelType.price = [NSString stringWithFormat:@"342%d",i];
        vehicelType.gearbox = @"自动";
        vehicelType.displacement = [NSString stringWithFormat:@"10%d", i];
        [self.typeTable.xfArray addObject:vehicelType];
        [vehicelType release];
    }
}

-(void)readXjDataSource
{
    for (int i =0; i<5; i++) {
        VehicleType * vehicelType = [[VehicleType alloc] init];
        vehicelType.image = [NSString stringWithFormat:@"%d.jpg", i+2];
        vehicelType.title = [NSString stringWithFormat:@"XJ123456%d", i];
        vehicelType.price = [NSString stringWithFormat:@"342%d",i];
        vehicelType.gearbox = @"自动";
        vehicelType.displacement = [NSString stringWithFormat:@"10%d", i];
        [self.typeTable.xjArray addObject:vehicelType];
        [vehicelType release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.vehicleType.title;
    NSLog(@"%@", self.titleLabel.text);
    
    if ([self.titleLabel.text isEqualToString:@"XF"]) {
        self.typeTable.isXfData = YES;
        [self readXfDataSource];
    } else if([self.titleLabel.text isEqualToString:@"XJ"]) {
        self.typeTable.isXfData = NO;
        [self readXjDataSource];
    }

    [self.typeTable reloadData];
    self.typeTable.viewController = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_vehicleType release];
    [_titleLabel release];
    [_typeTable release];
    [super dealloc];
}
@end
