//
//  KLDropDownMenu.m
//  测试菜单的
//
//  Created by leqiang222 on 2017/4/7.
//  Copyright © 2017年 静持大师. All rights reserved.
//

#import "KLDropDownMenu.h"
#import "KLMenuIndexPath.h"
#import "NSString+MenuSize.h"
#import "KLMenuTableViewCell.h"

#define KLColor(r, g, b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 菜单栏未选中背景颜色
#define MENU_NORMAL_BG_COLOR [UIColor whiteColor]
// 选中颜色加深
#define SELECT_COLOR KLColor(245.0f, 245.0f, 245.0f)

#define MENU_SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)  // 获取屏幕宽度
#define MENU_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)  // 获取屏幕宽度

@interface KLDropDownMenu() <UITableViewDataSource, UITableViewDelegate>
{
    CGPoint _origin;        // 菜单栏坐标
    CGFloat _menuHeight;    // 菜单栏高度
    NSInteger _selMenuIndex; // 当前选中的菜单栏目索引
    NSInteger _menuNum;   // 菜单个数
    BOOL _show;             // 菜单是否显示, default is NO
    NSInteger _leftSelItem; // 左边选中的 cell 的 index
    
    
    BOOL _isHaveSel;
}
/** 表视图 左边的列表 */
@property (nonatomic, strong) UITableView       *leftTableView;
/** 表视图 右边的列表 */
@property (nonatomic, strong) UITableView       *rightTableView;
/** 背景 */
@property (nonatomic, strong) UIView            *backGroundView;

/** 标题 */
@property (nonatomic, copy) NSArray <CATextLayer *>*titles;
/** 菜单栏上绘制的箭头 */
@property (nonatomic, copy) NSArray <CAShapeLayer *>*indicators;
/** 菜单栏绘制的背景颜色 */
@property (nonatomic, copy) NSArray <CALayer *>*bgLayers;
@end

@implementation KLDropDownMenu

#pragma mark - init method 初始化
+ (instancetype)dropDownMenuWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    return [[self alloc] initWithOrigin:origin andHeight:height];
}

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, MENU_SCREEN_WIDTH, height)];
    
    if (self) {
        self.autoresizesSubviews = NO;
        
        // 1.初始化数据
        _menuHeight = height;
        _origin = origin;
        _selMenuIndex = -1;
        _show = NO;
//        _hadSelected = NO;
        
        // 2.菜单栏点击事件
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuDidTapped:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.dataSource != nil, @"菜单的 datasource 不能为空");
    
    KLMenuTableType menuTableType = KLMenuTableLeftType;
    if (self.rightTableView == tableView) {
        menuTableType = KLMenuTableRightType;
    }

    KLMenuIndexPath *menuIndexPath = [KLMenuIndexPath menuIndexPathColumn:_selMenuIndex row:0 menuTableType:menuTableType leftItem:_leftSelItem];
    
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfMenuIndexPath:)]) {
        return [self.dataSource menu:self numberOfMenuIndexPath:menuIndexPath];;
    }else {
        NSAssert(0 == 1, @"没有实现 'menu:numberOfMenuIndexPath:' 这个 data source 方法");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KLMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuTableViewCellId];
    
    KLMenuTableType menuTableType = KLMenuTableLeftType;
    if (self.rightTableView == tableView) {
        menuTableType = KLMenuTableRightType;
    }
    
    KLMenuIndexPath *menuIndexPath = [KLMenuIndexPath menuIndexPathColumn:_selMenuIndex row:indexPath.row menuTableType:menuTableType leftItem:_leftSelItem];
    
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtMenuIndexPath:)]) {
        cell.menuTitle = [self.dataSource menu:self titleForRowAtMenuIndexPath:menuIndexPath];
    }
    
    switch (menuTableType) {
        case KLMenuTableLeftType: { // 左边 table
            BOOL ishaveRightTab = [_dataSource isHaveTwoTableViewInColumn:_selMenuIndex];
            
            if (ishaveRightTab) {
                cell.isDisplayTag = NO;
                cell.bgColor = (indexPath.row == _leftSelItem)? SELECT_COLOR: MENU_NORMAL_BG_COLOR;
                
            }else {
                if ([self.dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
                    NSInteger selRow = [self.dataSource currentLeftSelectedRow:_selMenuIndex];
                    
                    cell.isDisplayTag = indexPath.row == selRow;
                    cell.bgColor = cell.isDisplayTag? SELECT_COLOR: MENU_NORMAL_BG_COLOR;
                    
                }else {
                    cell.isDisplayTag = NO;
                    cell.bgColor = MENU_NORMAL_BG_COLOR;
                }
            }

        }
            break;
        case KLMenuTableRightType: { // 右边 table
            NSString *colTitle = nil;
            if ([self.dataSource respondsToSelector:@selector(menu:titleForColumn:)]) {
                colTitle = [self.dataSource menu:self titleForColumn:_selMenuIndex];
            }
            
            BOOL isDisplayTag = ([colTitle isEqualToString:_titles[_selMenuIndex].string] && _leftSelItem == 0 && indexPath.row == 0) || [cell.menuTitle isEqualToString:_titles[_selMenuIndex].string];
            
            cell.isDisplayTag = isDisplayTag;
            cell.bgColor = MENU_NORMAL_BG_COLOR;
        }
            break;
    }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KLMenuTableType menuTableType = KLMenuTableLeftType;
    
    if (self.rightTableView == tableView) {
        menuTableType = KLMenuTableRightType;
    }else {
        _leftSelItem = indexPath.row;
    }
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
        
        BOOL ishaveRightTable = [self.dataSource isHaveTwoTableViewInColumn:_selMenuIndex];
        
        if ((menuTableType == KLMenuTableLeftType && !ishaveRightTable) ||
            menuTableType == KLMenuTableRightType) {
            [self confiMenuWithSelectRow:indexPath.row menuTableType:menuTableType];
        }
        
        if ([self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:)]) {
            KLMenuIndexPath *menuIndexPath = [KLMenuIndexPath menuIndexPathColumn:_selMenuIndex row:indexPath.row menuTableType:menuTableType leftItem:_leftSelItem];
            
            [self.delegate menu:self didSelectRowAtIndexPath:menuIndexPath];
        }
        
        // 如果点击了两列 table 中的左边
        if (menuTableType == KLMenuTableLeftType && ishaveRightTable) {
            if (!_isHaveSel) {
                _isHaveSel = YES;
                
                [self.leftTableView reloadData];
                
                NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_leftSelItem inSection:0];
                
                [self.leftTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            [self.rightTableView reloadData];
        }
    }
}

