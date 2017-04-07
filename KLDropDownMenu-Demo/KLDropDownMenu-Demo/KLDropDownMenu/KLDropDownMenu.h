//
//  KLDropDownMenu.h
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLDropDownMenuProtocol.h"

@interface KLDropDownMenu : UIView

/** 箭头颜色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 按钮分割线颜色 */
@property (nonatomic, strong) UIColor *separatorColor;

@property (nonatomic, weak) id <KLDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <KLDropDownMenuDelegate> delegate;

/**
 *  初始化菜单, 默认菜单宽度和屏幕的宽度一样
 *
 *  @param origin 菜单的的坐标
 *  @param height 菜单的高度
 *
 *  @return 实例化的菜单
 */
+ (instancetype)dropDownMenuWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

@end
