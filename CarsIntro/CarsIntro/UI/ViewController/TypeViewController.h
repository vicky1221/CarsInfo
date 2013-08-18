//
//  TypeViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "TypeTable.h"
#import "VehicleType.h"
#import "UsedCarInfo.h"
@interface TypeViewController : KBaseViewController

@property (nonatomic, retain) VehicleType *vehicleType;  // 定义一个VehicleType属性，因为上个界面每个cell都是一个VehicleType类。 把点击的cell的VehicleType传到这个界面， 这个界面的title是VehicleType里的title， 需要用到VehicleType里的vehicleTypeId，根据这个id去请求网络，返回的数据就是这个界面显示的数据。 

//@property (nonatomic, retain) UsedCarInfo * usedCarInfo;
@property (nonatomic, retain) NSString *tid;
@property (nonatomic, retain) NSString *title;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet TypeTable *typeTable;
//@property (nonatomic, assign) BOOL isNewCarData;

- (IBAction)back:(id)sender;

@end
