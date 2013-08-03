//
//  Login.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject

//用户登录
//"userid":"用户编号","nickname":"昵称","jifen":"积分"
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * nickName; 
@property (nonatomic, copy) NSString * score;

- (void)fromDic:(NSDictionary *)loginDic;

@end
