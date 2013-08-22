//
//  ParameterTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "ParameterTable.h"


@implementation ParameterTable

-(void)myInit
{
    self.parameterArray = [NSMutableArray array];
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
    [_parameterArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
//    return [self.parameterArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parameterArray.count;
//    return [[self.parameterArray objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"ParameterCell";
    ParameterCell * parameterCell = (ParameterCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (parameterCell== nil) {
        parameterCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
//    NSMutableArray *array = [self.parameterArray objectAtIndex:indexPath.section];
    
//    Parameter * _parameter = [array objectAtIndex:indexPath.row];
    Parameter * _parameter = [self.parameterArray objectAtIndex:indexPath.row];
    [parameterCell cellForDic:_parameter];
    parameterCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return parameterCell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return nil;
//    switch (section) {
//        case 0:
//            return @"基本参数";
//            break;
//        case 1:
//            return @"车身";
//            break;
//        case 2:
//            return @"发动机";
//            break;
//        case 4:
//            return @"变速箱";
//        case 5:
//            return @"底盘转向";
//        case 6:
//            return @"车轮制动";
//        case 7:
//            return @"安全装备";
//        case 8:
//            return @"控制配置";
//        case 9:
//            return @"外部配置";
//        case 10:
//            return @"内部配置";
//        case 11:
//            return @"座椅配置";
//        case 12:
//            return @"多媒体配置";
//        case 13:
//            return @"灯光配置";
//        case 14:
//            return @"玻璃/后视镜";
//        case 15:
//            return @"空调/冰箱";
//        case 16:
//            return @"高科技配置";
//        default:
//            break;
//    }
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
