//
//  MyActiveViewController.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/17/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "MActivityTable.h"

@interface MyActiveViewController : KBaseViewController {
    IBOutlet MActivityTable *myActive;
    IBOutlet UILabel *titleLabel;
}

@property (assign) int Type;

@end
