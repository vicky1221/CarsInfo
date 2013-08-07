//
//  SafeViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-29.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "SafeViewController.h"
#import "UIView+custom.h"
#import "iToast.h"
#import "DetailedViewController.h"
@interface SafeViewController ()

@end

@implementation SafeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)readPickerViewDataSource
{
    self.pickerArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=2013; i>1973; i--) {
        NSString * str = [NSString stringWithFormat:@"%d",i];
        [self.pickerArray addObject:str];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.priceTextField.keyboardType =  UIKeyboardTypeNumberPad;
    self.priceTextField.delegate = self;
    self.contentView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.view), VIEW_HEIGHT(self.contentView));
    [self readPickerViewDataSource];
    self.pickView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action

- (IBAction)quoteButton:(id)sender {
    if (![self.priceTextField.text length]) {
        [[iToast makeText:@"请正确填写"] show];
        return;
    }
    DetailedViewController * detailedVC = [[DetailedViewController alloc] initWithNibName:@"DetailedViewController" bundle:nil];
    [self.navigationController pushViewController:detailedVC animated:YES];
    [detailedVC release];
}

- (IBAction)timeButton:(id)sender {
    [self.priceTextField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake(0, VIEW_HEIGHT(self.view)-VIEW_HEIGHT(self.contentView), VIEW_WIDTH(self.contentView), VIEW_HEIGHT(self.contentView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (IBAction)backgroundTap:(id)sender {
    [self.priceTextField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.contentView), VIEW_HEIGHT(self.contentView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sure:(UIBarButtonItem *)sender {
    NSInteger row = [self.pickView selectedRowInComponent:0];
    [self.btnTime setTitle:[self.pickerArray objectAtIndex:row] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.contentView), VIEW_HEIGHT(self.contentView));
    } completion:^(BOOL finished) {
        nil;
    }];
}


#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerArray objectAtIndex:row];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.contentView), VIEW_HEIGHT(self.contentView));
    } completion:^(BOOL finished) {
        nil;
    }];

}

- (void)dealloc {
    [_pickerArray release];
    [_priceTextField release];
    [_btnTime release];
    [_contentView release];
    [_pickView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPriceTextField:nil];
    [self setBtnTime:nil];
    [self setContentView:nil];
    [self setPickView:nil];
    [super viewDidUnload];
}
@end
