//
//  ActivitiesTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "ActivitiesTable.h"
#import "ActivitiesCell.h"
@implementation ActivitiesTable

-(void)myInit
{
    self.activityArray = [NSMutableArray array];
    self.couponArray = [NSMutableArray array];
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
    [_activityArray release];
    [_couponArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isActivityData) {
        return [self.activityArray count];
    }else
    {
        return [self.couponArray count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"ActivitiesCell";
    ActivitiesCell * activitiesCell = (ActivitiesCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (activitiesCell == nil) {
        activitiesCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    if (self.isActivityData) {
        Activity * act = [self.activityArray objectAtIndex:indexPath.row];
        [activitiesCell cellForDic:act];
    }else {
        Activity * act = [self.couponArray objectAtIndex:indexPath.row];
        [activitiesCell cellForDic:act];
    }
    return activitiesCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
