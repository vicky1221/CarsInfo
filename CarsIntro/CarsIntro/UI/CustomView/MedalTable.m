//
//  MedalTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MedalTable.h"
#import "MedalCell.h"
#import "MDetailsViewController.h"
@implementation MedalTable

-(void)myInit
{
    self.medalArray = [NSMutableArray array];
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
    [_medalArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.medalArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"MedalCell";
    MedalCell * medalCell = (MedalCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (medalCell == nil) {
        medalCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    medalCell.backgroundColor = [UIColor clearColor];
    Medal * medal = [self.medalArray objectAtIndex:indexPath.row];
    [medalCell cellForDic:medal];
    return medalCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDetailsViewController * mdtailsVC = [[MDetailsViewController alloc] initWithNibName:@"MDetailsViewController" bundle:nil];
    Medal * medal = [self.medalArray objectAtIndex:indexPath.row];
    mdtailsVC.medal = medal;
    [self.viewController.navigationController pushViewController:mdtailsVC animated:YES];
    [mdtailsVC release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
