//
//  AdviceViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "AdviceViewController.h"
#import "iToast.h"
#import "WebRequest.h"
@interface AdviceViewController ()<ASIHTTPRequestDelegate, UITextViewDelegate>

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
    [self shadowView:self.textView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:150];
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
    [self.textView resignFirstResponder];
    if ([self.textView.text isEqualToString:@"请输入投诉内容"]||self.textView.text.length==0) {
        [[iToast makeText:@"请输入投诉内容."] show];
        return;
    } else {
        [self performSelector:@selector(senderAPI)];
    }
}

//http://www.ard9.com/qiche/index.php?c=message&a=add&tid=37&from=app
//参数
//title  标题
//body  详情
//uid   用户编号

-(void)senderAPI
{
     [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=message&a=add&tid=37&from=app&title=%@&body=%@&uid=%@", nil, self.textView.text, [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:140];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [[iToast makeText:@"投诉建议发送成功."] show];
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"网络错误.");
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length>0) {
        self.placeHolder.hidden = YES;
    } else {
        self.placeHolder.hidden = NO;
    }
}
@end
