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
#import "UsedCarInfo.h"
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
    if (self.isNewCarData) { 
        return [self.newCarsArray count];
    }else
    {
        return [self.usedCarsArray count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *d = [NSDictionary dictionary];
    if (self.isNewCarData) {
        d = [self.newCarsArray objectAtIndex:section];
    } else {
        d = [self.usedCarsArray objectAtIndex:section];
    }
    NSArray *array = [d objectForKey:@"data"];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CarsCell";
   CarsCell * carsCell = (CarsCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (carsCell == nil) {
        carsCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    NSDictionary *d = [NSDictionary dictionary];
    if (self.isNewCarData) {
        d = [self.newCarsArray objectAtIndex:indexPath.section];
    } else {
        d = [self.usedCarsArray objectAtIndex:indexPath.section];
    }
    NSArray *array = [d objectForKey:@"data"];
    if (array.count>0) {
        UsedCarInfo * _usedCarInfo = [array objectAtIndex:indexPath.row];
        [carsCell cellForDic:_usedCarInfo];
    }
    
    return carsCell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *d = [NSDictionary dictionary];
    if (self.isNewCarData) {
        d = [self.newCarsArray objectAtIndex:section];
    } else {
        d = [self.usedCarsArray objectAtIndex:section];
    }
    return [d objectForKey:@"title"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    //[self.viewController.navigationController pushViewController:vc animated:YES];
    TypeViewController *vc = [[TypeViewController alloc] initWithNibName:@"TypeViewController" bundle:nil];
    if ([self.carsDelegate respondsToSelector:@selector(viewController)]) {
        if (self.isNewCarData) {
            UsedCarInfo *_usedCarInfo = [self.newCarsArray objectAtIndex:indexPath.row];
            vc.usedCarInfo = _usedCarInfo;
            vc.isNewCarData = YES;
        } else {
            UsedCarInfo *_usedCarInfo = [self.usedCarsArray objectAtIndex:indexPath.row];
            vc.isNewCarData = NO;
            vc.usedCarInfo = _usedCarInfo;
        }
        [[self.carsDelegate viewController].navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

@end
