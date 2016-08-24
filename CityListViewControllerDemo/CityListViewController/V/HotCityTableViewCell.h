//
//  HotCityTableViewCell.h
//  CityListViewController
//
//  Created by NengQuan on 16/8/23.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotCityTableViewCellDelegate <NSObject>

@optional

- (void)hotCityCellDidSelectCity:(NSString *)cityName ;

@end

@interface HotCityTableViewCell : UITableViewCell

- (void)setData:(NSArray *)array;

@property (nonatomic,strong) UIViewController *viewController ;

@property (nonatomic,weak) id <HotCityTableViewCellDelegate> hotcityDelegate ;
@end
