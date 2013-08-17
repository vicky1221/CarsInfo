//
//  CenterTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CenterTable.h"
#import "CenterCell.h"
#import "MessageViewController.h"
@implementation CenterTable

-(void)myInit
{
    self.centerArray = [NSMutableArray array];
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
    if (self == [super initWithCoder:aDecoder]) {
        [self myInit];
    }
    return self;
}

-(void)dealloc
{
    [_centerArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.centerArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CenterCell";
    CenterCell * centerCell = (CenterCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (centerCell == nil) {
        centerCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    centerCell.backgroundColor = [UIColor clearColor];
    MemberCenter * memberCenter = [self.centerArray objectAtIndex:indexPath.row];
    [centerCell cellForDic:memberCenter];
    return centerCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageViewController * messageVC = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    MemberCenter * memberCenter = [self.centerArray objectAtIndex:indexPath.row];
    messageVC.memberCenter = memberCenter;
    [self.viewController.navigationController pushViewController:messageVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
