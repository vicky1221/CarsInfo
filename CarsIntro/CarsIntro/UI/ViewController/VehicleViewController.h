//
//  VehicleViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "UIAsyncImageView.h"
#import "VehicleType.h"
#import "VehicleTable.h"
@interface VehicleViewController : KBaseViewController<UIActionSheetDelegate>

@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;
@property (retain, nonatomic) IBOutlet UIView *carsImageView;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;

- (IBAction)button:(id)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet VehicleTable *vehicleTable;

@property (nonatomic, retain) VehicleType *vehicleType;

@end
