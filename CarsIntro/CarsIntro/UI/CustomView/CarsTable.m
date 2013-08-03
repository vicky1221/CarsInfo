//
//  CarsTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CarsTable.h"
#import "CarsCell.h"
#import "TypeViewController.h"
#import "CarsViewController.h"
@implementation CarsTable

-(void)myInit
{
    self.newCarsArray = [NSMutableArray array];
    self.usedCarsArray = [NSMutableArray array];
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
    [_newCarsArray release];
    [_usedCarsArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 对于bool的判断一般直接判断变量  不要==yes 你可以搜搜为什么
//    if (new == YES) { //
//        return [self.newCarsArray count];
//    }else
//    {
//        return [self.usedCarsArray count];
//    }
    if (self.isNewCarData) { 
        return [self.newCarsArray count];
    }else
    {
        return [self.usedCarsArray count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isNewCarData){
        return [[self.newCarsArray objectAtIndex:section] count];
    }else {
        return [[self.usedCarsArray objectAtIndex:section] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CarsCell";
   CarsCell * carsCell = (CarsCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (carsCell == nil) {
        carsCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    NSMutableArray *array = [NSMutableArray array];
    if (self.isNewCarData) {
        array = [self.newCarsArray objectAtIndex:indexPath.section];
    } else {
        array = [self.usedCarsArray objectAtIndex:indexPath.section];
    }
    VehicleType * _vehicleType = [array objectAtIndex:indexPath.row];
    [carsCell cellForDic:_vehicleType];
//    
//    if (new == YES) {
//        NSMutableArray * array = [self.newCarsArray objectAtIndex:indexPath.section];
//        VehicleType * _vehicleType = [array objectAtIndex:indexPath.row];
//        [carsCell cellForDic:_vehicleType];
//    }else {
//        NSMutableArray * array = [self.usedCarsArray objectAtIndex:indexPath.section];
//        VehicleType * _vehicleType = [array objectAtIndex:indexPath.row];
//        [carsCell cellForDic:_vehicleType];
//    }
    return carsCell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"捷豹";
            break;
        case 1:
            return @"路虎";
            break;
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    //[self.viewController.navigationController pushViewController:vc animated:YES];
    if ([self.carsDelegate respondsToSelector:@selector(viewController)]) {
        NSMutableArray *array = [NSMutableArray array];
        if (self.isNewCarData) {
            array = [self.newCarsArray objectAtIndex:indexPath.section];
        } else {
            array = [self.usedCarsArray objectAtIndex:indexPath.section];
        }
        VehicleType *_vehicleType = [array objectAtIndex:indexPath.row];
        TypeViewController *vc = [[TypeViewController alloc] initWithNibName:@"TypeViewController" bundle:nil];
        vc.vehicleType = _vehicleType;
        [[self.carsDelegate viewController].navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

@end
