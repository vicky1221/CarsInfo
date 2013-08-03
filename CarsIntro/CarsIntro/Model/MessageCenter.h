//
//  MessageCenter.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCenter : NSObject

//我的消息中心
//id:"编号",fxr:"发信人" ,content:"内容"，shijian:"发布时间"
@property (nonatomic, copy) NSString * messageId;
@property (nonatomic, copy) NSString * sender;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * time;

-(void)fromDic:(NSDictionary *)messageCenterDic;

@end
