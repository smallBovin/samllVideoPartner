//
//  MBSegmentScrollView.m
//  MBTodayNews
//
//  Created by Bovin on 2017/12/13.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import "MBSegmentScrollView.h"
#import "MBSegmentStyle.h"

@interface MBSegmentScrollView (){
    NSUInteger _currentIndex;   //当前选中的index
    NSUInteger _lastIndex;      //上一个选中的index
}

// 滚动条
@property (strong, nonatomic) UIImageView *scrollLine;
// 遮盖
@property (strong, nonatomic) UIView *coverLayer;
// 滚动scrollView
@property (strong, nonatomic) UIScrollView *scrollView;
// 背景ImageView
@property (strong, nonatomic) UIImageView *backgroundImageView;
// 附加的按钮
@property (strong, nonatomic) UIButton *extraBtn;
// 所有标题的设置
@property (strong, nonatomic) MBSegmentStyle *segmentStyle;
// 所有的标题
@property (strong, nonatomic) NSArray *titles;
// 用于懒加载计算文字的rgb差值, 用于颜色渐变的时候设置
@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRgb;
@property (strong, nonatomic) NSArray *normalColorRgb;
/** 缓存所有标题label */
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;
// 缓存计算出来的每个标题的宽度
@property (nonatomic, strong) NSMutableArray *titleWidths;

@property (nonatomic, copy)   MBSegmentTitleClickBlock titleClickBlock;

@end
//标题开始与结尾控件的距屏幕边距
#define leftAndRightMargin  7.0

@implementation MBSegmentScrollView


- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(MBSegmentStyle *)style titles:(NSArray *)titles titleDidClick:(MBSegmentTitleClickBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.segmentStyle = style;
        self.titleClickBlock = block;
        self.titles = titles;
        _currentIndex = 0;
        _lastIndex = 0;
        [self addSubview:self.backgroundImageView];
        [self setupScrollViewAndExtraBtn];
    }
    return self;
}
#pragma mark---初始化控件---------
- (void)setupScrollViewAndExtraBtn {
    CGFloat extraBtnH = self.frame.size.height;
    CGFloat extraBtnW = self.segmentStyle.extraBtnWidth ? self.segmentStyle.extraBtnWidth:extraBtnH;
    CGFloat scrollW = self.extraBtn ? (self.frame.size.width-extraBtnW) : self.frame.size.width;
    self.scrollView.frame = CGRectMake(0, 0, scrollW, self.frame.size.height);
    if (self.extraBtn) {
        self.extraBtn.frame = CGRectMake(self.frame.size.width-extraBtnW, 0, extraBtnW, extraBtnH);
    }
    //初始化标题按钮
    [self setupTitleLabels];
}
- (void)setupTitleLabels {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = title;
        label.tag = i;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.segmentStyle.normalTitleColor;
        label.font = self.segmentStyle.titleFont;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTitle:)];
        [label addGestureRecognizer:tap];
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(LONG_MAX, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.segmentStyle.titleFont} context:nil];
        [self.titleLabels addObject:label];
        [self.titleWidths addObject:@(bounds.size.width+self.segmentStyle.titleMargin)];
        [self.scrollView addSubview:label];
    }
    [self setupTitleLabelPosition];
    
}
- (void)setupTitleLabelPosition {
    
    CGFloat titleX = self.segmentStyle.edgeMargin;
    CGFloat titleH = self.frame.size.height;
    for (NSInteger i = 0; i < self.titleLabels.count; i++) {
        
        UILabel *label = self.titleLabels[i];
        CGFloat labelW = [self.titleWidths[i] floatValue];
        if (i > 0) {
            UILabel *lastLabel = self.titleLabels[i-1];
            titleX = CGRectGetMaxX(lastLabel.frame);
        }
        label.frame = CGRectMake(titleX, 0, labelW, titleH);
    }
    
    UILabel *firstLabel = self.titleLabels[0];
    if (firstLabel) {
        if (self.segmentStyle.isScaleTitle) {
            firstLabel.transform = CGAffineTransformMakeScale(self.segmentStyle.titleBigScale, self.segmentStyle.titleBigScale);
        }
        firstLabel.textColor = self.segmentStyle.selectedTitleColor;
    }
    
    UILabel *lastLabel = self.titleLabels.lastObject;
    if (lastLabel) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame)+self.segmentStyle.edgeMargin*2, self.frame.size.height);
    }
    [self setupTitleColverLayer];
}
- (void)setupTitleColverLayer {
    
    UILabel *firstLabel = self.titleLabels[0];
    CGFloat coverX = firstLabel.frame.origin.x;
    CGFloat coverW = firstLabel.frame.size.width;
    CGFloat coverH = self.segmentStyle.coverHeight>firstLabel.frame.size.height?firstLabel.frame.size.height:self.segmentStyle.coverHeight;
    CGFloat coverY = coverY = (self.frame.size.height - coverH) / 2;;
    CGFloat scrollLineY = self.frame.size.height - self.segmentStyle.scrollLineHeight -self.segmentStyle.scrollLineBottomMargin;
   
    if (self.scrollLine) {
        if (self.segmentStyle.scrollLineWidth) {
            self.scrollLine.center = CGPointMake(firstLabel.center.x, scrollLineY+self.segmentStyle.scrollLineHeight/2);
            self.scrollLine.bounds = CGRectMake(0.0, 0.0, self.segmentStyle.scrollLineWidth, self.segmentStyle.scrollLineHeight);
        }else {
            self.scrollLine.frame = CGRectMake(coverX, scrollLineY, coverW, self.segmentStyle.scrollLineHeight);
        }
        
    }
    
    if (self.coverLayer) {
        self.coverLayer.frame = CGRectMake(coverX - self.segmentStyle.coverHorizatalMargin, coverY, coverW + 2*self.segmentStyle.coverHorizatalMargin, coverH);
    }
    
}

