//
//  WeatherCity.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "WeatherCity.h"

@implementation WeatherCity

- (id)init
{
    self = [super init];
    if (self) {
        self.cityCode = @"";
        self.cityName = @"";
        self.cityID = @"";
        self.provinceID = @"";
        self.selectCity = @"";
        self.isSelect = NO;
    }
    return self;
}

- (void)dealloc {
    [_provinceID release];
    [_cityCode release];
    [_cityName release];
    [_cityID release];
    [_selectCity release];
    [super dealloc];
}

- (void)fromDic:(NSDictionary *)dic {
    self.provinceID = [dic objectForKey:@"province"];
    self.cityCode = [dic objectForKey:@"cityCode"];
    self.cityName = [dic objectForKey:@"cityName"];
    self.cityID = [dic objectForKey:@"cityID"];
    self.isSelect = YES;
}

- (NSDictionary *)toDic {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:self.cityCode forKey:@"cityCode"];
    [dic setObject:self.cityName forKey:@"cityName"];
    [dic setObject:self.cityID forKey:@"cityID"];
    [dic setObject:self.provinceID forKey:@"province"];
    return dic;
}

@end
