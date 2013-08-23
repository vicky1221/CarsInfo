//
//  MActivityTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MActivityTable.h"
#import "MActivityCell.h"
#import "MActivity.h"
@implementation MActivityTable

-(void)myInit
{
    self.MActivityArray = [NSMutableArray array];
    self.delegate = self;
    self.dataSource = self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self myInit];
    }
    return self;
}

-(void)dealloc
{
    [_MActivityArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.MActivityArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"MActivityCell";
    MActivityCell * mActivityCell = (MActivityCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (mActivityCell == nil) {
        mActivityCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    mActivityCell.backgroundColor = [UIColor clearColor];
    MActivity * mactivity = [self.MActivityArray objectAtIndex:indexPath.row];
    [mActivityCell cellForDic:mactivity];
    return mActivityCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
