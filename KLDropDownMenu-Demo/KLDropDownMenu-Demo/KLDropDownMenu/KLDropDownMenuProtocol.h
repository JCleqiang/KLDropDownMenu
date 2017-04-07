//
//  KLDropDownMenuProtocol.h
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import "KLMenuIndexPath.h"
@class KLDropDownMenu;

//*********************************** DataSource Protocol *****************************************

#pragma mark - DataSource Protocol 数据源协议

@protocol KLDropDownMenuDataSource <NSObject>

@required
/**
 <#Description#>

 @param menu          菜单
 @param menuIndexPath 菜单索引

 @return <#return value description#>
 */
- (NSInteger)menu:(KLDropDownMenu *)menu numberOfMenuIndexPath:(KLMenuIndexPath *)menuIndexPath;


/**
 每个column的列表 cell 的数据源
 
 @param menu      <#menu description#>
 @param menuIndexPath <#indexPath description#>
 
 @return <#return value description#>
 */
- (NSString *)menu:(KLDropDownMenu *)menu titleForRowAtMenuIndexPath:(KLMenuIndexPath *)menuIndexPath;


/**
 初始化时的菜单栏上的标题
 
 @param menu   <#menu description#>
 @param column <#column description#>
 
 @return <#return value description#>
 */
- (NSString *)menu:(KLDropDownMenu *)menu titleForColumn:(NSInteger)column;

/**
 *  表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;

/**
 *  是否在一个菜单栏中有两个 table
 */
- (BOOL)isHaveTwoTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
/**
 *  返回多少个表视图, default is 1
 */
- (NSInteger)numberOfColumnsInMenu:(KLDropDownMenu *)menu;

@end

//*********************************** Delegate Protocol *****************************************

#pragma mark - Delegate Protocol 代理
@protocol KLDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(KLDropDownMenu *)menu didSelectRowAtIndexPath:(KLMenuIndexPath *)indexPath;

@end


