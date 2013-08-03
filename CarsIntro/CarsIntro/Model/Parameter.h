//
//  Parameter.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parameter : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;

-(void)fromDic:(NSDictionary *)parameterDic;

@end
