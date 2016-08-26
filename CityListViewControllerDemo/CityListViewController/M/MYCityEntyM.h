//
//  MYCityEntyM.h
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface MYCityEntyM :NSObject <NSCoding>

@property (strong, nonatomic) NSString *cityCode;         //城市Id
@property (strong, nonatomic) NSString *cityName;      //城市名称
@property (strong, nonatomic) NSString *pinyin;          //城市拼音
@property (strong, nonatomic) NSString *firstLetter;     //首字母

+ (instancetype)MYCityEntyModelWithDict:(NSDictionary *)dict;

@end
