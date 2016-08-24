//
//  MYLocationManager.h
//  CityListViewControllerDemo
//
//  Created by NengQuan on 16/8/24.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^getCityBlock)(NSString *cityName);
@interface MYLocationManager : NSObject

- (void)saveSelectCity:(NSString *)cityName ;

- (void)getSelectCity:(getCityBlock)succesblock ;

+ (instancetype)instannLocationManagerHelper ;

@end