#pragma mark---公用方法调用----------
- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated {
    
    if (_currentIndex == _lastIndex) {
        return;
    }
    UILabel *currentLabel = self.titleLabels[_currentIndex];
    UILabel *lastLabel = self.titleLabels[_lastIndex];
    
    [self setTitleOffSetToCurrentIndex:_currentIndex];
    
    NSTimeInterval duration = animated ? 0.3:0.0;

    [UIView animateWithDuration:duration animations:^{
       
        currentLabel.textColor = self.segmentStyle.selectedTitleColor;
        lastLabel.textColor = self.segmentStyle.normalTitleColor;
        
        if (self.segmentStyle.isScaleTitle) {
            lastLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            currentLabel.transform = CGAffineTransformMakeScale(self.segmentStyle.titleBigScale, self.segmentStyle.titleBigScale);
        }
        CGFloat coverH = self.segmentStyle.coverHeight>currentLabel.frame.size.height?currentLabel.frame.size.height:self.segmentStyle.coverHeight;
        CGFloat coverY = coverY = (self.frame.size.height - coverH) / 2;;
        if (self.scrollLine) {

            if (self.segmentStyle.scrollLineWidth) {
                self.scrollLine.center = CGPointMake(currentLabel.center.x, self.frame.size.height - self.segmentStyle.scrollLineHeight -self.segmentStyle.scrollLineBottomMargin+self.segmentStyle.scrollLineHeight/2);
                self.scrollLine.bounds = CGRectMake(0, 0, self.segmentStyle.scrollLineWidth, self.segmentStyle.scrollLineHeight);
            }else {
                self.scrollLine.frame = CGRectMake(currentLabel.frame.origin.x, self.frame.size.height - self.segmentStyle.scrollLineHeight -self.segmentStyle.scrollLineBottomMargin, currentLabel.frame.size.width, self.segmentStyle.scrollLineHeight);
            }
        }
        
        if (self.coverLayer) {
            
            self.coverLayer.frame = CGRectMake(currentLabel.frame.origin.x - self.segmentStyle.coverHorizatalMargin, coverY, currentLabel.frame.size.width + 2*self.segmentStyle.coverHorizatalMargin, coverH);
        }
        
    }];
    _lastIndex = _currentIndex;
    if (self.titleClickBlock) {
        self.titleClickBlock(currentLabel, _currentIndex);
    }
    
}

- (void)setTitleOffSetToCurrentIndex:(NSInteger)currentIndex {
    if (self.scrollView.contentSize.width<self.frame.size.width) {
        return;
    }
    UILabel *currentLabel = self.titleLabels[currentIndex];
    CGFloat offsetX = currentLabel.center.x - self.frame.size.width/2;
    if (offsetX<0) {
        offsetX = 0;
    }
    CGFloat extraWidth = self.extraBtn ? self.extraBtn.frame.size.width : 0.0;
    
    CGFloat maxOffsetX = self.scrollView.contentSize.width - (self.frame.size.width-extraWidth);
    if (maxOffsetX<0) {
        maxOffsetX = 0;
    }
    if (offsetX>maxOffsetX) {
        offsetX = maxOffsetX;
    }
    if (self.segmentStyle.isScrollTitle) {
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0.0) animated:YES];
    }
    
    if (!self.segmentStyle.isGradualChangeTitleColor) {
        for (NSInteger i = 0; i < self.titleLabels.count; i++) {
            UILabel *label = self.titleLabels[i];
            if (i == currentIndex) {
                label.textColor = self.segmentStyle.selectedTitleColor;
            }else {
                label.textColor = self.segmentStyle.normalTitleColor;
            }
        }
    }
}

