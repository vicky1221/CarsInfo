//
//  KBaseViewController.m
//  CarsIntro
//
//  Created by banshenggua03 on 6/24/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "UIView+custom.h"

@interface KBaseViewController ()

@end

@implementation KBaseViewController

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
    
    UIImageView *m_background = [[UIImageView alloc] init];
	m_background.contentMode = UIViewContentModeScaleToFill;
	m_background.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	m_background.frame = self.view.bounds;
	m_background.image = [UIImage imageNamed:@"backGround.png"];
	[self.view insertSubview:m_background atIndex:0];
	[m_background release];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shadowView:(UIView *)view {
    [view.layer setBorderColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] CGColor]];
    [view.layer setBorderWidth:0.5];
    [view.layer setCornerRadius:4];
}

#pragma mark - view transform animation
- (void) pushCurrentViewController:(UIViewController *)viewController toNavigation:(UINavigationController *)naviation isAdded:(BOOL)isadd Driection:(NSInteger)driction{
    if (isadd) {
        naviation.view.hidden = NO;
        naviation.view.alpha = 1;
    } else {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [window addSubview:naviation.view];
    }
    
    switch (driction) {
        case 1: {
            naviation.view.frame = CGRectMake(VIEW_WIDTH(viewController.view), 0, VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            [UIView animateWithDuration:0.4 animations:^{
                viewController.view.frame = CGRectMake(-VIEW_WIDTH(viewController.view), 0,VIEW_WIDTH(viewController.view), VIEW_HEIGHT(viewController.view));
                naviation.view.frame = CGRectMake(0, 0, VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            } completion:^(BOOL finished) {
                viewController.view.frame = CGRectMake(0, 0,VIEW_WIDTH(viewController.view), VIEW_HEIGHT(viewController.view));
            }];
        }
            break;
        case 2: {
            naviation.view.frame = CGRectMake(0, -VIEW_HEIGHT(viewController.view), VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            [UIView animateWithDuration:0.4 animations:^{
                viewController.view.frame = CGRectMake(0, VIEW_HEIGHT(viewController.view),VIEW_WIDTH(viewController.view), VIEW_HEIGHT(viewController.view));
                naviation.view.frame = CGRectMake(0, 0, VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            } completion:^(BOOL finished) {
                viewController.view.frame = CGRectMake(0, 0,VIEW_WIDTH(viewController.view), VIEW_HEIGHT(viewController.view));
            }];
        }
            break;
        case 3: {
            naviation.view.frame = CGRectMake(0, VIEW_HEIGHT(viewController.view), VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            [UIView animateWithDuration:0.4 animations:^{
                naviation.view.frame = CGRectMake(0, 0, VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            } completion:^(BOOL finished) {
                nil;
            }];
            break;
        }
        case 4: {
            naviation.view.frame = CGRectMake(0, -VIEW_HEIGHT(viewController.view), VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            [UIView animateWithDuration:0.4 animations:^{
                viewController.view.frame = CGRectMake(0, VIEW_HEIGHT(viewController.view),VIEW_WIDTH(viewController.view), VIEW_HEIGHT(viewController.view));
                naviation.view.frame = CGRectMake(0, 0, VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case 5: {
            naviation.view.frame = CGRectMake(0, VIEW_HEIGHT(viewController.view), VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            [UIView animateWithDuration:0.4 animations:^{
                viewController.view.frame = CGRectMake(0, -VIEW_HEIGHT(viewController.view),VIEW_WIDTH(viewController.view), VIEW_HEIGHT(viewController.view));
                naviation.view.frame = CGRectMake(0, 0, VIEW_WIDTH(naviation.view), VIEW_HEIGHT(naviation.view));
            } completion:^(BOOL finished) {
                nil;
            }];
        }
        default:
            break;
    }
    NSLog(@"%@", self);
}

- (void) backToHomeView:(UINavigationController *)navController {
    [self backToHomeView:navController WithTime:0.5];
}

- (void) backToHomeView:(UINavigationController *)navController WithTime:(float)time {
    [UIView animateWithDuration:time animations:^{
        navController.view.alpha = 0;
    } completion:^(BOOL finished) {
        navController.view.hidden = YES;
    }];
}

@end
