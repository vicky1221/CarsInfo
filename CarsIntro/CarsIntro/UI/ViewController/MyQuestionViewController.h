//
//  MyQuestionViewController.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/17/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface MyQuestionViewController : KBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *questionTable;
}

@end
