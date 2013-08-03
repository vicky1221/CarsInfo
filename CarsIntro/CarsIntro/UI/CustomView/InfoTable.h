//
//  InfoTable.h
//  CarsIntro
//
//  Created by Cao Vicky on 6/26/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface InfoTable : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *infoArray;

@property (nonatomic, assign) UIViewController * viewController;

@end
