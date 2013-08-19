//
//  DetailedTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-6.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "DetailedTable.h"
#import "DetailedCell.h"
@implementation DetailedTable

-(void)myInit
{
    self.detailedArray = [NSMutableArray array];
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
    [_detailedArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    switch (section) {
//        case 0:
//            return @"基本险";
//        case 1:
//            return @"全险";
//        default:
//            return nil;
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 22)];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    if (section == 0){
        titleLabel.text = @"基本险";
    }
    else if (section == 1)
    {
        titleLabel.text = @"全险";
    }
    [myView addSubview:titleLabel]; 
    
    return myView; 
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.detailedArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.detailedArray objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"DetailedCell";
    DetailedCell * detailedCell = (DetailedCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (detailedCell == nil) {
        detailedCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    if ((indexPath.section == 0&&indexPath.row ==4) || (indexPath.section == 1&&indexPath.row ==9)) {
        detailedCell.backgroundColor = [UIColor lightGrayColor];
    } else {
        detailedCell.backgroundColor = [UIColor clearColor];
    }
    NSArray * array = [self.detailedArray objectAtIndex:indexPath.section];
    Parameter * _parameter = [array objectAtIndex:indexPath.row];
    [detailedCell cellForDic: _parameter];
    return detailedCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
