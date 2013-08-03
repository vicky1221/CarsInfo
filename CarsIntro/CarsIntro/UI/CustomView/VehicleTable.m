//
//  VehicleTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "VehicleTable.h"
#import "VehicleCell.h"
#import "Parameter.h"
@implementation VehicleTable

-(void)myInit
{
    self.vehicleArray = [NSMutableArray array];
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
    [_vehicleArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vehicleArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"VehicleCell";
    VehicleCell * vehicleCell = (VehicleCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (vehicleCell == nil) {
        vehicleCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    Parameter * _parameter = [self.vehicleArray objectAtIndex:indexPath.row];
    [vehicleCell cellForDic: _parameter];
    
    return vehicleCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    VehicleViewController * vehicleVC = [[VehicleViewController alloc] initWithNibName:@"VehicleViewController" bundle:nil];
//    [self.viewController.navigationController pushViewController:vehicleVC animated:YES];
//    [vehicleVC release];
}


@end
