//
//  ViewController.m
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import "ViewController.h"
#import "KLDropDownMenu.h"

@interface ViewController () <KLDropDownMenuDataSource, KLDropDownMenuDelegate>
{
    NSInteger _currentOneIndex;
    NSInteger _currentTwoLeftIndex;
    NSInteger _currentTwoRightIndex;
    NSInteger _currentThreeIndex;
}
/** <#Description#> */
@property (nonatomic, copy) NSArray *oneArray;
/** <#Description#> */
@property (nonatomic, copy) NSArray *twoArray;
/** <#Description#> */
@property (nonatomic, copy) NSArray *threeArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self.navigationController.navigationBar setBarTintColor:[UIColor purpleColor]];
    self.title = @"KLDropDownMenu";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //
    KLDropDownMenu *dropDownMenu = [KLDropDownMenu dropDownMenuWithOrigin:CGPointMake(0, 64) andHeight:44];
    dropDownMenu.delegate = self;
    dropDownMenu.dataSource = self;
    
    [self.view addSubview:dropDownMenu];
}


#pragma mark - KLDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(KLDropDownMenu *)menu {
    return 3;
}

- (NSString *)menu:(KLDropDownMenu *)menu titleForColumn:(NSInteger)column {
    switch (column) {
        case 0: return @"排序"; break;
        case 1: return @"地区"; break;
        case 2: return @"价格区间"; break;
        default: return @""; break;
    }
}

- (BOOL)isHaveTwoTableViewInColumn:(NSInteger)column {
    if (column == 1) { // 地区有两个列表
        return YES;
    }
    
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    if (column == 1) {
        return 1.0 / 3.0;
    }
    
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {
    switch (column) {
        case 0: return _currentOneIndex; break;
        case 1: return _currentTwoLeftIndex; break;
        case 2: return _currentThreeIndex; break;
        default: return 0; break;
    }
}

- (NSInteger)menu:(KLDropDownMenu *)menu numberOfMenuIndexPath:(KLMenuIndexPath *)menuIndexPath {
    switch (menuIndexPath.column) {
        case 0: return self.oneArray.count; break;
        case 1: {
            switch (menuIndexPath.menuTableType) {
                case KLMenuTableLeftType:
                    return self.twoArray.count;
                    break;
                case KLMenuTableRightType:
                    return [self.twoArray[menuIndexPath.leftItem][@"detail"] count];
                    break;
            }
        }
            break;
        case 2: return self.threeArray.count; break;
        default: return 0; break;
    }
}

- (NSString *)menu:(KLDropDownMenu *)menu titleForRowAtMenuIndexPath:(KLMenuIndexPath *)menuIndexPath {
    NSInteger row = menuIndexPath.row;
    
    switch (menuIndexPath.column) {
        case 0:  return self.oneArray[row]; break;
        case 1: {
            
            switch (menuIndexPath.menuTableType) {
                case KLMenuTableLeftType:
                    return self.twoArray[row][@"main"];
                    break;
                    
                case KLMenuTableRightType:
                    return self.twoArray[menuIndexPath.leftItem][@"detail"][row];
                    break;
            }
        }
            break;
        case 2: return self.threeArray[row]; break;
        default: return @""; break;
    }
    
}

#pragma mark - KLDropDownMenuDelegate
- (void)menu:(KLDropDownMenu *)menu didSelectRowAtIndexPath:(KLMenuIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: _currentOneIndex = indexPath.row; break;
        case 1: {
            switch (indexPath.menuTableType) {
                case KLMenuTableLeftType:
                    _currentTwoLeftIndex = indexPath.row;
                    return;
                    break;
                    
                case KLMenuTableRightType:
                    _currentTwoRightIndex = indexPath.row;
                    break;
            }
        }
            
        case 2: _currentThreeIndex = indexPath.row; break;
    }
    
    NSLog(@"选中, 菜单栏 Index: %ld, 左边 table Index: %ld, 右边 table Index: %ld", indexPath.column, indexPath.leftItem, indexPath.row);
}


#pragma mark - Lazy
- (NSArray *)oneArray {
    if (!_oneArray) {
        _oneArray = @[@"不限", @"按销量", @"按价格从低到高", @"按价格从高到低xxxxxxx"];
    }
    return _oneArray;
}

- (NSArray *)twoArray {
    if (!_twoArray) {
        _twoArray = @[@{@"main": @"不限",
                        @"detail": @[@"不限"]},
                      @{@"main": @"广东省",
                        @"detail": @[@"广州", @"深圳"]},
                      @{@"main": @"浙江省",
                        @"detail": @[@"杭州", @"宁波", @"绍兴", @"温州", @"台州"]},
                      @{@"main": @"江苏省",
                        @"detail": @[@"南京", @"苏州", @"无锡"]}];
    }
    return _twoArray;
}

- (NSArray *)threeArray {
    if (!_threeArray) {
        _threeArray = @[@"不限", @"0~99元", @"100~199元", @"200~299元", @"300~399元", @"400~499元", @"500~599元", @"600~699元", @"700~799元", @"800~899元", @"900~999元", @"1000以上"];
    }
    return _threeArray;
}

@end
