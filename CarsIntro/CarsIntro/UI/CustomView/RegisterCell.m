//
//  RegisterCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-10.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "RegisterCell.h"

@implementation RegisterCell

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

- (void)cellForStr:(NSString *)str
{
    _textField.placeholder = str;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
}
- (void)dealloc {
    [_textField release];
    [super dealloc];
}

@end
