//
//  UsedCarsTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "UsedCarsTable.h"
#import "NSDictionary+type.h"
#import "UsedCar.h"
#import "VehicleViewController.h"
@implementation UsedCarsTable

-(void)myInit
{
    self.UsedCarsArray = [NSMutableArray array];
    self.dataSource = self;
    self.delegate = self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self myInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self myInit];
    }
    return self;
}

-(void)dealloc
{
    [_UsedCarsArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.UsedCarsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"UsedCarsCell";
    UsedCarsCell * usedCarscell = (UsedCarsCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (usedCarscell == nil) {
        usedCarscell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    NSDictionary * d = [self.UsedCarsArray objectAtIndex:indexPath.row];
    UsedCar * usedCar = [[UsedCar alloc] init];
    [usedCar fromDic:d];
    [usedCarscell cellForDic:usedCar];
    [usedCar release];
    return usedCarscell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VehicleViewController * vehicleVC = [[VehicleViewController alloc] initWithNibName:@"VehicleViewController" bundle:nil];
    NSDictionary *d = [self.UsedCarsArray objectAtIndex:indexPath.row];
    
    VehicleType * _vehicleType = [[[VehicleType alloc] init] autorelease];
    [_vehicleType fromDic:d];
    vehicleVC.ID = [d objectForKey:@"id"];
    vehicleVC.vehicleType = _vehicleType;
    //[self.viewController.navigationController pushViewController:vehicleVC animated:YES];
    vehicleVC.isFromUsedCars = YES;
    [self.viewController.navigationController pushViewController:vehicleVC animated:YES];
    [vehicleVC release];
}

@end
