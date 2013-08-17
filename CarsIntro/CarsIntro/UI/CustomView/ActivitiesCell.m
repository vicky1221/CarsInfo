//
//  ActivitiesCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-10.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "ActivitiesCell.h"

@implementation ActivitiesCell

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

//@property (nonatomic, copy) NSString * title;
//@property (nonatomic, copy) NSString * time;     //截止时间
//@property (nonatomic, copy) NSString * content;
//@property (nonatomic, copy) NSString * totalNumber;     //总数量
//@property (nonatomic, copy) NSString * numberRemaining; //剩余数量

-(void)cellForDic:(Activity *)activity
{
    [self.asyImageView LoadImage:activity.pic];
    [self.asyImageView enableHighlight:NO];
    _titleLabel.text = activity.title;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 2;
    _timeLabel.text = activity.addtime;
    _footLabel.text = activity.jzsj;
}


- (void)dealloc {
    [_asyImageView release];
    [_titleLabel release];
    [_timeLabel release];
    [_footLabel release];
    [super dealloc];
}
@end
