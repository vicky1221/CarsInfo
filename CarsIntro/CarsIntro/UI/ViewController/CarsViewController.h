//
//  CarsViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarsTable.h"
#import "KBaseViewController.h"
#import "TypeTable.h"
#import "UsedCarsTable.h"

@interface CarsViewController : KBaseViewController

- (IBAction)back:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *choiceView;
@property (retain, nonatomic) IBOutlet CarsTable *carsTable;
@property (retain, nonatomic) IBOutlet UsedCarsTable *usedCarsTable;

@property (retain, nonatomic) UIButton * btnNew;
@property (retain, nonatomic) UIButton * btnUsed;

@end
