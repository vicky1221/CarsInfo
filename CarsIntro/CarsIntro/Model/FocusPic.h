//
//  FocusPic.h
//  CarsIntro
//
//  Created by Cao Vicky on 7/10/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FocusPic : NSObject

//获取焦点图
//"picName":"Bill" ,"picPath":"Gates"
@property (nonatomic, retain) NSString *picName;
@property (nonatomic, retain) NSString *picPath;

- (void)fromDic:(NSDictionary *)focusPicDic;

@end
