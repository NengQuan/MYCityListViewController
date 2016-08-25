//
//  MYCitySearchViewController.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "MYCitySearchViewController.h"
#import "MYCityEntyM.h"
#import "pinyin.h"
#import "MYCityListManager.h"

@interface MYCitySearchViewController ()

@property (nonatomic,strong) NSMutableArray *resultCitys; // 搜索结果城市数组
@property (nonatomic,strong) NSString *searchText; // 搜索的文字

@property (nonatomic,strong) MYCityListManager *cityListManager ;

@end

@implementation MYCitySearchViewController
static NSString * const MYSearchCellID = @"MYSearchCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MYSearchCellID];
    self.cityListManager = [MYCityListManager shareInstans];
}

- (void)setSearchText:(NSString *)text sourceArray:(NSArray *)sourceData
{
     NSString *lowerSearchText = text.lowercaseString;
    self.searchText = text;
    
    NSString *regex = @"[\u4e00-\u9fa5]+";
    // 判断是否有汉字
    NSPredicate *predicat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSMutableArray *temResultArray = [[NSMutableArray alloc]init];
    
    // 遍历每个字母对应的城市数组
    [sourceData enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 遍历对应字母数组下的城市
        [obj enumerateObjectsUsingBlock:^(MYCityEntyM *objz, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isHanZi = [predicat evaluateWithObject:text];
            if (isHanZi) { // 汉字的情况
                BOOL d1 = [objz.cityName rangeOfString:lowerSearchText].length != 0;
                if (d1) {
                    [temResultArray addObject:objz];
                }
            } else { // 非汉字的情况
                // 汉字转首字母
                NSMutableString *mutableStr = [@"" mutableCopy];
                for (int i = 0;i<objz.cityName.length ;i++) {
                    // 使用pinyin.h汉字转首字母
                    [mutableStr appendString:[NSString stringWithFormat:@"%c",pinyinFirstLetter([objz.cityName characterAtIndex:i])]];
                }
                NSRange rangeShouZiMu = [mutableStr.lowercaseString rangeOfString:lowerSearchText];//拼音
                NSRange rangePinYin = [[objz.pinyin lowercaseString] rangeOfString:lowerSearchText];//首字母
                if (rangeShouZiMu.length || (rangePinYin.length && rangePinYin.location == 0)){
                    [temResultArray addObject:objz];
                }
            }
        }];
    }];
    
    NSMutableArray *outputArray = [[NSMutableArray alloc]init];
    [outputArray addObject:temResultArray];
    
    self.resultCitys = [[NSMutableArray alloc]initWithArray:outputArray];
    [self.tableView reloadData];
}

#pragma mark - Tableviewdatasource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.superview endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.resultCitys objectAtIndex:section] count]; // 取出对应字母的城市
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MYSearchCellID];
    MYCityEntyM *cityM = self.resultCitys[indexPath.section][indexPath.row];
    
    // 如果输入的字符和模型相同 为橙色
    if([cityM.cityName rangeOfString:self.searchText].location != NSNotFound) {
        NSMutableAttributedString *attrbutString = [self changeAttributedWithSourceString:cityM.cityName replaceString:self.searchText];
        cell.textLabel.attributedText = attrbutString;
    }
    
    cell.textLabel.text = cityM.cityName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYCityEntyM *cityM = self.resultCitys[indexPath.section][indexPath.row];
    // 保存选中的城市
    [self.cityListManager saveSelectCity:cityM.cityName];
    // 取出历史数据，再添加新的历史
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:MYHistoryKey];
    NSMutableArray *histotyArray = [[NSMutableArray alloc] init];
    [histotyArray addObjectsFromArray:array];
    
    for (NSData *data in histotyArray) {
        MYCityEntyM *city = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([city.cityCode isEqualToString:cityM.cityCode]) {
            [histotyArray removeObject:data];
            break;
        }
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cityM];
    [histotyArray addObject:data];
    [self saveToPist:histotyArray];
    // 通知代理
    if ([self.searchDelegate respondsToSelector:@selector(searchControllerDidSelectCity:)]) {
        [self.searchDelegate searchControllerDidSelectCity:cityM.cityName];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NSMutableAttributedString
/**
 *  改变富文本
 *
 *  @param sourceString  源文字
 *  @param replaceString 改变后的文字
 */
- (NSMutableAttributedString *)changeAttributedWithSourceString:(NSString *)sourceString replaceString:(NSString *)replaceString {
    
    NSRange range = [sourceString rangeOfString:replaceString];
    NSMutableAttributedString *rtnMutableAttributed = [[NSMutableAttributedString alloc] initWithString:[sourceString substringToIndex:range.location] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor blackColor] }];
    
    NSMutableAttributedString *replaceMutableAttributed = [[NSMutableAttributedString alloc] initWithString:replaceString attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [MYCityListManager selectCityColor] }];
    
    NSMutableAttributedString *footMutableAttributed = [[NSMutableAttributedString alloc] initWithString:[sourceString substringFromIndex:(range.location + range.length)] attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor blackColor] }];
    
    [rtnMutableAttributed appendAttributedString:replaceMutableAttributed];
    [rtnMutableAttributed appendAttributedString:footMutableAttributed];
    
    return rtnMutableAttributed;
}

- (void)saveToPist:(NSMutableArray *)array
{
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:MYHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
