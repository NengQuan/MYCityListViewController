//
//  MYCityListManager.h
//  CityListViewControllerDemo
//
//  Created by NengQuan on 16/8/25.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 适配宏 根据屏幕尺寸来判断当前手机型号
#define KScreenSize [UIScreen mainScreen].bounds.size
#define IsIphone6P KScreenSize.width==414
#define IsIphone6 KScreenSize.width==375
#define IsIphone5S KScreenSize.height==568
// 456字体大小  KIOS_Iphone456(iphone6p,iphone6,iphone5s,iphone4s)
#define KIOS_Iphone456(iphone6p,iphone6,iphone5s,iphone4s) (IsIphone6P?iphone6p:(IsIphone6?iphone6:(IsIphone5S?iphone5s:iphone4s)))
//宽  KIphoneSize_Widith(iphone6)  高 KIphoneSize_Height(iphone6)
#define KIphoneSize_Widith(iphone6)  (IsIphone6P?1.104*iphone6:(IsIphone6?iphone6:(IsIphone5S?0.853*iphone6:0.853*iphone6)))
#define KIphoneSize_Height(iphone6)  (IsIphone6P?1.103*iphone6:(IsIphone6?iphone6:(IsIphone5S?0.851*iphone6:0.720*iphone6)))

typedef void(^getCityBlock)(NSString *cityName);

/**
 *  userdefault const
 */
extern NSString *const MYHistoryKey;  /// 历史
extern NSString *const MYSelectCityKey ; /// 选中城市

/// 管理器，用来修改内部的颜色，保存选中的城市
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
