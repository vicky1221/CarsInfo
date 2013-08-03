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
    [self performSelector:@selector(sendAPI)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)sendAPI {
//    http://www.ard9.com/qiche/index.php?c=article&a=info_json&id=63
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=article&a=info_json&id=%@", self.infoID] andArgs:nil delegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"%@",dic);
    self.text.text = [dic objectForKey:@"body"];
    
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
