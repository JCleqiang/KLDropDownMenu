//
//  KLMenuIndexPath.m
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import "KLMenuIndexPath.h"

@implementation KLMenuIndexPath

+ (instancetype)menuIndexPathColumn:(NSInteger)column row:(NSInteger)row menuTableType:(KLMenuTableType)menuTableType leftItem:(NSInteger)leftItem {
    return [[self alloc] initWithColumn:column row:row menuTableType:menuTableType leftItem:leftItem];
}

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row menuTableType:(KLMenuTableType)menuTableType leftItem:(NSInteger)leftItem {
    if (self = [super init]) {
        self.column         = column;
        self.row            = row;
        self.menuTableType  = menuTableType;
        self.leftItem       = leftItem;
    }
    
    return self;
}

@end
