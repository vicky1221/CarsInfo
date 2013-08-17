//
//  CityListCell.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "CityListCell.h"

@implementation CityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellForDic:(WeatherCity *)city {
    self.cityName.text = city.cityName;
    self.selectCity.text = city.selectCity;
    if (city.isSelect) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
//    if (self.isHasAccessType) {
//        if (city.isSelect) {
//            self.accessoryType = UITableViewCellAccessoryCheckmark;
//        } else {
//            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }
//    } else {
//        self.accessoryType = UITableViewCellAccessoryNone;
//    }
    
}

@end
