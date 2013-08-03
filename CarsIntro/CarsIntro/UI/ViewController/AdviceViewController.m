//
//  AdviceViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "AdviceViewController.h"
#import "iToast.h"
@interface AdviceViewController ()

@end

@implementation AdviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.placeholder = @"请输入投诉内容";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

- (IBAction)titleButton:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        [[iToast makeText:@"请输入投诉内容."] show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        [[iToast makeText:@"投诉建议发送成功."] show];
    }
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
