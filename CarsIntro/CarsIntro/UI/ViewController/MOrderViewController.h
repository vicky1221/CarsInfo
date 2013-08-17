//
//  MOrderViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "MOrderTable.h"
@interface MOrderViewController : KBaseViewController
@property (retain, nonatomic) IBOutlet MOrderTable *mOrderTable;
@property (assign) NSInteger requestNumber;
@end
