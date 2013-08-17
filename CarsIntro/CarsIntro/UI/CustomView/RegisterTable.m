//
//  RegisterTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-10.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "RegisterTable.h"
#import "RegisterCell.h"
@implementation RegisterTable

-(void)myInit
{
    self.registerArray = [NSMutableArray array];
    self.loginArray = [NSMutableArray array];
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.scrollEnabled = NO;
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
    if (self = [super initWithCoder:aDecoder]) {
        [self myInit];
    }
    return self;
}

-(void)dealloc
{
    [_registerArray release];
    [_loginArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isRegister) {
        return [self.loginArray count];
    } else {
        return [self.registerArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"RegisterCell";
    RegisterCell * registerCell = (RegisterCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (registerCell == nil) {
        registerCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    if (indexPath.row == 1 || indexPath.row == 2) {
        //加密
        registerCell.textField.secureTextEntry = YES;
    }
    if (self.isRegister) {
        NSString * str = [self.loginArray objectAtIndex:indexPath.row];
        [registerCell cellForStr:str];
    } else {
        NSString * str = [self.registerArray objectAtIndex:indexPath.row];
        [registerCell cellForStr:str];
    }
    return registerCell;
}

@end
