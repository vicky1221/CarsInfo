//
//  SetTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "SetTable.h"
#import "SetCell.h"
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
        label.text = [dic objectForKey:@"CFBundleVersion"];
        setCell.accessoryType = UITableViewCellAccessoryNone;
        [setCell addSubview:label];
        [label release];
    }
    
    return setCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
