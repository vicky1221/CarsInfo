//
//  MemberViewController.m
//  CarsIntro
//
//  Created by qianfeng on 6/25/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "MemberViewController.h"
#import "HomeViewController.h"
#import "UIView+custom.h"
#import "OrderViewController.h"
#import "AdviceViewController.h"
#import "AccidentViewController.h"
#import "UCarViewController.h"
#import "SafeViewController.h"
#import "RescueViewController.h"
#import "PersonViewController.h"
@implementation MemberViewController {
    float Button_Height;
}

#define Button_Width    101

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)addButtonsToContentView
{
    for (int i = 0; i <9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag  = i+101;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Member_%d.png", i]] forState:UIControlStateNormal];
        if (i%2==0) {
            [button setBackgroundImage:[UIImage imageNamed:@"MemberBtn_0.png"] forState:UIControlStateNormal];
        } else {
            [button setBackgroundImage:[UIImage imageNamed:@"MemberBtn_1.png"] forState:UIControlStateNormal];
        }
        float x = Button_Width/2 + (i%3)*Button_Width;
        float y = i/3*Button_Height  + Button_Height/2;
        NSLog(@"%f,,, %f,,,%f",x ,y, Button_Height);
        button.frame = CGRectMake(0, 0, Button_Width, Button_Height);
        button.center = CGPointMake(x, y);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.memberScrollView addSubview:button];
    }
    _memberScrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.memberScrollView), 4*Button_Height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backGroudImageView.image = [[UIImage imageNamed:@"HomeBtn_backGround"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    Button_Height = VIEW_HEIGHT(self.memberScrollView)/3;
    [self addButtonsToContentView];

}

- (void)dealloc {
    [_backGroudImageView release];
    [_memberScrollView release];
    [super dealloc];
}

#pragma mark - Button Action
- (IBAction)back:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (void)buttonPressed:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 101: {
            PersonViewController * personVC = [[PersonViewController alloc] initWithNibName:@"PersonViewController" bundle:nil];
            [self.navigationController pushViewController:personVC animated:YES];
            [personVC release];
        }
            break;
        case 102: {
            RescueViewController * rescueVC = [[RescueViewController alloc] initWithNibName:@"RescueViewController" bundle:nil];
            [self.navigationController pushViewController:rescueVC animated:YES];
            [rescueVC release];
        }
            break;
        case 103: {
            OrderViewController * orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            [self.navigationController pushViewController:orderVC animated:YES];
            orderVC.titleLabel.text = @"预约试驾";
            orderVC.orderLabel.text = @"预约试驾";
            [orderVC release];
        }
            break;
        case 104: {
            OrderViewController * orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            [self.navigationController pushViewController:orderVC animated:YES];
            orderVC.titleLabel.text = @"预约保养";
            orderVC.orderLabel.text = @"预约保养";
            [orderVC release];
        }
            break;
        case 105: {
            OrderViewController * orderVC = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
            [self.navigationController pushViewController:orderVC animated:YES];
            orderVC.titleLabel.text = @"预约维修";
            orderVC.orderLabel.text = @"预约维修";
            [orderVC release];
        }
            break;
        case 106: {
            UCarViewController * ucarVC = [[UCarViewController alloc] initWithNibName:@"UCarViewController" bundle:nil];
            [self.navigationController pushViewController:ucarVC animated:YES];
            [ucarVC release];
        }
            break;
        case 107: {
            AdviceViewController * adviceVC = [[AdviceViewController alloc] initWithNibName:@"AdviceViewController" bundle:nil];
            [self.navigationController pushViewController:adviceVC animated:YES];
            [adviceVC release];
        }
            break;
        case 108: {
            AccidentViewController * accidentVC = [[AccidentViewController alloc] initWithNibName:@"AccidentViewController" bundle:nil];
            [self.navigationController pushViewController:accidentVC animated:YES];
            [accidentVC release];
        }
            break;
        case 109: {
            SafeViewController * safeVC = [[SafeViewController alloc] initWithNibName:@"SafeViewController" bundle:nil];
            [self.navigationController pushViewController:safeVC animated:YES];
            [safeVC release];
        }
            break;
        default:
            break;
    }
    NSLog(@"%d", buttonTag);
}

@end
