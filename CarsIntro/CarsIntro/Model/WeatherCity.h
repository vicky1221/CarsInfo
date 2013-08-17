//
//  WeatherCity.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherCity : NSObject

@property (nonatomic, retain) NSString *cityCode;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *cityID;
@property (nonatomic, retain) NSString *selectCity;
@property (nonatomic, retain) NSString *provinceID;
@property (nonatomic, assign) BOOL      isSelect;

- (void)fromDic:(NSDictionary *)dic;
- (NSDictionary *)toDic;

@end
