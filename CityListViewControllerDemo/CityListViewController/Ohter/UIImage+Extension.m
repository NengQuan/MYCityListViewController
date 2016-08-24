//
//  UIImage+Extension.m
//  网易新闻框架
//
//  Created by NengQuan on 15/10/10.
//  Copyright © 2015年 NengQuan. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+(UIImage *)imageWithColor:(UIColor *)coclor
{
    CGFloat imageW = 100;
    CGFloat imageH = 100;
    
    // 开启图形上下文
    UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
    
    // 画一个color颜色正方形
    [coclor set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 拿到tup
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
@end
