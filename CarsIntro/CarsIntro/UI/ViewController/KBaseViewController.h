//
//  KBaseViewController.h
//  CarsIntro
//
//  Created by banshenggua03 on 6/24/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//controller的切换方向
enum DRIECTION
{
    lateral = 1,
    top,
    foot
};

@interface KBaseViewController : UIViewController

- (void) backToHomeView:(UINavigationController *)navController;

- (void) pushCurrentViewController:(UIViewController *)viewController toNavigation:(UINavigationController *)naviation isAdded:(BOOL)isadd Driection:(NSInteger)driction;

@end
