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
#import "WebRequest.h"
#import "UIAsyncImageView.h"
#import "JSON.h"

@interface UCarViewController ()<ASIHTTPRequestDelegate>
{
    NSMutableArray *imageArray;
    int a;

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
        UIAsyncImageView *button = [[UIAsyncImageView alloc] init];
        button.tag  = i;
        button.image = [UIImage imageNamed:[NSString stringWithFormat:@"AccidentBtn_%d", i]];
        float x = VIEW_WIDTH(self.scrollView)/2 + (i%2?1:-1)* (Button_Width/2 + 6);
        float y = i/2* (Button_Height + 20) +Button_Height/2 +20;
        button.frame = CGRectMake(0, 0, Button_Width, Button_Height);
        button.center = CGPointMake(x, y);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [imageArray addObject:button];
        [button release];
    }
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.25 *VIEW_HEIGHT(self.scrollView));
}

-(void)showCurrentTime
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"currentdate:%@", self.strDate);
    [dateFormatter release];
    
    [self.btnTime setTitle:self.strDate forState:UIControlStateNormal];
    self.btnTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnTime.titleLabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray = [[NSMutableArray alloc] init];
    _imagesURLArray = [[NSMutableArray alloc] initWithCapacity:4];
    // Do any additional setup after loading the view from its nib.
    [self addButtonsToScrollView];
    [self.contentView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.contentView.layer setShadowOpacity:0.3];
    [self.contentView.layer setShadowRadius:1];
    [self.contentView.layer setShadowOffset:CGSizeMake(0.5, 0.5)];
    
    [self.btnGearbox setTitle:@"自动变速箱(AT)" forState:UIControlStateNormal];
    self.btnGearbox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btnGearbox.titleLabel.font = [UIFont systemFontOfSize:14.0f];

    [self showCurrentTime];

    self.brandTextField.delegate = self;
    self.colorTextField.delegate = self;
    self.lengthTextField.delegate = self;
    self.lengthTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.describeTextField.delegate = self;
    self.personTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    [self.datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.pickerArray = [NSArray arrayWithObjects:@"自动变速箱(AT)", @"手动变速箱(MT)", @"手自一体", @"无级变速箱(VCT)", @"无级变速(VDT)", @"双离合变速箱(DCT)", @"序列变速箱(AMT)", nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:130];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imagesURLArray release];
    [imageArray release];
    [_pickerArray release];
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
    [_senderButton release];
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
    [self setSenderButton:nil];
    [super viewDidUnload];
}

-(void)resignTextField
{
    [self.brandTextField resignFirstResponder];
    [self.colorTextField resignFirstResponder];
    [self.lengthTextField resignFirstResponder];
    [self.describeTextField resignFirstResponder];
    [self.personTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
}

//http://www.ard9.com/qiche/index.php?c=member&a=release&tid=26&hand=161444713&id=&go=1&from=app
//参数
//用户编号 uid

-(void)senderAPI
{
    self.senderButton.enabled = NO;
    NSMutableString *picStr = [[NSMutableString alloc] init];
    for (int i = 0; i < self.imagesURLArray.count; i++) {
        NSString *str = [self.imagesURLArray objectAtIndex:i];
        if (i+1 == self.imagesURLArray.count) {
            [picStr appendString:[NSString stringWithFormat:@"%@", str]];
        } else {
            [picStr appendString:[NSString stringWithFormat:@"\/qiche\%@|,||-|", str]];
        }
    }
    NSString * url = [NSString stringWithFormat:@"%@c=member&a=release&tid=26&hand=161444713&id=&go=1&from=app", Server];
    NSString *saveURl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:saveURl]];
    [request setPostValue:[DataCenter shareInstance].accont.loginUserID forKey:@"uid"];
    [request setPostValue:picStr forKey:@"pic"];
    [request setPostValue:self.brandTextField.text forKey:@"pinpai"];
    [request setPostValue:self.colorTextField.text forKey:@"yanse"];
    [request setPostValue:self.strGearbox forKey:@"bsx"];
    [request setPostValue:self.lengthTextField.text forKey:@"xslc"];
    [request setPostValue:self.btnTime.titleLabel.text forKey:@"spsj"];
    //[request setPostValue:self.brandTextField.text forKey:@"spsj"];
    [request setPostValue:self.describeTextField.text forKey:@"xxms"];
    [request setPostValue:self.personTextField.text forKey:@"lxr"];
    [request setPostValue:self.phoneTextField.text forKey:@"lxdh"];
    request.tag = 5;
    request.delegate = self;
    [request startAsynchronous];
    [picStr release];
}