- (void)confiMenuWithSelectRow:(NSInteger)row menuTableType:(KLMenuTableType)menuTableType {
    
    CATextLayer *title = _titles[_selMenuIndex];
    
    BOOL isSeletedFirst = (row == 0 && menuTableType == KLMenuTableRightType && _leftSelItem == 0) ||
                         (row == 0 && menuTableType == KLMenuTableLeftType);
    
    if (isSeletedFirst) {
        title.string = [self.dataSource menu:self titleForColumn:_selMenuIndex];
    }else {
        if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtMenuIndexPath:)]) {
            KLMenuIndexPath *menuIndexPath = [KLMenuIndexPath menuIndexPathColumn:_selMenuIndex row:row menuTableType:menuTableType leftItem:_leftSelItem];
            
            title.string = [self.dataSource menu:self titleForRowAtMenuIndexPath:menuIndexPath];
        }
    }
    
    [self animateIdicator:_indicators[_selMenuIndex]
               background:self.backGroundView
            leftTableView:self.leftTableView
           rightTableView:self.rightTableView
                    title:_titles[_selMenuIndex]
                  forward:NO
                complecte:^{
                    _show = NO;
                }];
    
    [self.bgLayers[_selMenuIndex] setBackgroundColor:MENU_NORMAL_BG_COLOR.CGColor];
    
    // 重新设置箭头的 position
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_selMenuIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}


#pragma mark - gesture handle 手势触发事件
/**
 *  菜单栏点击事件
 */
