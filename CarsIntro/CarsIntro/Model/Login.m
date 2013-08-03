//
//  Login.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "Login.h"

@implementation Login

-(id)init
{
    if (self = [super init]) {
        self.userId = @"";
        self.nickName = @"";
        self.score = @"";
    }
    return self;
}

-(void)dealloc
{
    [_userId release];
    [_nickName release];
    [_score release];
    [super dealloc];
}

//"userid":"用户编号","nickname":"昵称","jifen":"积分"
-(void)fromDic:(NSDictionary *)loginDic
{
    self.userId = [loginDic objectForKey:@"userid"];
    self.nickName = [loginDic objectForKey:@"nickname"];
    self.score = [loginDic objectForKey:@"jifen"];
}

@end
