//
//  SafeViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-29.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface SafeViewController : KBaseViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnTime;

@property (retain, nonatomic) IBOutlet UITextField *priceTextField;


@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIPickerView *pickView;
@property (retain, nonatomic) NSMutableArray * pickerArray;
@end
