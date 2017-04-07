//
//  KLMenuIndexPath.h
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KLMenuTableType) {
    KLMenuTableLeftType,
    KLMenuTableRightType,
};

@interface KLMenuIndexPath : NSObject
/** 第几个表视图 */
@property (nonatomic, assign) NSInteger column;

/** 表视图列表的行 */
@property (nonatomic, assign) NSInteger row;

/** table类型, 是左边的 table 还是右边的 */
@property (nonatomic, assign) KLMenuTableType menuTableType;

/** 表视图左列表的行 */
@property (nonatomic, assign) NSInteger leftItem;



+ (instancetype)menuIndexPathColumn:(NSInteger)column row:(NSInteger)row menuTableType:(KLMenuTableType)menuTableType leftItem:(NSInteger)leftItem;
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row menuTableType:(KLMenuTableType)menuTableType leftItem:(NSInteger)leftItem;

@end
