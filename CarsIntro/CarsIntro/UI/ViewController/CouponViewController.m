//
//  CouponViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-6.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CouponViewController.h"
#import "JSON.h"
#import "UIView+custom.h"
@interface CouponViewController ()<ASIHTTPRequestDelegate>

@end

@implementation CouponViewController

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
    [self.textView setEditable:NO];
    self.textView.pagingEnabled = NO;
    self.textView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.03);
    self.scrollView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendAPI {
    //    http://www.ard9.com/qiche/index.php?c=channel&molds=huodong&a=info_json&id=编号
    ASIHTTPRequest * request = [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=channel&molds=huodong&a=info_json&id=%@", self.activityID] andArgs:nil delegate:self];
    if ([self.tid isEqualToString:@"24"]) {
        request.tag = 100;
    } else if([self.tid isEqualToString:@"25"]) {
        request.tag = 101;
    }
    NSLog(@"request.tag,,,,%d",request.tag);
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    self.textView.text = [dic objectForKey:@"content"];
    self.titleLabel.text = [dic objectForKey:@"title"];
    self.timeLabel.text = [dic objectForKey:@"addtime"];
    NSLog(@"jzsj,,,,%@", [dic objectForKey:@"jzsj"]);
    [self.titleBtn setTitle:[dic objectForKey:@"jzsj"] forState:UIControlStateNormal];
    self.numberLabel.text = [dic objectForKey:@"sysl"];
    if (request.tag == 100) {
        self.navLabel.text = @"活动";
    } else if(request.tag == 101) {
        self.navLabel.text = @"优惠劵";
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
}


#pragma mark - buttonAction

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_navLabel release];
    [_titleBtn release];
    [_titleLabel release];
    [_timeLabel release];
    [_numberLabel release];
    [_textView release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNavLabel:nil];
    [self setTitleBtn:nil];
    [self setTitleLabel:nil];
    [self setTimeLabel:nil];
    [self setNumberLabel:nil];
    [self setTextView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
