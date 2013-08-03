//
//  PersonViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "PersonTable.h"
@interface PersonViewController : KBaseViewController
  
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (retain, nonatomic) IBOutlet UIView *titleView;

@property (retain, nonatomic) IBOutlet UIView *contentView;


@property (retain, nonatomic) IBOutlet PersonTable *personTable;
@end
