//
//  AccidentViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface AccidentViewController : KBaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UITextView *textView;

@property (assign) BOOL btn1HasImage;
@property (assign) BOOL btn2HasImage;
@property (assign) BOOL btn3HasImage;
@property (assign) BOOL btn4HasImage;

@end
