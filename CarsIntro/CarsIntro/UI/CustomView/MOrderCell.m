//
//  MOrderCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MOrderCell.h"
#import "NSString+Date.h"

@implementation MOrderCell

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

- (void)cellForDic:(Order *)order
{
//} else if (request.tag == 106) {
//    NSArray * array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
//    for (NSDictionary *d in array) {
//        Order * order = [[Order alloc] init];
//        [order fromDic:d];
//        order.type = @"预约保养";
//        [self.mOrderTable.mOrderArray addObject:order];
//        [order release];
//    }
//} else if (request.tag == 107) {
//    NSArray * array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
//    for (NSDictionary *d in array) {
//        Order * order = [[Order alloc] init];
//        [order fromDic:d];
//        order.type = @"预约维修";
    
    self.nameLabel.text = order.user;
    self.phoneLabel.text = order.phone;
    self.timeLabel.text = order.time;
    self.itemLabel.text = order.type;
    if ([order.type isEqualToString:@"预约试驾"]) {
        self.itemLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:142.0/255.0 blue:3.0/255.0 alpha:1];
    } else if([order.type isEqualToString:@"预约保养"]) {
        self.itemLabel.textColor = [UIColor colorWithRed:171.0/255.0 green:29.0/255.0 blue:15.0/255.0 alpha:1];
    } else if([order.type isEqualToString:@"预约维修"]) {
        self.itemLabel.textColor = [UIColor colorWithRed:10.0/255.0 green:104.0/255.0 blue:174.0/255.0 alpha:1];
    }
    
    self.stateLabel.text = order.title;
    self.stateLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:43.0/255.0 blue:155.0/255.0 alpha:1];
}

- (void)dealloc {
    [_nameLabel release];
    [_phoneLabel release];
    [_timeLabel release];
    [_itemLabel release];
    [_stateLabel release];
    [super dealloc];
}
@end
