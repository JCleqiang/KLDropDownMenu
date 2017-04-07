//
//  KLMenuTableViewCell.h
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kMenuTableViewCellId = @"__menuTableViewCellId__";

@interface KLMenuTableViewCell : UITableViewCell

/** <#Description#> */
@property (nonatomic, copy) NSString *menuTitle;

/** 是否显示打勾选中的标识 */
@property (nonatomic, assign) BOOL isDisplayTag;

/** <#Description#> */
@property (nonatomic, strong) UIColor *bgColor;
@end
