//
//  MYLocationManager.m
//  CityListViewControllerDemo
//
//  Created by NengQuan on 16/8/24.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYLocationManager.h"

@implementation MYLocationManager

+ (instancetype)instannLocationManagerHelper
{
    MYLocationManager *manager = [[MYLocationManager alloc] init];
    return manager;
}

- (void)saveSelectCity:(NSString *)cityName
{
    [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"selectCity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getSelectCity:(getCityBlock)succesblock
{
     NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectCity"];
    if (city) {
        succesblock(city);
    }
}
@end