- (void)menuDidTapped:(UITapGestureRecognizer *)paramSender {
    CGPoint touchPoint = [paramSender locationInView:self];
    
    // 1.菜单栏点击 index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _menuNum);
    
    // 2.非点击的菜单栏箭头方向复位
    for (int i = 0; i < _menuNum; i++) {
        if (i != tapIndex) {
            // 2.1 箭头动画
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                // 2.2 设置标题的大小
                [self animateTitle:_titles[i] show:NO complete:nil];
            }];
            [self.bgLayers[i] setBackgroundColor:MENU_NORMAL_BG_COLOR.CGColor];
        }
    }
    
    // 3.tableView 的显示和隐藏
    // 3.1 先移除之前的
    [self.leftTableView removeFromSuperview];
    [self.rightTableView removeFromSuperview];
    
    BOOL isHaveTwoTableView = [_dataSource isHaveTwoTableViewInColumn:tapIndex];
    UITableView *rightTableView = nil;
    
    if (isHaveTwoTableView) {
        rightTableView = self.rightTableView;
    }
    
    // 3.2 点击的是已显示的菜单栏目
    if (tapIndex == _selMenuIndex && _show) {
        [self animateIdicator:_indicators[_selMenuIndex]
                   background:self.backGroundView
                leftTableView:self.leftTableView
               rightTableView:rightTableView
                        title:_titles[_selMenuIndex]
                      forward:NO
                    complecte:^{
                          _selMenuIndex = tapIndex;
                          _show = NO;
                      }];
        
        [self.bgLayers[tapIndex] setBackgroundColor:MENU_NORMAL_BG_COLOR.CGColor];
    }
    else { // 3.3 点击未显示的菜单栏目
        _isHaveSel = NO;
        
        _selMenuIndex = tapIndex;
        
        // 3.3.1 获得 leftTableView 选中的 index
        if ([_dataSource respondsToSelector:@selector(currentLeftSelectedRow:)]) {
            _leftSelItem = [_dataSource currentLeftSelectedRow:_selMenuIndex];
        }
        
        [self.leftTableView reloadData];
        if (rightTableView) {
            [rightTableView reloadData];
        }
        
        // 3.3.2 leftTableView 和 rightTableView 的 fram
        CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_selMenuIndex];
        self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width * ratio, 0);
        
        if (rightTableView) {
            rightTableView.frame = CGRectMake(_origin.x + self.leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width * (1-ratio), 0);
        }
        
        // 3.3.3 动画
        [self animateIdicator:_indicators[tapIndex]
                   background:self.backGroundView
                leftTableView:self.leftTableView
               rightTableView:rightTableView
                        title:_titles[tapIndex]
                      forward:YES
                    complecte:^{
                        _show = YES;
                    }];
    
        [self.bgLayers[tapIndex] setBackgroundColor:SELECT_COLOR.CGColor];
    }
}

/**
 *  背景View 被点击
 */
- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender {
    [self animateIdicator:_indicators[_selMenuIndex]
               background:self.backGroundView
            leftTableView:self.leftTableView
           rightTableView:self.rightTableView
                    title:_titles[_selMenuIndex]
                  forward:NO
                complecte:^{
                    _show = NO;
                }];
    
    [self.bgLayers[_selMenuIndex] setBackgroundColor:MENU_NORMAL_BG_COLOR.CGColor];
}

#pragma mark - Private (创建需要的图层, 包括背景, 箭头, 文字等)
/**
 *  创建菜单栏背景 layer
 */
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width / _menuNum, self.frame.size.height - 1);
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

/**
 *  创建箭头 layer
 */
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

/**
 *  创建分割线 layer
 */
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, self.frame.size.height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}

/**
 *  创建文字图层
 */
- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [string kl_calculateTitleSize];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _menuNum) - 25) ? size.width : self.frame.size.width / _menuNum - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 14.0;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

#pragma mark - Private (动画方法)
/**
 旋转动画
 
 @param indicator <#indicator description#>
 @param forward   <#forward description#>
 @param complete  <#complete description#>
 */
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward? @[@0, @(M_PI) ]: @[@(M_PI), @0 ];
    
    [indicator addAnimation:anim forKey:anim.keyPath];
    if (anim.removedOnCompletion) {
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    if (complete) {
        complete();
    }
}

/**
 背景 view 消失显示动画
 
 @param view     <#view description#>
 @param show     <#show description#>
 @param complete <#complete description#>
 */
- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    
    if (complete) {
        complete();
    }
}

/**
 *  动画显示下拉tableView类型菜单
 */
- (void)animateLeftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView show:(BOOL)show complete:(void(^)())complete {
    // 1.
    CGFloat ratio = [_dataSource widthRatioOfLeftColumn:_selMenuIndex];
    
    // 2.显示 tableView
    if (show) {
        CGFloat leftTableViewHeight = 0;
        CGFloat rightTableViewHeight = 0;
        CGFloat maxDisplayH = (MENU_SCREEN_HEIGHT - 64 - _menuHeight);
        
        // 2.1 左边 tableView
        if (leftTableView) {
            leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            [self.superview addSubview:leftTableView];
            
            if ([leftTableView numberOfRowsInSection:0] > (maxDisplayH / leftTableView.rowHeight)) {
                leftTableViewHeight = maxDisplayH;
            }else {
                leftTableViewHeight = [leftTableView numberOfRowsInSection:0] * leftTableView.rowHeight;
            }
        }
        
        // 2.2 右边 tableView
        if (rightTableView) {
            rightTableView.frame = CGRectMake(_origin.x + leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            
            [self.superview addSubview:rightTableView];
            
            if ([rightTableView numberOfRowsInSection:0] > (maxDisplayH / rightTableView.rowHeight)) {
                rightTableViewHeight = maxDisplayH;
            }else {
                rightTableViewHeight = [rightTableView numberOfRowsInSection:0] * rightTableView.rowHeight;
            }
        }
        
        // 2.3 动画
        CGFloat tableViewHeight = MAX(leftTableViewHeight, rightTableViewHeight);
        
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, tableViewHeight);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), tableViewHeight);
            }
        }];
        
    }else { // 3.隐藏
        [UIView animateWithDuration:0.2 animations:^{
            if (leftTableView) {
                leftTableView.frame = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width*ratio, 0);
            }
            if (rightTableView) {
                rightTableView.frame = CGRectMake(_origin.x+leftTableView.frame.size.width, self.frame.origin.y + self.frame.size.height, self.frame.size.width*(1-ratio), 0);
            }
            
        } completion:^(BOOL finished) {
            
            if (leftTableView) {
                [leftTableView removeFromSuperview];
            }
            if (rightTableView) {
                [rightTableView removeFromSuperview];
            }
        }];
    }
    
    if (complete) {
        complete();
    }
}

