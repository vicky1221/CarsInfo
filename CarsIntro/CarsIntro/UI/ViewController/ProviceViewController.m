//
//  ProviceViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/14/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "ProviceViewController.h"
#import "CityListCell.h"
#import "WeatherCity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "CityViewController.h"

@interface ProviceViewController () {
    NSMutableArray *cityArray;
}

@end

@implementation ProviceViewController

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
    cityArray = [[NSMutableArray alloc] init];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    
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
    FMResultSet *resultSet=[db executeQuery:@"select * from provinces"];
    while ([resultSet next]) {
        WeatherCity *city = [[[WeatherCity alloc] init] autorelease];
        city.cityName = [resultSet stringForColumn:@"name"];
        city.provinceID = [NSString stringWithFormat:@"%d", [[resultSet stringForColumn:@"_id"] integerValue]-1];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [defaults objectForKey:@"City"];
        [defaults setObject:dic forKey:@"tempCity"];
        [defaults synchronize];
        
        WeatherCity *saveCity = [[[WeatherCity alloc] init] autorelease];
        if (dic) {
            if (!saveCity) {
                saveCity = [[WeatherCity alloc] init];
            }
            [saveCity fromDic:dic];
        } else {
            saveCity.provinceID = @"0";
            saveCity.cityCode = @"101010100";
            saveCity.cityName = @"北京";
            saveCity.cityID = @"1";
        }
        if ([saveCity.provinceID isEqualToString:city.provinceID]) {
            city.selectCity = saveCity.cityName;
        }
        
        [cityArray addObject:city];
    }
    NSLog(@"查找成功");
    [db close];
    [cityTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"tempCity"];
    WeatherCity *tempCity = [[[WeatherCity alloc] init] autorelease];
    [tempCity fromDic:dic];
    NSArray *tempArray = [NSArray arrayWithArray:cityArray];
    [cityArray removeAllObjects];
    for (WeatherCity *w in tempArray) {
        w.selectCity = @"";
        if ([w.provinceID isEqualToString:tempCity.provinceID]) {
            w.selectCity = tempCity.cityName;
        }
        [cityArray addObject:w];
    }
    [cityTableView reloadData];
}

- (IBAction)toHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [cityArray release];
    [super dealloc];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CityListCell";
    CityListCell * cityCell = (CityListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cityCell == nil) {
        cityCell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] objectAtIndex:0];
    }
    
    WeatherCity *city = [cityArray objectAtIndex:indexPath.row];
    [cityCell cellForDic:city];
    cityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cityCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WeatherCity *city = [cityArray objectAtIndex:indexPath.row];
    CityViewController *cityVC = [[CityViewController new] autorelease];
    cityVC.provinceID = city.provinceID;
    [self.navigationController pushViewController:cityVC animated:YES];
}
//
- (IBAction)dingzhi:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"tempCity"];
    [defaults setObject:dic forKey:@"City"];
    [defaults synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
