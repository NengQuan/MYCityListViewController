//
//  MYCityEntyM.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCityEntyM.h"

@implementation MYCityEntyM

+ (instancetype)MYCityEntyModelWithDict:(NSDictionary *)dict
{
    MYCityEntyM *model = [[MYCityEntyM alloc] init];
    model.cityCode = dict[@"cityCode"];
    model.cityName = dict[@"cityName"];
    model.pinyin = dict[@"pinyin"];
    model.firstLetter = dict[@"firstLetter"];
    
    return model;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityCode forKey:@"cityCode"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.pinyin forKey:@"pinyin"];
    [aCoder encodeObject:self.firstLetter forKey:@"firstLetter"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityCode = [aDecoder decodeObjectForKey:@"cityCode"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.pinyin = [aDecoder decodeObjectForKey:@"pinyin"];
        self.firstLetter = [aDecoder decodeObjectForKey:@"firstLetter"];
    }
    return self;
}

@end
