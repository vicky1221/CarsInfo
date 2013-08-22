//
//  AccidentViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "AccidentViewController.h"
#import "UIView+custom.h"
#import "iToast.h"
#import "WebRequest.h"
#import "UIAsyncImageView.h"
#import "JSON.h"

@interface AccidentViewController ()<ASIHTTPRequestDelegate>
{
    NSMutableArray *imageArray;
    int a;
}
@end

@implementation AccidentViewController

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
        NSLog(@"%f,%f",x,y);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [imageArray addObject:button];
        [button release];
    }
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.02);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self addButtonsToScrollView];
    self.textView.delegate = self;
    self.textView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:160];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [imageArray release];
    [_scrollView release];
    [_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonPressed:(id)sender
{
    [self.textView resignFirstResponder];
    a = ((UIAsyncImageView *)sender).tag;
//    [self.textView resignFirstResponder];
//    [UIView animateWithDuration:0.4 animations:^{
//        //self.scrollView.transform = CGAffineTransformIdentity;
//        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.02);
//    } completion:^(BOOL finished) {
//        nil;
//    }];
//
    UIActionSheet * as=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [as showInView:self.view];
    [as release];
}

- (IBAction)submit:(id)sender {
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.02);
    } completion:^(BOOL finished) {
        nil;
    }];
    if (!self.textView.text.length) {
        [[iToast makeText:@"描述内容不可为空"] show];
        return;
    } else if (self.textView.text.length<10) {
        [[iToast makeText:@"描述内容不得低于10个字"] show];
        return;
    } else if (!self.btn1HasImage || !self.btn2HasImage || !self.btn3HasImage || !self.btn4HasImage) {
        [[iToast makeText:@"请补全图片."] show];
        return;
    }
    [self performSelector:@selector(senderAPI)];
}

//提交接口
//http://www.ard9.com/qiche/index.php?c=member&a=release&tid=30&hand=161444713&id=&go=1&from=app

-(void)senderAPI
{
    for (int i = 0; i < 4; i++) {
        UIAsyncImageView *v = [imageArray objectAtIndex:i];
        NSString * url = [NSString stringWithFormat:@"%@c=member&a=release&tid=30&hand=161444713&id=&go=1&from=app", Server];
        NSString *saveURl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:saveURl]];
        [request setPostValue:[DataCenter shareInstance].accont.loginUserID forKey:@"uid"];
        [request setData:UIImageJPEGRepresentation(v.image, 0.5) forKey:@"pic"];
        [request setPostValue:self.textView.text forKey:@"content"];
        request.tag = i;
        request.delegate = self;
        [request startAsynchronous];
    }

}

static int total=0;
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *d = [[request responseString] JSONValue];
    if ([[d objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        total+=1;
        if (total == 4) {
            [self.navigationController popViewControllerAnimated:YES];
            [[iToast makeText:@"发送成功."] show];
        }
    }    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [[iToast makeText:@"网络错误."] show];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.5);
        self.scrollView.contentOffset = CGPointMake(0, 205);
    } completion:^(BOOL finished) {
        nil;
    }];
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
    switch (a) {
        case 0:
            self.btn1HasImage = YES;
            break;
        case 1:
            self.btn2HasImage = YES;
            break;
        case 2:
            self.btn3HasImage = YES;
            break;
        case 3:
            self.btn4HasImage = YES;
            break;
        default:
            break;
    }
    UIAsyncImageView *v = [imageArray objectAtIndex:a];
    v.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}
//取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

@end
