MYCityListViewController

==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/ibireme/YYKeyboardManager/master/LICENSE)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YYKeyboardManager.svg?style=flat)](http://cocoapods.org/?q=YYKeyboardManager)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YYKeyboardManager.svg?style=flat)](http://cocoapods.org/?q=YYKeyboardManager)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

> ![demo](https://www.github.com/NengQuan/MYCityListViewController/master/334.gif
)

Compatibility
==============
iPhone / iPad / iPod with iOS  8 / 9.

<br/><br/>
---
中文介绍
==============
iOS 城市选择控制器。<br/>

兼容性
==============
该项目能很好的兼容 iPhone / iPad / iPod，兼容 iOS 6 / 7 / 8 / 9，
并且能很好的处理屏幕旋转。

用法
==============
```objc
// 初始化城市控制器，并设置代理
 MYCityListViewController *cityVC = [[MYCityListViewController alloc] init];
 cityVC.delegate = self;

// 遵守代理协议
<MYCityListViewControllerDelegaate>
	
	// 实现代理方法
- (void)didSelectCity:(NSString *)cityName
{
    [self.cityButton setTitle:cityName forState:UIControlStateNormal];
}
```
============== so easy
