//
//  Parameter.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "Parameter.h"

@implementation Parameter

-(id)init
{
    if (self = [super init]) {
        self.title = @"";
        self.content = @"";
    }
    return self;
}

-(void)dealloc
{
    [_title release];
    [_content release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)parameterDic
{
    
}

@end
