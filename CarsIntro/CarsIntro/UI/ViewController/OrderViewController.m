//
//  OrderViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "OrderViewController.h"
#import "iToast.h"
#import "UIView+custom.h"
@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showCurrentTime
{
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    [dateformatter release];
    
    NSCalendar * cal=[NSCalendar currentCalendar];
    NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    NSString * monthStr = [NSString string];
    NSString * dayStr = [NSString string];
    
    if (month<10) {
        monthStr = [NSString stringWithFormat:@"0%d",month];
    } else {
        monthStr = [NSString stringWithFormat:@"%d",month];
    }
    
    if (day<10) {
        dayStr = [NSString stringWithFormat:@"0%d",day];
    } else {
        dayStr = [NSString stringWithFormat:@"%d",day];
    }
    
    self.strDate = [NSString stringWithFormat:@"%d-%@-%@ %@", year, monthStr, dayStr, locationString];
    
    
    [self.timeButton setTitle:self.strDate forState:UIControlStateNormal];
    
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.contentView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.contentView.layer setShadowOpacity:0.3];
    [self.contentView.layer setShadowRadius:1];
    [self.contentView.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    
    [self showCurrentTime];
    
    self.phoneTextField.delegate = self;
    self.nameTextField.delegate = self;
    self.remarkTextField.delegate = self;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.nameTextField.autocorrectionType = YES; //纠错
    self.remarkTextField.autocorrectionType = YES;
    
    self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    [self.dataPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resignTextField
{
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.remarkTextField resignFirstResponder];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)orderBtn:(id)sender {
    [self resignTextField];
    if (!self.nameTextField || [self.nameTextField.text length] == 0) {
        [[iToast makeText:@"姓名不可为空."] show];
        return;
    }
    if (!self.phoneTextField || [self.phoneTextField.text length] == 0) {
        [[iToast makeText:@"联系方式不可为空."] show];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[iToast makeText:@"预约发送成功."] show];
}

- (IBAction)timeBtn:(id)sender {
    [self resignTextField];
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, (VIEW_HEIGHT(self.view)- VIEW_HEIGHT(self.dataPickerView)), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    } completion:^(BOOL finished) {
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.13);
    }];
}

-(void)pickerChanged:(id)sender
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.strDate = [dateFormatter stringFromDate:[sender date]];
    [dateFormatter release];
}

- (void)dealloc {
    [_strDate release];
    [_nameTextField release];
    [_phoneTextField release];
    [_contentView release];
    [_titleLabel release];
    [_orderLabel release];
    [_timeButton release];
    [_remarkTextField release];
    [_dataPicker release];
    [_dataPickerView release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPhoneTextField:nil];
    [self setContentView:nil];
    [self setTitleLabel:nil];
    [self setOrderLabel:nil];
    [self setTimeButton:nil];
    [self setRemarkTextField:nil];
    [self setDataPicker:nil];
    [self setDataPickerView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
- (IBAction)btnCancel:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView));
    } completion:^(BOOL finished) {
        nil;
    }];
    
}

- (IBAction)btnDetermine:(id)sender {
    
    [self.timeButton setTitle:self.strDate forState:UIControlStateNormal];
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView));
    } completion:^(BOOL finished) {
        nil;
    }];    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self btnCancel:nil];
    if (textField == self.remarkTextField) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 100);
        }];
    }
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.13);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
