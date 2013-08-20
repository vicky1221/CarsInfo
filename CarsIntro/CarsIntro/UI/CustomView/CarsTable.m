//
//  CarsTable.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CarsTable.h"
#import "CarsCell.h"
#import "TypeViewController.h"
#import "CarsViewController.h"
#import "UsedCarInfo.h"
#import "NSDictionary+type.h"
@implementation CarsTable

-(void)myInit
{
    self.newCarsArray = [NSMutableArray array];
    self.usedCarsArray = [NSMutableArray array];
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
    [_newCarsArray release];
    [_usedCarsArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.newCarsArray.count;
    // 对于bool的判断一般直接判断变量  不要==yes 你可以搜搜为什么
//    if (new == YES) { //
//        return [self.newCarsArray count];
//    }else
//    {
//        return [self.usedCarsArray count];
//    }
//    if (self.isNewCarData) { 
//        return [self.newCarsArray count];
//    }else
//    {
//        return [self.usedCarsArray count];
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [[self.newCarsArray objectAtIndex:section] objectForKey:@"subtype"];
    return [array count];
//    if (self.isNewCarData){
//        return [self.newCarsArray count];
//    }else {
//        return [self.usedCarsArray count];
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CarsCell";
   CarsCell * carsCell = (CarsCell *)[self dequeueReusableCellWithIdentifier:cellID];
    if (carsCell == nil) {
        carsCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    NSArray *array = [[self.newCarsArray objectAtIndex:indexPath.section] objectForKey:@"subtype"];
    NSDictionary *d = [array objectAtIndex:indexPath.row];
    
//    _titleLabel.text = usedCarInfo.title;
//    _priceLabel.text = usedCarInfo.addTime;
//    _typeLable.text = usedCarInfo.className;
//    _displacementLabel.text = usedCarInfo.orders;
    
    carsCell.titleLabel.text = [d stringForKey:@"classname"];
    carsCell.priceLabel.text = [d stringForKey:@"zhidaojia"];
    carsCell.typeLable.text = [d stringForKey:@"chejibie"];
    carsCell.displacementLabel.text = [d stringForKey:@"pailiang"];
//    UsedCarInfo *infor = [[[UsedCarInfo alloc] init] autorelease];
//    [infor fromDic:d];
//    [carsCell cellForDic:infor];
//    if (self.isNewCarData) {
//        UsedCarInfo * _usedCarInfo = [self.newCarsArray objectAtIndex:indexPath.row];
//        [carsCell cellForDic:_usedCarInfo];
//    } else {
//        UsedCarInfo * _usedCarInfo = [self.usedCarsArray objectAtIndex:indexPath.row];
//        [carsCell cellForDic:_usedCarInfo];
//    }
    return carsCell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *d = [self.newCarsArray objectAtIndex:section];
    return [d objectForKey:@"classname"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TypeViewController *vc = [[TypeViewController alloc] initWithNibName:@"TypeViewController" bundle:nil];
    NSArray *array = [[self.newCarsArray objectAtIndex:indexPath.section] objectForKey:@"subtype"];
    NSDictionary *d = [array objectAtIndex:indexPath.row];
    vc.tid = [d objectForKey:@"tid"];
    vc.title = [d objectForKey:@"title"];
//    UsedCarInfo *_usedCarInfo = [self.newCarsArray objectAtIndex:indexPath.row];
//    vc.usedCarInfo = _usedCarInfo;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
