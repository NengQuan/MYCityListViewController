//
//  MYCityListManager.m
//  CityListViewControllerDemo
//
//  Created by NengQuan on 16/8/25.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCityListManager.h"

NSString *const MYHistoryKey = @"history";
NSString *const MYSelectCityKey = @"selectCity";

@implementation MYCityListManager

+ (instancetype)shareInstans
{
    static dispatch_once_t onceToken;
    static MYCityListManager *instans ;
    dispatch_once(&onceToken, ^{
        instans = [[self alloc] init];
    });
    return instans;
}

- (void)saveSelectCity:(NSString *)cityName
{
    [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:MYSelectCityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getSelectCity:(getCityBlock)succesblock
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:MYSelectCityKey];
    if (city) {
        succesblock(city);
    }
}

+ (UIColor *)collectionViewCellColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor *)selectCityColor
{
    return [UIColor orangeColor];
}

+ (UIColor *)sessionIndexColor
{
    return [UIColor orangeColor];
}

@end
