//
//  MYCityListManager.h
//  CityListViewControllerDemo
//
//  Created by NengQuan on 16/8/25.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

// 管理器，用来修改内部的颜色，保存选中的城市

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^getCityBlock)(NSString *cityName);

/**
 *  userdefault const
 */
extern NSString *const MYHistoryKey;  /// 历史
extern NSString *const MYSelectCityKey ; /// 选中城市

@interface MYCityListManager : NSObject

+ (instancetype)shareInstans ;
/**
 *  保存选中的城市
 *
 *  @param cityName 城市名称
 */
- (void)saveSelectCity:(NSString *)cityName ;
/**
 *  获取选中的城市
 *
 *  @param succesblock 成功回调
 */
- (void)getSelectCity:(getCityBlock)succesblock ;
/**
 *  热门城市cell的border颜色
 *
 */
+ (UIColor *)collectionViewCellColor ;
/**
 *  搜索城市显示和搜索词一样的颜色
 */
+ (UIColor *)selectCityColor ;
/**
 *  tableview index颜色
 */
+ (UIColor *)sessionIndexColor ;

@end
