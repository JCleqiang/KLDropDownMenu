//
//  KLMenuTableViewCell.m
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import "KLMenuTableViewCell.h"

@interface KLMenuTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;
@end

@implementation KLMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setMenuTitle:(NSString *)menuTitle {
    _menuTitle = menuTitle;
    
    self.menuTitleLabel.text = menuTitle;
}

- (void)setIsDisplayTag:(BOOL)isDisplayTag {
    _isDisplayTag = isDisplayTag;
    
    self.tagImageView.hidden = !isDisplayTag;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    
    self.backgroundColor = bgColor;
}

@end
