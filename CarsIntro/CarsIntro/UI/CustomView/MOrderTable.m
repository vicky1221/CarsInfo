//
//  MOrderTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MOrderTable.h"
#import "MOrderCell.h"
#import "Order.h"
@implementation MOrderTable

-(void)myInit
{
    self.mOrderArray = [NSMutableArray array];
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
    [_mOrderArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mOrderArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"MOrderCell";
    MOrderCell * mOrderCell = (MOrderCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (mOrderCell == nil) {
        mOrderCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    mOrderCell.backgroundColor = [UIColor clearColor];
    Order * order = [self.mOrderArray objectAtIndex:indexPath.row];
    [mOrderCell cellForDic:order];
    return mOrderCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
