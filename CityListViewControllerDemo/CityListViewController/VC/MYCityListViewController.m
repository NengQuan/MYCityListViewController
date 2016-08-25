//
//  MYCityListViewController.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCityListViewController.h"
#import "MYCitySearchViewController.h"

#import "MYCityEntyM.h"

#import "HotCityTableViewCell.h"

#import "UIView+Addition.h"
#import "MYCityListManager.h"
#import <CoreLocation/CoreLocation.h>

@interface MYCityListViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,MYCitySearchViewControllerDelegate,HotCityTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchCityTextField; // 搜索输入框
@property (weak, nonatomic) IBOutlet UITableView *bgTable;
@property (weak, nonatomic) IBOutlet UIView *searchView;              // 搜索view

@property (nonatomic,strong) MYCitySearchViewController *searchVC;

@property (nonatomic, strong) NSMutableArray *appearkeysArray;     //呈现24个字母
@property (nonatomic, strong) NSMutableArray *keysArray;           //24个字母

@property (nonatomic, strong) NSMutableArray *appearSectionTitle;   //区头
@property (nonatomic, strong) NSMutableArray *sectionTitle;         //区头

@property (nonatomic, strong) NSMutableArray *appearDataSource;   //呈现所有城市
@property (nonatomic, strong) NSMutableArray *dataSource;         //所有城市

@property (nonatomic,strong) NSArray *topCityAaary ;             // 热门城市数组

@property (strong, nonatomic) IBOutlet UIView *headerView;       // tableview header
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;         // 城市定位label
/** 位置管理者 */
@property (nonatomic, strong) CLLocationManager *lM;
@property (nonatomic,strong) CLGeocoder *geocoder ;
@property (nonatomic,strong) MYCityListManager *locationHelper ;

@end

@implementation MYCityListViewController

#define CITY_LIST_SOURCE_PLIST @"cityListSourceArray.plist"
#define HOT_CITY_PLIST @"hotcity.plist"
static NSString *cellID = @"cellID";
static NSString *hotcellID = @"hotcellID";

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
    [self configData];
    [self configCityList];
    [self configNotifig];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (MYCitySearchViewController *)searchVC
{
    if (_searchVC == nil) {
        _searchVC = [[MYCitySearchViewController alloc]init];
        _searchVC.searchDelegate = self;
        [self addChildViewController:_searchVC];
    }
    return _searchVC;
}

- (CLLocationManager *)lM
{
    if (!_lM) {
        // 1. 创建位置管理者
        _lM = [[CLLocationManager alloc] init];
        _lM.delegate = self;
        _lM.desiredAccuracy = kCLLocationAccuracyBest;
        /** -------iOS8.0+定位适配-------- */
        if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            [_lM requestWhenInUseAuthorization];
        }
    }
    return _lM;
}

#pragma mark - 初始化
- (void)configUI
{
    self.title = @"选择城市";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.bgTable setSectionIndexBackgroundColor:[UIColor clearColor]];
    self.bgTable.tableHeaderView = self.headerView;
    [self.bgTable setSectionIndexColor:[MYCityListManager sessionIndexColor]];
    [self.bgTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    [self.bgTable registerNib:[UINib nibWithNibName:NSStringFromClass([HotCityTableViewCell class]) bundle:nil] forCellReuseIdentifier:hotcellID];
    
    self.searchCityTextField.layer.cornerRadius = 4;
    [self.searchCityTextField.layer setMasksToBounds:YES];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    [self.searchCityTextField setLeftView:view];
    [self.searchCityTextField setLeftViewMode:UITextFieldViewModeAlways];
    
     _geocoder=[[CLGeocoder alloc]init];
    [self.lM startUpdatingLocation];
}

