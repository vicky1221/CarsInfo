//
//  UCarViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface UCarViewController : KBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UITextField *brandTextField;  //品牌

@property (retain, nonatomic) IBOutlet UITextField *colorTextField;

@property (retain, nonatomic) IBOutlet UITextField *lengthTextField;


@property (retain, nonatomic) IBOutlet UIButton *btnGearbox;

@property (retain, nonatomic) IBOutlet UIButton *btnTime;
@property (retain, nonatomic) IBOutlet UITextField *describeTextField;

@property (retain, nonatomic) IBOutlet UITextField *personTextField;

@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;

@property (retain, nonatomic) IBOutlet UIView *dataPickerView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (copy, nonatomic) NSString * strDate;
@property (copy, nonatomic) NSString * strGearbox;
@property (retain, nonatomic) IBOutlet UILabel *dataPickerLabel;
@property (retain, nonatomic) NSArray * pickerArray;

@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;

@property (assign) BOOL btn1HasImage;
@property (assign) BOOL btn2HasImage;
@property (assign) BOOL btn3HasImage;
@property (assign) BOOL btn4HasImage;


@property (retain, nonatomic) IBOutlet UIButton *senderButton;

@end
