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
/**
 *  搜索控制器中选中城市事件
 *
 *  @param cityName 城市名称
 */
- (void)searchControllerDidSelectCity:(NSString *)cityName ;

@end

@interface MYCitySearchViewController : UITableViewController
/**
 *  设置搜索列表
 *
 *  @param text       传入的文字
 *  @param sourceData 城市数组
 */
-(void)setSearchText:(NSString *)text sourceArray:(NSArray *)sourceData;

@property (nonatomic,weak) id <MYCitySearchViewControllerDelegate> searchDelegate ;

@end
