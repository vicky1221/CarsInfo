//
//  CityViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "CityViewController.h"
#import "CityListCell.h"
#import "WeatherCity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

@interface CityViewController () {
    IBOutlet UITableView *cityTableView;
    NSMutableArray *cityListArray;
    WeatherCity *currentCity;
}

@end

@implementation CityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cityListArray = [[NSMutableArray alloc] init];
    
    NSString *doc_path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //数据库路径
    NSString *sqlPath=[doc_path stringByAppendingPathComponent:@"cityname.sqlite"];
    //          NSLog(@"  数据库地址     %@",sqlPath);
    
    //原始路径
    NSString *orignFilePath = [[NSBundle mainBundle] pathForResource:@"cityname" ofType:@"sqlite"];
    
    //          NSLog(@"原始地址:%@",orignFilePath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:sqlPath] == NO)//如果doc下没有数据库，从bundle里面拷贝过来
    {
        NSError *err = nil;
        if([fm copyItemAtPath:orignFilePath toPath:sqlPath error:&err] == NO)//如果拷贝失败
        {
            NSLog(@"open database error %@",[err localizedDescription]);
        }
        
        //              NSLog(@"document 下没有数据库文件，执行拷贝工作");
    }
    //初始化数据库
    FMDatabase *db=[FMDatabase databaseWithPath:sqlPath];
    //这个方法一定要执行
    if (![db open]) {
        NSLog(@"数据库打开失败！");
    }
    FMResultSet *resultSet=[db executeQuery:
                            [NSString stringWithFormat:@"select * from citys where province_id = %@", self.provinceID]];
    while ([resultSet next]) {
        WeatherCity *weatherCity = [[[WeatherCity alloc] init] autorelease];
        weatherCity.cityCode = [resultSet stringForColumn:@"city_num"];
        weatherCity.cityID = [resultSet stringForColumn:@"_id"];
        weatherCity.provinceID = [resultSet stringForColumn:@"province_id"];
        NSString *name22 = [resultSet stringForColumn:@"name"];
        NSArray *nameArray = [name22 componentsSeparatedByString:@"."];
        if (name22.length<5) {
            weatherCity.cityName = name22;
        }else{
            weatherCity.cityName = [nameArray objectAtIndex:1];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [defaults objectForKey:@"City"];
        WeatherCity *saveCity = [[[WeatherCity alloc] init] autorelease];
        if (dic) {
            [saveCity fromDic:dic];
        }
        if (saveCity.cityID&&[saveCity.cityID isEqualToString:weatherCity.cityID]) {
            weatherCity.isSelect = YES;
        }
        currentCity = [saveCity retain];
        [cityListArray addObject:weatherCity];
    }
    NSLog(@"查找成功");
    [db close];
    [cityTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_provinceID release];
    [currentCity release];
    [cityListArray release];
    [super dealloc];
}

-  (IBAction)toHomeVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CityListCell";
    CityListCell * cityCell = (CityListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cityCell == nil) {
        cityCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    
    WeatherCity *city = [cityListArray objectAtIndex:indexPath.row];
    cityCell.accessoryType = UITableViewCellAccessoryNone;
    [cityCell cellForDic:city];
    cityCell.selectCity.text = @"";
    return cityCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
    for (int i=0; i<cityListArray.count; i++) {
        WeatherCity *city = [cityListArray objectAtIndex:i];
        if (i == indexPath.row) {
            city.selectCity = city.cityName;
            city.isSelect = YES;
            currentCity = [city retain];
        } else {
            city.selectCity = @"";
            city.isSelect = NO;
        }
        [tempArray addObject:city];
    }
    [cityListArray removeAllObjects];
    [cityListArray addObjectsFromArray:tempArray];
    [cityTableView reloadData];
    
    NSDictionary *dic = [currentCity toDic];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dic forKey:@"tempCity"];
    [defaults synchronize];
}

@end
