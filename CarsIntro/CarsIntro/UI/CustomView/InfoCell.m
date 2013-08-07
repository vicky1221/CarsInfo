//
//  InfoCell.m
//  CarsIntro
//
//  Created by Cao Vicky on 6/26/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "InfoCell.h"
#import "UIView+custom.h"
#import "NSString+Date.h"
@implementation InfoCell

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

- (void)cellForDic:(Information *)info {
//     NSString * infoId;
//     NSString * title;
//     NSString * content;
//     NSString * picPath;
//     NSString * time;

    float max = 0;
    if (info.hasPic) {
        // 如果有图片
        max = 230;
        [self.asyImageView LoadImage:info.picPath];
        [self.asyImageView enableHighlight:NO];
    } else {
        max = 300;
        self.asyImageView.backgroundColor = [UIColor clearColor];
    }
    _timeLabel.text = [[NSString stringWithFormat:@"%f", info.time] dateStringSinceNow];
    
    CGSize labelSize = [info.title sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(max, 30) lineBreakMode:_titleLabel.lineBreakMode];
    _titleLabel.frame = CGRectMake(VIEW_LEFT(_titleLabel), VIEW_TOP(_titleLabel), labelSize.width, labelSize.height);
    _titleLabel.text = info.title;
}

@end
