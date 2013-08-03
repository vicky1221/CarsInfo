//
//  OrderViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
@interface OrderViewController : KBaseViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *nameTextField;

@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;

@property (retain, nonatomic) IBOutlet UITextField *remarkTextField; //备注


@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *orderLabel;

@property (retain, nonatomic) IBOutlet UIButton *timeButton;

- (IBAction)btnCancel:(id)sender; //取消

- (IBAction)btnDetermine:(id)sender; //确定

@property (retain, nonatomic) IBOutlet UIDatePicker *dataPicker;

@property (retain, nonatomic) IBOutlet UIView *dataPickerView;

@property (copy, nonatomic) NSString * strDate;

@end
