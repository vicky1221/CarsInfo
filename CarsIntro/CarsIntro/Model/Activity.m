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
    }
    return self;
}

-(void)dealloc
{
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

//title":"标题","jzsj":"截止时间","content":"内容","zsl":"总数量","sysl":"剩余数量"
-(void)fromDic:(NSDictionary *)activityDic
{
    self.activityId= [activityDic stringForKey:@"id"];
    self.tid = [activityDic stringForKey:@"tid"];
    self.title = [activityDic stringForKey:@"title"];
    
    NSString * string = [activityDic stringForKey:@"addtime"];
    self.addtime = [string dateStringSince1970];
    
    self.hits = [activityDic stringForKey:@"hits"];
    self.orders = [activityDic stringForKey:@"orders"];
    self.mrank = [activityDic stringForKey:@"mrank"];
    self.mgold = [activityDic stringForKey:@"mgold"];
    self.isshow = [activityDic stringForKey:@"isshow"];
    self.user = [activityDic stringForKey:@"admin"];
    self.jzsj = [activityDic stringForKey:@"jzsj"];
    self.content = [activityDic stringForKey:@"content"];
    self.zsl = [activityDic stringForKey:@"zsl"];
    self.pic = [NSString stringWithFormat:@"%@%@",ServerAddress ,[activityDic stringForKey:@"pic"]];
}


@end
