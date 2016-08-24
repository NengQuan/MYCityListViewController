//
//  MYCitySearchViewController.h
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYCitySearchViewControllerDelegate <NSObject>

@optional
- (void)searchControllerDidSelectCity:(NSString *)cityName ;

@end
@interface MYCitySearchViewController : UITableViewController

-(void)setSearchText:(NSString *)text sourceArray:(NSArray *)sourceData;

@property (nonatomic,weak) id <MYCitySearchViewControllerDelegate> searchDelegate ;

@end