- (void)adjustUIWithProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex {
    _lastIndex = currentIndex;
    UILabel *lastLabel = self.titleLabels[lastIndex];
    UILabel *currentLabel = self.titleLabels[currentIndex];
    
    CGFloat wProgress = progress;
    if (self.scrollLine) {
        if (self.segmentStyle.scrollLineWidth) {
            if (wProgress > 0.5) {
                wProgress = 1.0 - progress;
            }
            if (currentIndex>lastIndex) {   //向右滑动
                CGFloat xDistance = currentLabel.center.x - lastLabel.center.x;
                
                self.scrollLine.frame = CGRectMake(lastLabel.center.x-self.segmentStyle.scrollLineWidth/2+progress*xDistance, self.scrollLine.frame.origin.y, self.segmentStyle.scrollLineWidth, self.scrollLine.frame.size.height);
            }else {     //向左滑动
                CGFloat xDistance = lastLabel.center.x - currentLabel.center.x;
                self.scrollLine.frame = CGRectMake(lastLabel.center.x-self.segmentStyle.scrollLineWidth/2-progress*xDistance, self.scrollLine.frame.origin.y, self.segmentStyle.scrollLineWidth, self.scrollLine.frame.size.height);
            }
            
            
        }else {
            CGFloat xDistance = currentLabel.frame.origin.x - lastLabel.frame.origin.x;
            CGFloat wDistance = currentLabel.frame.size.width - lastLabel.frame.size.width;
            self.scrollLine.frame = CGRectMake(lastLabel.frame.origin.x+progress*xDistance, self.scrollLine.frame.origin.y, lastLabel.frame.size.width+progress*wDistance, self.scrollLine.frame.size.height);
        }
    }
    
    if (self.coverLayer) {
        CGFloat xDistance = currentLabel.frame.origin.x - lastLabel.frame.origin.x;
        CGFloat wDistance = currentLabel.frame.size.width - lastLabel.frame.size.width;
        self.coverLayer.frame = CGRectMake(lastLabel.frame.origin.x-self.segmentStyle.coverHorizatalMargin+xDistance*progress, self.coverLayer.frame.origin.y, lastLabel.frame.size.width+wDistance*progress, self.coverLayer.frame.size.height);
    }
    
    if (self.segmentStyle.isGradualChangeTitleColor) {
        lastLabel.textColor = [UIColor colorWithRed:[self.selectedColorRgb[0] floatValue] + [self.deltaRGB[0] floatValue] * progress green:[self.selectedColorRgb[1] floatValue] + [self.deltaRGB[1] floatValue] * progress blue:[self.selectedColorRgb[2] floatValue] + [self.deltaRGB[2] floatValue] * progress alpha:1.0];
        currentLabel.textColor = [UIColor colorWithRed:[self.normalColorRgb[0] floatValue] - [self.deltaRGB[0] floatValue] * progress green:[self.normalColorRgb[1] floatValue] - [self.deltaRGB[1] floatValue] * progress blue:[self.normalColorRgb[2] floatValue] - [self.deltaRGB[2] floatValue] * progress alpha:1.0];
    }else {
        for (NSInteger i = 0; i < self.titleLabels.count; i++) {
            UILabel *label = self.titleLabels[i];
            if (i == currentIndex) {
                label.textColor = self.segmentStyle.selectedTitleColor;
            }else {
                label.textColor = self.segmentStyle.normalTitleColor;
            }
        }
    }
    
    
    CGFloat deltaScale = self.segmentStyle.titleBigScale - 1.0;
    CGFloat lastTransformX = self.segmentStyle.titleBigScale - deltaScale * progress;
    CGFloat currentTransformX = 1.0 + deltaScale * progress;
    lastLabel.transform = CGAffineTransformMakeScale(lastTransformX, lastTransformX);
    currentLabel.transform = CGAffineTransformMakeScale(currentTransformX, currentTransformX);
    
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    
    NSAssert(index >= 0 && index < self.titles.count, @"设置的下标不合法!!");
    
    if (index<0 || index>=self.titles.count) {
        return;
    }
    
    _currentIndex = index;
    [self adjustUIWhenBtnOnClickWithAnimate:animated];
    
}



#pragma mark--setter--------

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (backgroundImage) {
        self.backgroundImageView.image = backgroundImage;
    }
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if (backgroundColor) {
        _backgroundImageView.backgroundColor = backgroundColor;
    }
}

