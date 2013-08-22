//
//  Medal.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "Medal.h"

@implementation Medal

-(id)init
{
    if (self = [super init]) {
        self.addtime = @"";
        self.medalID = @"";
        self.user = @"";
        self.title = @"";
    }
    return self;
}

-(void)dealloc
{
    [_addtime release];
    [_medalID release];
    [_user release];
    [_title release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)medalDic
{
    NSString * string = [medalDic stringForKey:@"addtime"];
    self.addtime = [string dateFormateSince1970];
    self.medalID = [medalDic stringForKey:@"id"];
    self.user = [medalDic stringForKey:@"user"];
    self.title = [medalDic stringForKey:@"title"];
}

@end