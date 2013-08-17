//
//  DynamicViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-31.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "DynamicViewController.h"
#import "JSON.h"
#import "iToast.h"
#import "UIViewController+custom.h"
#import <MessageUI/MessageUI.h>
#import "UIView+custom.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface DynamicViewController () <ASIHTTPRequestDelegate, MFMailComposeViewControllerDelegate> {
    NSString *previewID;
    NSString *nextID;
    NSString *infoTitle;
    NSDictionary *dataDic;
}

@end

@implementation DynamicViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendAPI:self.infoID];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:100];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_sinaView dealloc];
    [infoTitle release];
    [dataDic release];
    [previewID release];
    [nextID release];
    [_infoID release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)sendAPI:(NSString *)infoid {
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=article&a=info_json&id=%@", infoid] andArgs:nil delegate:self andTag:100];
    self.bottomView.hidden = YES;
    [self showSimpleHUD];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self removeSimpleHUD];
    self.bottomView.hidden = NO;
    NSDictionary *dic = [[request responseString] JSONValue];
    dataDic = [[NSDictionary alloc] initWithDictionary:dic];
    NSLog(@"%@",dic);
    [infoTitle release];
    infoTitle = [[dic objectForKey:@"title"] retain];
    [_infoID release];
    self.infoID = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"aid"]] retain];
    [previewID release];
    previewID = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"aprev"]] retain];
    [nextID release];
    nextID = [[NSString stringWithFormat:@"%@", [dic objectForKey:@"anext"]] retain];
    NSString *str = [dic objectForKey:@"body"];
    str = [str stringByReplacingOccurrencesOfString:@"/qiche" withString:@"http://www.ard9.com/qiche"];
    NSLog(@"%@", str);
    [self.webView loadHTMLString:[dic objectForKey:@"body"] baseURL:nil];    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [self removeSimpleHUD];
}

#pragma mark - button Action
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toHome:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (IBAction)buttomButton:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 1: {
            if ([previewID isEqualToString:@""]||[previewID isEqualToString:@"<null>"]||[previewID isEqualToString:@"null"]) {
                [iToast makeText:@"已到第一页"];
            } else {
                [self sendAPI:previewID];
            }
        }
            
            break;
        case 2:
        {
            if ([nextID isEqualToString:@""]||[nextID isEqualToString:@"<null>"]||[nextID isEqualToString:@"null"]) {
                [iToast makeText:@"已到最后一页"];
            } else {
                [self sendAPI:nextID];
            }
        }
            break;
        case 3: {
            self.shareview.hidden = NO;
        }
            break;
        default:
            break;
    }
}
- (IBAction)share:(id)sender {
    self.shareview.hidden = YES;
    NSInteger buttonTag = ((UIButton *)sender).tag;
    if (buttonTag == 1) {
        if ([[DataCenter shareInstance].sinaEngine isLoggedIn]) {
            self.sinaView.frame = CGRectMake(0, 0, 320,VIEW_HEIGHT(self.sinaView));
            [self.view addSubview:self.sinaView];
            self.sinaTextView.text = infoTitle;
            [UIView animateWithDuration:0.5 animations:^{
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
            }];
        } else {
            [[DataCenter shareInstance].sinaEngine logIn];
        }
    } else {
        [self displayMailComposerSheet];
    }
}

- (IBAction)close:(id)sender {
    [self.sinaTextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    } completion:^(BOOL finished) {
        [self.sinaView removeFromSuperview];
    }];
}

- (IBAction)send:(id)sender {
    [[DataCenter shareInstance].sinaEngine sendWeiBoWithText:self.sinaTextView.text image:nil];
    [self close:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view == self.shareview) {
        [self.shareview setHidden:YES];
    }
}

-(void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate =self;
    [picker setSubject:infoTitle];
    [picker setMessageBody:[dataDic objectForKey:@"body"] isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        caseMFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        caseMFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        caseMFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        caseMFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
@end
