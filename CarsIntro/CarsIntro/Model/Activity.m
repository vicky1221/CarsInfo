//
//  Activity.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "Activity.h"
#import "NSDictionary+type.h"
#import "NSString+Date.h"
@implementation Activity

-(id)init
{
    if (self = [super init]) {
        self.activityId = @"";
        self.tid = @"";
        self.title = @"";
        self.addtime = @"";
        self.hits = @"";
        self.orders = @"";
        self.mrank = @"";
        self.mgold = @"";
        self.isshow = @"";
        self.user = @"";
        self.jzsj = @"";
        self.content = @"";
        self.zsl = @"";
        self.pic = @"";
        self.sysl = @"";
    }
    return self;
}

-(void)dealloc
{
    [_sysl release];
    [_activityId release];
    [_tid release];
    [_title release];
    [_addtime release];
    [_hits release];
    [_orders release];
    [_mrank release];
    [_mgold release];
    [_isshow release];
    [_user release];
    [_jzsj release];
    [_content release];
    [_zsl release];
    [_pic release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)activityDic
{
    self.activityId= [activityDic stringForKey:@"id"];
    self.tid = [activityDic stringForKey:@"tid"];
    self.title = [activityDic stringForKey:@"title"];
    
    NSString * string = [activityDic stringForKey:@"addtime"];
    self.addtime = [string dateFormateSince1970];
    self.hits = [activityDic stringForKey:@"hits"];
    self.orders = [activityDic stringForKey:@"orders"];
    self.mrank = [activityDic stringForKey:@"mrank"];
    self.mgold = [activityDic stringForKey:@"mgold"];
    self.isshow = [activityDic stringForKey:@"isshow"];
    self.user = [activityDic stringForKey:@"user"]; 
    self.jzsj = [activityDic stringForKey:@"jzsj"]; // 截止时间
    self.content = [activityDic stringForKey:@"content"]; 
    self.zsl = [activityDic stringForKey:@"zsl"]; // 总数量
    self.pic = [NSString stringWithFormat:@"%@%@",ServerAddress ,[activityDic stringForKey:@"pic"]];
    
    if (([self.zsl integerValue]<=[self.sysl integerValue])|| [[NSDate date] timeIntervalSince1970]<=[self.jzsj integerValue]) {
        self.isActivity = NO;
    } else {
        self.isActivity = YES;
    }
}

@end
