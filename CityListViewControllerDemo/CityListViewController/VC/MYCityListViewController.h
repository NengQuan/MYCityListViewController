//
//  MYCityListViewController.h
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYCityListViewControllerDelegaate <NSObject>

@optional
- (void)didSelectCity:(NSString *)cityName ;

@end

@interface MYCityListViewController : UIViewController

@property (nonatomic,weak) id <MYCityListViewControllerDelegaate> delegate ;
@end
