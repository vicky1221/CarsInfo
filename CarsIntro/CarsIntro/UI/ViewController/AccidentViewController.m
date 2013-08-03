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
@interface AccidentViewController ()
{
    UIButton * btn;
    //int a;
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
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addButtonsToScrollView];
    self.textView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
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
    btn = (UIButton *)sender;
    UIActionSheet * as=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [as showInView:self.view];
    [as release];
}

- (IBAction)submit:(id)sender {
    [self.textView resignFirstResponder];
    if (!self.textView.text.length) {
        [[iToast makeText:@"描述内容不可为空"] show];
    } else if (self.textView.text.length<10) {
        [[iToast makeText:@"描述内容不得低于10个字"] show];
    } else {
        [[iToast makeText:@"处理中，请稍等"] show];
        [[iToast makeText:@"事故理赔发送成功"] show];
        [self.navigationController popViewControllerAnimated:YES];
    }
//
//    if ([btn.imageView.image isEqual:[UIImage imageNamed:@"AccidentBtn_0"]] || [btn.imageView.image isEqual:[UIImage imageNamed:@"AccidentBtn_1"]] || [btn.imageView.image isEqual:[UIImage imageNamed:@"AccidentBtn_2"]] || [btn.imageView.image isEqual:[UIImage imageNamed:@"AccidentBtn_3"]]) {
//        [[iToast makeText:@"请补全图片"] show];
//    }
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3f animations:^{
        CGRect rect = CGRectMake(0.0f, -160, VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView));
        self.scrollView.frame = rect;
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
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}
//取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

@end