/**
 *  设置标题的大小
 */
- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    CGSize size = [title.string kl_calculateTitleSize];
    
    // 文字宽度最大为矩形框宽度-25
    CGFloat sizeWidth = 0;
    if (size.width < (self.frame.size.width / _menuNum) - 25) {
        sizeWidth = size.width;
    }else {
        sizeWidth = self.frame.size.width / _menuNum - 25;
    }
    
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    
    if (complete) {
        complete();
    }
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background leftTableView:(UITableView *)leftTableView rightTableView:(UITableView *)rightTableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateLeftTableView:leftTableView rightTableView:rightTableView show:forward complete:nil];
            }];
        }];
    }];
    
    if (complete) {
        complete();
    }
}

#pragma mark - Getter、Setter方法
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = KLColor(102.0, 102.0, 102.0);
    }
    return _indicatorColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = KLColor(51.0, 51.0, 51.0);
    }
    return _textColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = KLColor(238.0, 238.0, 238.0);
    }
    return _separatorColor;
}

- (void)setDataSource:(id<KLDropDownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    //
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _menuNum = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _menuNum = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _menuNum * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _menuNum;
    CGFloat bgLayerInterval = self.frame.size.width / _menuNum;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_menuNum];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_menuNum];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_menuNum];
    
    for (int i = 0; i < _menuNum; i++) {
        // 背景 layer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval, _menuHeight / 2);
        CALayer *bgLayer = [self createBgLayerWithColor:MENU_NORMAL_BG_COLOR andPosition:bgLayerPosition];
        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        
        // 初始化的标题
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval , _menuHeight / 2);
        NSString *titleString = [_dataSource menu:self titleForColumn:i];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        
        // 箭头 layer
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 8, _menuHeight / 2)];
        [self.layer addSublayer:indicator];
        [tempIndicators addObject:indicator];
        
        // 分割线 layer
        if (i != _menuNum - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, _menuHeight / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
    }
    
    // 添加菜单底部下划线
    UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, MENU_SCREEN_WIDTH, 1)];
    bottomShadow.backgroundColor = self.separatorColor;
    [self addSubview:bottomShadow];
    
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}


#pragma mark - Lazy
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        CGRect fram = CGRectMake(_origin.x, self.frame.origin.y + self.frame.size.height, 0, 0);
        UITableView *leftTableView = [self setupTableViewWithFram:fram];
        
        _leftTableView = leftTableView;
    }
    return _leftTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        CGRect fram = CGRectMake(self.frame.size.width, self.frame.origin.y + self.frame.size.height, 0, 0);
        UITableView *rightTableView = [self setupTableViewWithFram:fram];
        
        _rightTableView = rightTableView;
    }
    return _rightTableView;
}

- (UITableView *)setupTableViewWithFram:(CGRect)fram {
    UITableView *tableView = [[UITableView alloc] initWithFrame:fram style:UITableViewStyleGrouped];
    
    tableView.rowHeight = 44;
    tableView.separatorColor = self.separatorColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.autoresizesSubviews = NO;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(KLMenuTableViewCell.class) bundle:nil] forCellReuseIdentifier:kMenuTableViewCellId];
    
    return tableView;
}

- (UIView *)backGroundView {
    if (!_backGroundView) {
        CGRect fram = CGRectMake(_origin.x, _origin.y, MENU_SCREEN_WIDTH, MENU_SCREEN_HEIGHT);
        UIView *backGroundView = [[UIView alloc] initWithFrame:fram];
        
        backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        backGroundView.opaque = NO;
        
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [backGroundView addGestureRecognizer:gesture];
        
        _backGroundView = backGroundView;
    }
    return _backGroundView;
}

@end
