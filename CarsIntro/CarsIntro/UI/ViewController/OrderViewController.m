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
#import "NSString+Date.h"
#import "WebRequest.h"
#import "JSON.h"
@interface OrderViewController ()<ASIHTTPRequestDelegate>

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
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"currentdate:%@", self.strDate);
    [dateFormatter release];
    
    self.dataPicker.minimumDate = [NSDate date];
    [self.timeButton setTitle:self.strDate forState:UIControlStateNormal];
    
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self shadowView:self.contentView];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:120];
    [[WebRequest instance] clearRequestWithTag:121];
    [[WebRequest instance] clearRequestWithTag:122];
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
    NSLog(@"%@",self.timeButton.titleLabel.text);
    [self resignTextField];
    if (!self.nameTextField || [self.nameTextField.text length] == 0) {
        [[iToast makeText:@"姓名不可为空."] show];
        return;
    }
    if (!self.phoneTextField || [self.phoneTextField.text length] == 0) {
        [[iToast makeText:@"联系方式不可为空."] show];
        return;
    }
    
    [self performSelector:@selector(sendAPI)];

}

- (void)sendAPI {
//    http://www.ard9.com/qiche/index.php?c=member&a=release&tid=34&hand=160135389&id=&go=1&from=app
//    预约试驾
//    http://www.ard9.com/qiche/index.php?c=member&a=release&tid=35&hand=160135389&id=&go=1&from=app
//    预约保养
//    http://www.ard9.com/qiche/index.php?c=member&a=release&tid=36&hand=160135389&id=&go=1&from=app
//    预约维修
//    参数:
//    
//    姓名name
//    电话 tel
//    时间shijian
//    备注  benzhu 
//    用户编号 uid
    NSString *time = @"";
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:self.strDate];
    time = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]];
    [dateFormatter release];
    
    if ([self.titleLabel.text isEqualToString:@"预约试驾"]) {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=release&tid=34&hand=160135389&id=&go=1&from=app&name=%@&tel=%@&shijian=%@&benzhu=%@&uid=%@", self.nameTextField.text, self.phoneTextField.text, self.strDate, self.remarkTextField.text, [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:120];
    } else if([self.titleLabel.text isEqualToString:@"预约保养"]) {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=release&tid=35&hand=160135389&id=&go=1&from=app&name=%@&tel=%@&shijian=%@&benzhu=%@&uid=%@", self.nameTextField.text, self.phoneTextField.text, self.strDate, self.remarkTextField.text, [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:121];
    } else if([self.titleLabel.text isEqualToString:@"预约维修"]) {
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=release&tid=36&hand=160135389&id=&go=1&from=app&name=%@&tel=%@&shijian=%@&benzhu=%@&uid=%@", self.nameTextField.text, self.phoneTextField.text, self.strDate, self.remarkTextField.text, [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:122];
    }
//    "id":"92","tid":"34","title":"","style":"","trait":"","gourl":"","addtime":"1377103646","hits":"0","orders":"0","mrank":"0","mgold":"0","isshow":"0","description":"","htmlurl":"","htmlfile":"","1":"1","user":"","name":"df","tel":"adf","shijian":"0","url":"\/qiche\/channel\/yuyue\/921.html","yysl":"0","from":"\u5c71\u897f\u541b\u548c\u5965\u8fea"}
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"%@......", @"123");
    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        [self back:nil];
    }
    [[iToast makeText: [dic objectForKey:@"msg"]] show];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"网络错误.");
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
//    self.strDate= [NSString stringWithFormat:@"%f",[[sender date] timeIntervalSince1970]];
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
