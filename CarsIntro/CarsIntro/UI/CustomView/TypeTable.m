//
//  TypeTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "TypeTable.h"

#import "VehicleViewController.h"
#import "NSDictionary+type.h"

@implementation TypeTable

-(void)myInit
{
    self.typeArray = [[[NSMutableArray alloc] init] autorelease];
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
    [_typeArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.typeArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"TypeCell";
    TypeCell * typeCell = (TypeCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (typeCell == nil) {
        typeCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    NSDictionary *d = [self.typeArray objectAtIndex:indexPath.row];
    typeCell.titleLabel.text = [d stringForKey:@"title"];
    typeCell.priceLabel.text = [d stringForKey:@"zdj"];
    typeCell.gearboxLabel.text = [d stringForKey:@"bsx"];
    typeCell.displacement.text = [d stringForKey:@"pl"];
    [typeCell.asyImageView LoadImage:[NSString stringWithFormat:@"%@%@",ServerAddress ,[d stringForKey:@"litpic"]]];
//    ageView *asyImageView 
//    VehicleType * _vehicleType = [self.typeArray objectAtIndex:indexPath.row];
//    [typeCell cellForDic:_vehicleType];
    return typeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VehicleViewController * vehicleVC = [[VehicleViewController alloc] initWithNibName:@"VehicleViewController" bundle:nil];
    NSDictionary *d = [self.typeArray objectAtIndex:indexPath.row];
    NSLog(@",,,,,,,,%@", [d description]);
    //vehicleVC.vehicleType.vehicleTypeId = [d stringForKey:@"id"];
   
    VehicleType * _vehicleType = [[[VehicleType alloc] init] autorelease];
    _vehicleType.vehicleTypeId = [d stringForKey:@"id"];
     NSLog(@".....%@",_vehicleType.vehicleTypeId);
    
    vehicleVC.vehicleType = _vehicleType;
    NSLog(@",,,,,%@",vehicleVC.vehicleType.vehicleTypeId);
   // vehicleVC.ID = [d stringForKey:@"id"];
    vehicleVC.isFromUsedCars = NO;
    [self.viewController.navigationController pushViewController:vehicleVC animated:YES];
    [vehicleVC release];
}

@end
