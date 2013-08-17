//
//  SetTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "SetTable.h"
#import "SetCell.h"
#import "FBackViewController.h"
#import "ShopViewController.h"
@implementation SetTable

-(void)myInit
{
    self.setArray = [NSMutableArray array];
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
    [_setArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.setArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"SetCell";
    SetCell * setCell = (SetCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (setCell == nil) {
        setCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    NSDictionary * dic = [self.setArray objectAtIndex:indexPath.row];
    [setCell cellForDic:dic];
    
    if (indexPath.row == 2) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(240, 11, 30, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [dic objectForKey:@"CFBundleVersion"];
        setCell.accessoryType = UITableViewCellAccessoryNone;
        setCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [setCell addSubview:label];
        [label release];
    }
    
    return setCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            ShopViewController * shopVC = [[ShopViewController alloc] initWithNibName:@"ShopViewController" bundle:nil];
            [self.controller.navigationController pushViewController:shopVC animated:YES];
            [shopVC release];
        }
            break;
        case 1:{
            FBackViewController * fbVC = [[FBackViewController alloc] initWithNibName:@"FBackViewController" bundle:nil];
            [self.controller.navigationController pushViewController:fbVC animated:YES];
            [fbVC release];
        }
            break;
        default:
            break;
    }
}

@end
