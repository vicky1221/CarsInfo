//
//  UCarViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "UCarViewController.h"
#import "UIView+custom.h"
#import "iToast.h"
@interface UCarViewController ()
{
    UIButton * btn;
}
@end

@implementation UCarViewController

#define Button_Width 143
#define Button_Height 79

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addButtonsToScrollView
{
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag  = i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"AccidentBtn_%d", i]] forState:UIControlStateNormal];
        float x = VIEW_WIDTH(self.scrollView)/2 + (i%2?1:-1)* (Button_Width/2 + 6);
        float y = i/2* (Button_Height + 20) +Button_Height/2 +20;
        button.frame = CGRectMake(0, 0, Button_Width, Button_Height);
        button.center = CGPointMake(x, y);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.25 *VIEW_HEIGHT(self.scrollView));
}

-(void)showCurrentTime
{
    NSDate * senddate=[NSDate date];
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
    
   self.strDate= [NSString stringWithFormat:@"%d-%@-%@ ", year, monthStr, dayStr];
    

    [self.btnTime setTitle:self.strDate forState:UIControlStateNormal];
    self.btnTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnTime.titleLabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addButtonsToScrollView];
    [self.contentView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.contentView.layer setShadowOpacity:0.5];
    [self.contentView.layer setShadowOffset:CGSizeMake(2, 2)];
    
    [self.btnGearbox setTitle:@"自动变速箱(AT)" forState:UIControlStateNormal];
    self.btnGearbox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnGearbox.titleLabel.font = [UIFont systemFontOfSize:14.0f];

    [self showCurrentTime];

    self.brandTextField.delegate = self;
    self.colorTextField.delegate = self;
    self.lengthTextField.delegate = self;
    self.describeTextField.delegate = self;
    self.personTextField.delegate = self;
    self.phoneTextField.delegate = self;
    
    self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    [self.datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.pickerArray = [NSArray arrayWithObjects:@"自动变速箱(AT)", @"手动变速箱(MT)", @"手自一体", @"无级变速箱(VCT)", @"无级变速(VDT)", @"双离合变速箱(DCT)", @"序列变速箱(AMT)", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.pickerArray release];
    [_strGearbox release];
    [_strDate release];
    [_scrollView release];
    [_contentView release];
    [_brandTextField release];
    [_colorTextField release];
    [_btnGearbox release];
    [_lengthTextField release];
    [_btnTime release];
    [_describeTextField release];
    [_personTextField release];
    [_phoneTextField release];
    [_dataPickerView release];
    [_datePicker release];
    [_dataPickerLabel release];
    [_pickerView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setBrandTextField:nil];
    [self setColorTextField:nil];
    [self setBtnGearbox:nil];
    [self setLengthTextField:nil];
    [self setBtnTime:nil];
    [self setDescribeTextField:nil];
    [self setPersonTextField:nil];
    [self setPhoneTextField:nil];
    [self setDataPickerView:nil];
    [self setDatePicker:nil];
    [self setDataPickerLabel:nil];
    [self setPickerView:nil];
    [super viewDidUnload];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publish:(id)sender {
}

- (IBAction)gearboxButton:(id)sender {
//    [self.dataPickerView bringSubviewToFront:self.pickerView
//     ];
    [self.datePicker removeFromSuperview];
    [self.dataPickerView addSubview:self.pickerView];
    self.dataPickerLabel.text = @"选择变速箱类型";
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.8 *VIEW_HEIGHT(self.scrollView));
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, (VIEW_HEIGHT(self.view)- VIEW_HEIGHT(self.dataPickerView)), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    } completion:^(BOOL finished) {
        nil;
    }];

}

- (IBAction)timeButton:(id)sender {
    [self.pickerView removeFromSuperview];
    [self.dataPickerView addSubview:self.datePicker];
    self.dataPickerLabel.text = @"选择上牌日期";
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.8 *VIEW_HEIGHT(self.scrollView));
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, (VIEW_HEIGHT(self.view)- VIEW_HEIGHT(self.dataPickerView)), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

-(void)buttonPressed:(id)sender
{
    btn = (UIButton *)sender;
    UIActionSheet * as=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [as showInView:self.view];
    [as release];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerController * ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    if (buttonIndex==0) {
        NSLog(@"相机");
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        if (TARGET_IPHONE_SIMULATOR) {
            [ipc release];
            return;
        }
    }
    if (buttonIndex==1) {
        NSLog(@"相册");
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentModalViewController:ipc animated:YES];
    [ipc release];
}

//选择相片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}
//取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
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

#pragma mark - datePicker Action

-(void)pickerChanged:(id)sender
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.strDate = [dateFormatter stringFromDate:[sender date]];
    [dateFormatter release];
}

- (IBAction)cancel:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.25 *VIEW_HEIGHT(self.scrollView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (IBAction)determine:(id)sender {
    [self.btnTime setTitle:self.strDate forState:UIControlStateNormal];
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    self.strGearbox = [self.pickerArray objectAtIndex:row];
    [self.btnGearbox setTitle:self.strGearbox forState:UIControlStateNormal];
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.25 *VIEW_HEIGHT(self.scrollView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

#pragma mark - TextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.75 *VIEW_HEIGHT(self.scrollView));
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.25 *VIEW_HEIGHT(self.scrollView));
    return YES;
}

@end
