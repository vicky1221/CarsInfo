//
//  Activity.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

//"id": "6",
//"tid": "24",
//"title": "\u6d4b\u8bd5\u622a\u6b62\u65f6\u95f4",
//"style": "",
//"trait": "",
//"gourl": "",
//"addtime": "1375147980",
//"hits": "0",
//"orders": "0",
//"mrank": "0",
//"mgold": "0",
//"isshow": "1",
//"description": "",
//"htmlurl": "",
//"htmlfile": "",
//"user": "admin",
//"jzsj": "1377135180",
//"content": "\u6d4b\u8bd5\u622a\u6b62\u65f6\u95f4\u6d4b\u8bd5\u622a\u6b62\u65f6\u95f4\u6d4b\u8bd5\u622a\u6b62\u65f6\u95f4\u6d4b\u8bd5\u622a\u6b62\u65f6\u95f4",
//"zsl": "100",
//"pic": "\/qiche\/uploads\/2013\/07\/301030013374.jpg",
//"url": "\/qiche\/channel\/huodong\/61.html"

//活动列表和优惠劵使用同一个
//title":"标题","jzsj":"截止时间","content":"内容","zsl":"总数量","sysl":"剩余数量"
@property (nonatomic, copy) NSString * activityId;
@property (nonatomic, copy) NSString * tid;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, copy) NSString * hits;
@property (nonatomic, copy) NSString * orders;
@property (nonatomic, copy) NSString * mrank;
@property (nonatomic, copy) NSString * mgold;
@property (nonatomic, copy) NSString * isshow;
@property (nonatomic, copy) NSString *user; //"user" : "admin"
@property (nonatomic, copy) NSString * jzsj;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * zsl;
@property (nonatomic, copy) NSString * pic;

//@property (nonatomic, copy) NSString * totalNumber;     //总数量
//@property (nonatomic, copy) NSString * numberRemaining; //剩余数量

-(void)fromDic:(NSDictionary *)activityDic;

@end
