//
//  RegisterCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-10.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
@interface RegisterCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UITextField *textField;

- (void)cellForStr:(NSString *)str;

@end
