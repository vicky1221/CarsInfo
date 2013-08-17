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


@interface DynamicViewController () <ASIHTTPRequestDelegate> {
    NSString *previewID;
    NSString *nextID;
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
    [previewID release];
    [nextID release];
    [_infoID release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)sendAPI:(NSString *)infoid {
//    http://www.ard9.com/qiche/index.php?c=article&a=info_json&id=63
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=article&a=info_json&id=%@", infoid] andArgs:nil delegate:self andTag:100];
    self.bottomView.hidden = YES;
    [self showSimpleHUD];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self removeSimpleHUD];
    self.bottomView.hidden = NO;
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"%@",dic);
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
            if ([[DataCenter shareInstance].sinaEngine isLoggedIn]) {
                
            } else {
                [[DataCenter shareInstance].sinaEngine logIn];
            }
            
        }
            break;
        default:
            break;
    }
}
@end