// 上传图片
- (void)uploadPic:(UIAsyncImageView *)imageV {
    NSString * url = [NSString stringWithFormat:@"%@c=uploads", Server];
    NSString *saveURl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:saveURl]];
    [request setData:UIImageJPEGRepresentation(imageV.image, 0.5) forKey:@"Isfiles"];
    request.tag = imageV.tag;
    request.delegate = self;
    [request startAsynchronous];
    
}

static int total = 0;

-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 5) {
        NSDictionary *d = [[request responseString] JSONValue];
        if ([[d objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            self.senderButton.enabled = YES;
            [self.navigationController popViewControllerAnimated:YES];
            [[iToast makeText:@"发送成功."] show];
        }
    } else {
        NSDictionary *d = [[request responseString] JSONValue];
        if (self.imagesURLArray.count >= 4) {
            [self.imagesURLArray removeObjectAtIndex:0];
        }
        [self.imagesURLArray addObject:[d objectForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.senderButton.enabled = YES;
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publish:(id)sender {
    [self resignTextField];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.25);
    } completion:^(BOOL finished) {
        nil;
    }];

    if (self.brandTextField.text.length == 0) {
        [[iToast makeText:@"品牌不可为空."] show];
        return;
    } else if(self.colorTextField.text.length == 0) {
        [[iToast makeText:@"颜色不可为空."] show];
        return;
    } else if(self.lengthTextField.text.length ==0) {
        [[iToast makeText:@"行驶里程不可为空."] show];
        return;
    } else if(self.describeTextField.text.length == 0) {
        [[iToast makeText:@"详细描述不可为空."] show];
        return;
    } else if(self.personTextField.text.length == 0) {
        [[iToast makeText:@"联系人不可为空."] show];
        return;
    } else if(self.phoneTextField.text.length == 0) {
        [[iToast makeText:@"联系电话不可为空."] show];
        return;
    }
    if (!self.btn1HasImage || !self.btn2HasImage || !self.btn3HasImage || !self.btn4HasImage) {
        [[iToast makeText:@"请补全图片."] show];
        return;
    }
    [self performSelector:@selector(senderAPI)];
    
}

- (IBAction)gearboxButton:(id)sender {
    [self resignTextField];
    [self.datePicker removeFromSuperview];
    [self.dataPickerView addSubview:self.pickerView];
    self.dataPickerLabel.text = @"选择变速箱类型";
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.8 *VIEW_HEIGHT(self.scrollView));
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, (VIEW_HEIGHT(self.view)- VIEW_HEIGHT(self.dataPickerView)), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
        self.scrollView.contentOffset = CGPointMake(0, 200);
    } completion:^(BOOL finished) {
        nil;
    }];

}

- (IBAction)timeButton:(id)sender {
    [self resignTextField];
    [self.pickerView removeFromSuperview];
    [self.dataPickerView addSubview:self.datePicker];
    self.dataPickerLabel.text = @"选择上牌日期";
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.8 *VIEW_HEIGHT(self.scrollView));
    [UIView animateWithDuration:0.4 animations:^{
        self.dataPickerView.frame = CGRectMake(0, (VIEW_HEIGHT(self.view)- VIEW_HEIGHT(self.dataPickerView)), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
        self.scrollView.contentOffset = CGPointMake(0, 355);
    } completion:^(BOOL finished) {
        nil;
    }];
}

-(void)buttonPressed:(id)sender
{
    [self resignTextField];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.25);
    } completion:^(BOOL finished) {
        nil;
    }];
    
    UIAsyncImageView *v = (UIAsyncImageView *)sender;
    a = v.tag;
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
    
    UIAsyncImageView *v= [imageArray objectAtIndex:a];
    v.image = image;
    [self uploadPic:v];
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.strDate = [dateFormatter stringFromDate:[sender date]];
    [dateFormatter release];
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//    self.strDate = [dateFormatter stringFromDate:[sender date]];
//    //    self.strDate= [NSString stringWithFormat:@"%f",[[sender date] timeIntervalSince1970]];
//    [dateFormatter release];
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
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.8 *VIEW_HEIGHT(self.scrollView));
        if (textField == self.brandTextField || textField == self.colorTextField || textField == self.lengthTextField) {
            self.scrollView.contentOffset = CGPointMake(0, 200);
        }
        if (textField == self.describeTextField || textField == self.personTextField || textField == self.phoneTextField) {
            self.scrollView.contentOffset = CGPointMake(0, 355);
        }
        self.dataPickerView.frame = CGRectMake(0, VIEW_HEIGHT(self.view), VIEW_WIDTH(self.dataPickerView), VIEW_HEIGHT(self.dataPickerView));
    } completion:^(BOOL finished) {
        nil;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), 1.25 *VIEW_HEIGHT(self.scrollView));
    } completion:^(BOOL finished) {
        nil;
    }];
    return YES;
}

@end
