//
//  Information.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject

//资讯列表


//"gourl" : "",
//"hits" : "0",
//"htmlfile" : "",
//"htmlurl" : "",



//"mgold" : "0.00",
//"mrank" : "0",
//"orders" : "0",
//"style" : "",


//"trait" : "",
//"url" : "/qiche/article/581.html",

@property (nonatomic, retain) NSString * infoId; //"id" : "58"
@property (nonatomic, retain) NSString * title; //"title" : "测试带图片的资讯",
@property (nonatomic, retain) NSString * content; //"description" : "",
@property (nonatomic, retain) NSString * picPath; //"litpic" : "/qiche/uploads/2013/07/291429239094.png",
@property (nonatomic) float  time; //"addtime" : "1375079280",
@property (assign)          BOOL       hasPic; //"isshow" : "1",
@property (nonatomic, retain) NSString *tid; //"tid" : "33",
@property (nonatomic, retain) NSString *user; //"user" : "admin"
@property (nonatomic, retain) NSString * url;
-(void)fromDic:(NSDictionary *)infoDic;

@end
