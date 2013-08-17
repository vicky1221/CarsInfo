//
//  MyActiveViewController.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/17/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "ActivitiesTable.h"

@interface MyActiveViewController : KBaseViewController {
    IBOutlet ActivitiesTable *myActive;
    IBOutlet UILabel *titleLabel;
}

@property (assign) int Type;

@end
