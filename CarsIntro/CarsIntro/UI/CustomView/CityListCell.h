//
//  CityListCell.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherCity.h"

@interface CityListCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *cityName;
@property (nonatomic, assign) IBOutlet UILabel *selectCity;

@property (nonatomic, assign) BOOL isHasAccessType;

- (void)cellForDic:(WeatherCity *)city;


@end
