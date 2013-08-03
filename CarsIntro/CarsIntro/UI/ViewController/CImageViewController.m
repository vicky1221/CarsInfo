//
//  CImageViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CImageViewController.h"

@interface CImageViewController ()

@end

@implementation CImageViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    self.titleView.alpha = 0;
    self.isTitleView = NO;
    [UIView commitAnimations];
    
    //手势初始化
    UIPinchGestureRecognizer * pinch=[[UIPinchGestureRecognizer alloc] init];
    pinch.delegate=self;
    [pinch addTarget:self action:@selector(pinch:)];
    //添加手势到self.view
    [self.asyImageView addGestureRecognizer:pinch];
    [pinch release];
    
    //单击放大
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc]init];
    [tap1 addTarget:self action:@selector(tap:)];
    tap1.numberOfTapsRequired=1;
    [self.asyImageView addGestureRecognizer:tap1];
    [tap1 release];
    
    
    //双击
    UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc]init];
    [tap2 addTarget:self action:@selector(tap:)];
    tap2.numberOfTapsRequired=2;
    [self.asyImageView addGestureRecognizer:tap2];
    [tap2 release];
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.numberOfTapsRequired==1) {
        self.asyImageView.frame=CGRectMake(0, 100, 320, 240);
        NSLog(@"%f",self.titleView.alpha);
        if (self.isTitleView) {
            self.titleView.alpha = 0;
            self.isTitleView = NO;
        }else {
            self.titleView.alpha = 1;
            self.isTitleView = YES;
        }
    }else if(gesture.numberOfTapsRequired==2)
    {
        self.asyImageView.frame=CGRectMake(0, 0, 320, 460);
        self.isTitleView = YES;
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state==UIGestureRecognizerStateBegan||gesture.state==UIGestureRecognizerStateChanged)
    {
        gesture.view.transform=CGAffineTransformScale(gesture.view.transform, gesture.scale, gesture.scale);
        gesture.scale=1.0f;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)rttgr:(UIRotationGestureRecognizer *)gesture
{
    //对视图进行旋转变化
    if (gesture.state==UIGestureRecognizerStateBegan||gesture.state==UIGestureRecognizerStateChanged)
    {
        gesture.view.transform=CGAffineTransformRotate(gesture.view.transform, gesture.rotation);
        gesture.rotation=0.0f;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [_asyImageView release];
    [_titleView release];
    [super dealloc];
}
@end