- (void)configData
{
    // 初始化索引关键字
    self.keysArray = [[NSMutableArray alloc] initWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    self.appearkeysArray = [[NSMutableArray alloc] initWithArray:self.keysArray];
    
    // 初始化session title
    self.sectionTitle = [[NSMutableArray alloc] initWithObjects:@"热门城市",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    self.appearSectionTitle = [[NSMutableArray alloc] initWithArray:self.sectionTitle];
    
    self.topCityAaary = [[NSArray alloc] init];
}
/**
 *  初始化城市列表
 */
- (void)configCityList
{
    NSString *path = [[NSBundle mainBundle]pathForResource:CITY_LIST_SOURCE_PLIST ofType:nil];
    // 获得城市数据数组
    NSArray *cityArray = [NSArray arrayWithContentsOfFile:path];
    // 城市数组 -> 模型数组
    NSMutableArray *resultCitylist = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in cityArray) {
        MYCityEntyM *model = [MYCityEntyM MYCityEntyModelWithDict:dict];
        [resultCitylist addObject:model];
    }
    
    if (resultCitylist.count > 0) {
          [self overgainCitySourceData:[resultCitylist mutableCopy]];
    }
    
    // 热门城市处理
    NSString *hotpath = [[NSBundle mainBundle]pathForResource:HOT_CITY_PLIST ofType:nil];
    NSArray *hotCityArray = [NSArray arrayWithContentsOfFile:hotpath];
    NSMutableArray *hotCityModelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in hotCityArray) {
        MYCityEntyM *model = [MYCityEntyM MYCityEntyModelWithDict:dict];
        [hotCityModelArray addObject:model];
    }
    
    self.topCityAaary = hotCityModelArray;
    
}

/**
 *  将城市数据进行排序
 *
 *  @param cityArray 返回按字母顺序排序的数组
 */
- (void)overgainCitySourceData:(NSMutableArray *)cityArray
{
    // 确定区(每个区加一个数组)
    self.dataSource = [[NSMutableArray alloc]initWithCapacity:0];
    for (id sessionTitle in self.sectionTitle) {
        NSMutableArray *mut = [[NSMutableArray alloc]initWithCapacity:0];
        [self.dataSource addObject:mut];
    }
    // 按字母顺序进行遍历 (取出字母相同的添加到数组中)
    for (int i =0;i < self.sectionTitle.count;i ++) {
        NSString *temS = [self.sectionTitle objectAtIndex:i];
        [cityArray enumerateObjectsUsingBlock:^(MYCityEntyM *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.firstLetter isEqualToString:temS]) {
                [[self.dataSource objectAtIndex:i] addObject:obj];
                [cityArray removeObject:obj];
            }
        }];
    }
    self.appearDataSource = [self.dataSource mutableCopy];
    [self.bgTable reloadData];
}

/**
 *  初始化通知
 */
- (void)configNotifig
{
    // TextField文字发生改变触发
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:self.searchCityTextField];
}

#pragma mark - Action 
/**
 *  刷新定位
 */
- (IBAction)refreshButtonActon:(id)sender {
    [self.lM startUpdatingLocation];
}

- (void)infoAction
{
    // 搜索框没有输入
    if ([_searchCityTextField.text isEqualToString:@""] || !_searchCityTextField.text) {
        // 移除搜索控制器
        [self.searchVC.view removeFromSuperview];
        [self.bgTable reloadData];
    } else {
        [self.view addSubview:self.searchVC.view];
        self.searchVC.view.frame = CGRectMake(0, self.searchView.bottom, self.view.width,self.view.height - self.searchView.height);
    }
    [self.searchVC setSearchText:self.searchCityTextField.text sourceArray:self.appearDataSource];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.searchCityTextField.textAlignment = NSTextAlignmentLeft;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.searchCityTextField.textAlignment = NSTextAlignmentCenter;
    return YES;
}

