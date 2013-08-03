//
//  SetCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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

-(void)cellForDic:(NSDictionary *)dic
{
    NSLog(@"%@", [dic description]);
    _image.image = [UIImage imageNamed:[dic objectForKey:@"KEY_IMAGE"]];
    _label.text = [dic objectForKey:@"KEY_INFO"];
}

- (void)dealloc {
    [_image release];
    [_label release];
    [super dealloc];
}
@end
