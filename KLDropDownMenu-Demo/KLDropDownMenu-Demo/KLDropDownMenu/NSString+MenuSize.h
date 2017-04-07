//
//  NSString+MenuSize.h
//  测试下拉菜单
//
//  Created by jinglian on 16/5/26.
//  Copyright © 2016年 kinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (MenuSize)
/**
 *  计算文字的 size
 *
 *  @param font          字体大小
 *  @param size          约束大小
 *  @param lineBreakMode 线 样式
 *
 *  @return 矩形框大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 *  计算字符串的尺寸
 */
- (CGSize)kl_calculateTitleSize;

@end