#pragma mark - UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.appearDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 ;
    }
    
    if ([[self.appearDataSource objectAtIndex:section]count] == NSNotFound) { // 城市列表
        return 0;
    }
    return [[self.appearDataSource objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 热门城市cell
        HotCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotcellID];
        [cell setData:self.topCityAaary];
        cell.hotcityDelegate = self;
        cell.viewController = self;
        return cell;
    } else { // 城市列表cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        MYCityEntyM *cityM = self.appearDataSource[indexPath.section][indexPath.row];
        cell.textLabel.text = cityM.cityName;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:MYHistoryKey];
        float modelsHeight = (float)(array.count > 8 ? 8 : array.count) / 4;
        float topArrayHeight = (float)self.topCityAaary.count / 4;
        NSInteger height = 0;
        // 搜索历史高度
        height += (NSInteger)ceilf(topArrayHeight) > 0 ? (NSInteger)ceilf(topArrayHeight) * 25 + (NSInteger)topArrayHeight * 15 + 54: 0;
        // 热门城市高度
        height += (NSInteger)ceilf(modelsHeight) > 0 ? (NSInteger)ceilf(modelsHeight) * 25 + (NSInteger)(modelsHeight) * 16 + 54 : 0;
        
        return height;

    } else {
        return 50;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section == 0) {
        MYCityEntyM *cityM = self.appearDataSource[indexPath.section][indexPath.row];
        // 保存选中的城市
        self.locationHelper = [MYCityListManager shareInstans];
        [self.locationHelper saveSelectCity:cityM.cityName];
        // 取出搜索历史
       NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:MYHistoryKey];
        NSMutableArray *histotyArray = [[NSMutableArray alloc] init];
        [histotyArray addObjectsFromArray:array];
        // 删除历史中重复的
        for (NSData *data in histotyArray) {
            MYCityEntyM *city = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([city.cityCode isEqualToString:cityM.cityCode]) {
                [histotyArray removeObject:data];
                break;
            }
        }
        // 保存历史数据
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cityM];
        [histotyArray addObject:data];
        [self saveToPist:histotyArray];
        // 触发选中城市代理
        if([self.delegate respondsToSelector:@selector(didSelectCity:)]) {
            [self.delegate didSelectCity:cityM.cityName];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.appearSectionTitle objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 25;
}
/**
 *  右侧索引条
 */
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.appearkeysArray;
}

- (void)saveToPist:(NSMutableArray *)array
{
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:MYHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - CLLocationManagerDelegate
/**
 *  更新到位置之后调用
 *
 *  @param manager   位置管理者
 *  @param locations 位置数组
 * is kind of
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    //如果不需要实时定位，使用完即使关闭定位服务
    [self.lM stopUpdatingLocation];
    
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
     __weak __typeof(self)weakSelf = self;
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSString *city = placemark.addressDictionary[@"City"] ;
        
        if (city == nil || [city isEqual:[NSNull null]]) {
            weakSelf.cityLabel.text = @"正在定位中...";
        } else if ([city isEqualToString:@""]) {
            weakSelf.cityLabel.text = @"正在定位中...";
        } else {
            weakSelf.cityLabel.text = city;
        }
    }];
}

/**
 *  授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            // 用户还未决定
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户还未决定");
            break;
        }
            // 问受限
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
            // 定位关闭时和对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:
        {
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled])
            {
                NSLog(@"定位开启，但被拒");
            }else
            {
                NSLog(@"定位关闭，不可用");
            }
            break;
        }
            // 获取前后台定位授权
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获取前后台定位授权");
            break;
        }
            // 获得前台定位授权
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台定位授权");
            break;
        }
        default:
            break;
    }
}

// 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
    self.cityLabel.text = @"正在定位中";
}

#pragma mark - MYCitySearchViewControllerDelegate
- (void)searchControllerDidSelectCity:(NSString *)cityName
{
    if ([self.delegate respondsToSelector:@selector(didSelectCity:)]) {
        [self.delegate didSelectCity:cityName];
    }
}

#pragma mark - HotCityTableViewCellDelegate
- (void)hotCityCellDidSelectCity:(NSString *)cityName
{
    if ([self.delegate respondsToSelector:@selector(didSelectCity:)]) {
        [self.delegate didSelectCity:cityName];
    }
}
@end
