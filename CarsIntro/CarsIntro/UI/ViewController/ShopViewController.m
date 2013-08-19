//
//  ShopViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "ShopViewController.h"
#import "WebRequest.h"
#import "Information.h"
#import "JSON.h"
#import "EDynamicViewController.h"
#import "LocationViewController.h"
#import "DynamicViewController.h"

@interface ShopViewController ()<ASIHTTPRequestDelegate>
{
    DynamicViewController *EDynamicVC;
//    EDynamicViewController * EDynamicVC;
}
@end

@implementation ShopViewController

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
    [self performSelector:@selector(sendAPI)];
    self.phoneButton.adjustsImageWhenHighlighted = NO;
    self.emaileButton.adjustsImageWhenHighlighted = NO;
    self.newsButton.adjustsImageWhenHighlighted = NO;
//    EDynamicVC = [[EDynamicViewController alloc] initWithNibName:@"EDynamicViewController" bundle:nil];
    EDynamicVC = [[DynamicViewController alloc] initWithNibName:@"DynamicViewController" bundle:nil];
}

//http://www.ard9.com/qiche/index.php?c=article&a=type_json_tuijian&tid=33
- (void)sendAPI{
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=article&a=type_json_tuijian&tid=33"] andArgs:nil delegate:self andTag:1000];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"123");
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    for (NSDictionary *d in array) {
        Information * info = [[Information alloc] init];
        [info fromDic:d];
        EDynamicVC.infoID = info.infoId;
        self.timeLabel.text = info.addtime;
        self.titleLabel.text = info.title;
        self.titleLabel.numberOfLines =0;
        self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.titleLabel.preferredMaxLayoutWidth = 500;
        [info release];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toCIntroduceVC:(id)sender {
    CIntroduceViewController * vc = [[CIntroduceViewController alloc] initWithNibName:@"CIntroduceViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

- (IBAction)toLocationVC:(id)sender {
    LocationViewController * locationVC = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    [self presentModalViewController:locationVC animated:YES];
    [locationVC release];
}

- (IBAction)btnNews:(id)sender {
    [self.navigationController pushViewController:EDynamicVC animated:YES];
}


- (IBAction)btnPhone:(id)sender {
    self.isPhoneActionSheet = YES;
    UIActionSheet * as=[[UIActionSheet alloc] initWithTitle:@"电话联动" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拨打商家热线" otherButtonTitles:nil, nil];
    [as showInView:self.view];
    [as release];
}

- (IBAction)btnEmaile:(id)sender {
    self.isPhoneActionSheet = NO;
    UIActionSheet * as=[[UIActionSheet alloc] initWithTitle:@"邮件联动" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"致信总经理" otherButtonTitles:nil, nil];
    [as showInView:self.view];
    [as release];
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//发送邮件

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title_
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}
//可以发送邮件的话
-(void)displayComposerSheet
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"新邮件"];
    
    // 添加发送者
    NSArray *toRecipients = [NSArray arrayWithObject: @"sa14008@part.faw-vw.com"];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com", nil];
    [mailPicker setToRecipients: toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // 添加图片
    //    UIImage *addPic = [UIImage imageNamed: @"123.jpg"];
    //    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //    // NSData *imageData = UIImageJPEGRepresentation(addPic, 1);    // jpeg
    //    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"123.jpg"];
    
    NSString *emailBody = @"------------\n来自同城汽车网应用";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    
    //[self presentModalViewController: mailPicker animated:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
    [mailPicker release];
}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:sa14008@part.faw-vw.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==1) {
        return;
    }
    if (buttonIndex==0) {
        if (self.isPhoneActionSheet) {
            NSLog(@"打电话");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006310351"]];
        } else {
            NSLog(@"发邮件");
            [self sendEMail];
        }
    }
}

- (void)dealloc {
    [EDynamicVC release];
    [_phoneButton release];
    [_emaileButton release];
    [_newsButton release];
    [_titleLabel release];
    [_timeLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPhoneButton:nil];
    [self setEmaileButton:nil];
    [self setNewsButton:nil];
    [self setTitleLabel:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
}
@end
