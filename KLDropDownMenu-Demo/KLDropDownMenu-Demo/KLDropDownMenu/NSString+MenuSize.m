//
//  NSString+MenuSize.m
//  测试下拉菜单
//
//  Created by jinglian on 16/5/26.
//  Copyright © 2016年 kinglian. All rights reserved.
//

#import "NSString+MenuSize.h"

@implementation NSString (MenuSize)

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    CGSize textSize;
    
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    if (CGSizeEqualToSize(size, CGSizeZero)) { // 约束大小为0,表示根据字体大小计算矩形框尺寸
        textSize = [self sizeWithAttributes:attributes];
        
    }else {
        /* 
         NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被
         截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，
         则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（字体大小+行间距 = 行高）
        */
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
        CGRect rect = [self boundingRectWithSize:size options:option attributes:attributes context:nil];
        
        textSize = rect.size;
    }
    
    return textSize;
}

- (CGSize)kl_calculateTitleSize {
    CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    return size;
}

@end
