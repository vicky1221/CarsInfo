//
//  DynamicViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-31.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "DynamicViewController.h"
#import "JSON.h"

@interface DynamicViewController () <ASIHTTPRequestDelegate>

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
	// Do any additional setup after loading the view.
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    //[self loadWebPageWithString:@"http://www.baidu.com"];
    [self performSelector:@selector(sendAPI)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

-(void)loadWebPageWithString:(NSString *)urlString
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSLog(@"%@", urlString);
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

#pragma UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error!");
}

- (void)sendAPI {
//    http://www.ard9.com/qiche/index.php?c=article&a=info_json&id=63
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=article&a=info_json&id=%@", self.infoID] andArgs:nil delegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"%@",dic);
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
}

#pragma mark - button Action
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toHome:(id)sender {
    [self backToHomeView:self.navigationController];
}
@end
