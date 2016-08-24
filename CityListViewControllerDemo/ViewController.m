//
//  ViewController.m
//  CityListViewControllerDemo
//
//  Created by NengQuan on 16/8/24.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "ViewController.h"
#import "MYCityListViewController.h"
#import "MYLocationManager.h"

@interface ViewController ()<MYCityListViewControllerDelegaate>

@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (nonatomic,strong) MYLocationManager *manager ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [MYLocationManager instannLocationManagerHelper];
    [self.manager getSelectCity:^(NSString *cityName) {
        [self.cityButton setTitle:cityName forState:UIControlStateNormal];
    }];
}

- (IBAction)changeCityClick:(id)sender {
    MYCityListViewController *cityVC = [[MYCityListViewController alloc] init];
    cityVC.delegate = self;
    
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)didSelectCity:(NSString *)cityName
{
    [self.cityButton setTitle:cityName forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
