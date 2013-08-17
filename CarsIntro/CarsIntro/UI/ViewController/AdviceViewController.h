//
//  AdviceViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "CPTextViewPlaceholder.h"
@interface AdviceViewController : KBaseViewController
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) IBOutlet UILabel *placeHolder;

- (IBAction)titleButton:(id)sender;
- (IBAction)back:(id)sender;
@end