#pragma mark-- 回调事件处理-------------
- (void)extraBtnClick:(UIButton *)extraBtn {
    if (self.extraBtnBlock) {
        self.extraBtnBlock();
    }
}

- (void)tapTitle:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (!label) {
        return;
    }
    _currentIndex = label.tag;
    [self adjustUIWhenBtnOnClickWithAnimate:YES];
}

#pragma mark--懒加载----
/** 初始化更多按钮*/
- (UIButton *)extraBtn {
    if (!self.segmentStyle.isShowExtraButton) {
        return nil;
    }
    
    if (!_extraBtn) {
        
        _extraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *imageName = self.segmentStyle.extraBtnBackgroundImageName ? self.segmentStyle.extraBtnBackgroundImageName : @"";
        [_extraBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [_extraBtn addTarget:self action:@selector(extraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _extraBtn.layer.shadowOffset = CGSizeMake(-5, 0);
        _extraBtn.layer.shadowColor = [UIColor whiteColor].CGColor;
        _extraBtn.layer.shadowOpacity = 0.8;
        
        
    }
    return _extraBtn;
}
/** 初始化可自定义主题背景图*/
- (UIImageView *)backgroundImageView {
    
    if (!_backgroundImageView) {
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageView;
}

- (UIView *)coverLayer {
    if (!self.segmentStyle.isShowCover) {
        return nil;
    }
    if (!_coverLayer) {
        
        _coverLayer = [[UIView alloc]init];
        _coverLayer.backgroundColor = self.segmentStyle.coverBackgroundColor;
        _coverLayer.layer.borderColor = self.segmentStyle.coverBorderColor.CGColor;
        _coverLayer.layer.borderWidth = 1.0;
        _coverLayer.layer.cornerRadius = self.segmentStyle.coverCornerRadius;
        _coverLayer.layer.masksToBounds = YES;
        [self.scrollView insertSubview:_coverLayer atIndex:0];
    }
    return _coverLayer;
}

- (UIImageView *)scrollLine {
    if (!self.segmentStyle.isShowLine) {
        return nil;
    }
    if (!_scrollLine) {
        
        _scrollLine = [[UIImageView alloc]init];
        if (self.segmentStyle.scrollLineImageName) {
            _scrollLine.image = [UIImage imageNamed:self.segmentStyle.scrollLineImageName];
        }else {
            _scrollLine.backgroundColor = self.segmentStyle.scrollLineColor;
        }
        [self.scrollView addSubview:_scrollLine];
    
    }
    return _scrollLine;
}
/** label容器*/
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self.backgroundImageView addSubview:_scrollView];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            UIViewController *vc = [self getCurrentViewController];
            vc.automaticallyAdjustsScrollViewInsets = NO;
        }
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
/** 获取当前view的父控制器*/
- (UIViewController *)getCurrentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    return nil;
}
/** 存放label*/
- (NSMutableArray *)titleLabels {
    
    if (!_titleLabels) {
        
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
/** 存放label的宽度*/
- (NSMutableArray *)titleWidths {
    
    if (!_titleWidths) {
        
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

#pragma mark--颜色过渡处理----------


- (NSArray *)deltaRGB {
    
    if (!_deltaRGB) {
        if (self.normalColorRgb && self.selectedColorRgb) {
            CGFloat deltaR = [self.normalColorRgb[0]floatValue]-[self.selectedColorRgb[0] floatValue];
            CGFloat deltaG = [self.normalColorRgb[1] floatValue] - [self.selectedColorRgb[1] floatValue];
            CGFloat deltaB = [self.normalColorRgb[2] floatValue] - [self.selectedColorRgb[2] floatValue];
            _deltaRGB = [NSArray arrayWithObjects:@(deltaR),@(deltaG),@(deltaB), nil];
        }
    }
    return _deltaRGB;
}

- (NSArray *)normalColorRgb {
    
    if (!_normalColorRgb) {
        
        _normalColorRgb = [NSArray arrayWithArray:[self getColorRgb:self.segmentStyle.normalTitleColor]];
        NSAssert(_normalColorRgb, @"设置正常状态的文字颜色时 请使用RGB空间的颜色值");
    }
    return _normalColorRgb;
}

- (NSArray *)selectedColorRgb {
    
    if (!_selectedColorRgb) {
        
        _selectedColorRgb = [NSArray arrayWithArray:[self getColorRgb:self.segmentStyle.selectedTitleColor]];
        NSAssert(_selectedColorRgb, @"设置选中状态的文字颜色时 请使用RGB空间的颜色值");
    }
    return _selectedColorRgb;
}

- (NSArray *)getColorRgb:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    }
    return rgbComponents;
    
}

@end
