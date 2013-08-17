//
//  CityViewController.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"

@interface CityViewController : KBaseViewController<UITableViewDelegate, UITableViewDataSource>

- (IBAction)toHomeVC:(id)sender;
- (IBAction)dingzhi:(id)sender;

@property (nonatomic, retain) NSString *provinceID;

@end
