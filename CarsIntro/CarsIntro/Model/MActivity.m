//
//  MActivity.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MActivity.h"

@implementation MActivity

-(id)init
{
    self = [super init];
    if (self) {
        self.useTime = @"";
        self.yhjId = @"";
        self.title = @"";
    }
    return self;
}

-(void)dealloc
{
    [_useTime release];
    [_yhjId release];
    [_title release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)MActivityDic
{
    self.useTime = [MActivityDic stringForKey:@"useTime"];
    self.yhjId = [MActivityDic stringForKey:@"yhjId"];
    self.title = [MActivityDic stringForKey:@"title"];
}

@end
