//
//  ProviceViewController.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface ProviceViewController : KBaseViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *cityTableView;
}

- (IBAction)toHome:(id)sender;

@end
