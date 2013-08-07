//
//  ActivitiesViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBaseViewController.h"
#import "ActivitiesTable.h"
@interface ActivitiesViewController : KBaseViewController<ActivitiesTableDelegate>
@property (retain, nonatomic) IBOutlet UIView *choiceView;
- (IBAction)back:(id)sender;
@property (retain, nonatomic) IBOutlet ActivitiesTable *activitiesTable;

@property (retain, nonatomic) UIButton * btnActivity;
@property (retain, nonatomic) UIButton * btnCoupon;
@end
