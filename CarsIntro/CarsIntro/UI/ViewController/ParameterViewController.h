//
//  ParameterViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "ParameterTable.h"
#import "VehicleType.h"
@interface ParameterViewController : KBaseViewController

- (IBAction)back:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet ParameterTable *parameterTable;

@property (nonatomic, retain) VehicleType *vehicleType;

@end
