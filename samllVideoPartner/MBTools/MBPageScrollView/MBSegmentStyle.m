//
//  MBSegmentStyle.m
//  MBTodayNews
//
//  Created by Bovin on 2017/12/13.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import "MBSegmentStyle.h"

@implementation MBSegmentStyle


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.showCover = NO;
        self.coverBackgroundColor = [UIColor lightGrayColor];
        self.coverCornerRadius = 4.0;
        self.coverHeight = 28.0;
        self.coverHorizatalMargin = 5.0;
        self.coverBorderColor = [UIColor clearColor];
        
        self.showLine = NO;
        self.scrollLineBottomMargin = 2.0;
        self.scrollLineHeight = 2.0;
        self.scrollLineColor = [UIColor brownColor];
        
        self.scaleTitle = NO;
        self.scrollTitle = YES;
        self.gradualChangeTitleColor = NO;
        self.titleMargin = 15.0;
        self.edgeMargin = 10.0;
        self.titleFont = [UIFont systemFontOfSize:15.0];
        self.titleBigScale = 1.0;
        self.normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:53.0/255.0 blue:75/255.0 alpha:1.0];
        self.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:121/255.0 alpha:1.0];
        
        self.showExtraButton = NO;
        self.segmentHeight = 44.0;
    }
    return self;
}
#pragma mark--setter--------------

/** 设置分段标题的属性*/
- (void)setScaleTitle:(BOOL)scaleTitle {
    _scaleTitle = scaleTitle;
}
- (void)setScrollTitle:(BOOL)scrollTitle {
    _scrollTitle = scrollTitle;
}
- (void)setGradualChangeTitleColor:(BOOL)gradualChangeTitleColor {
    _gradualChangeTitleColor = gradualChangeTitleColor;
}
- (void)setTitleMargin:(CGFloat)titleMargin {
    _titleMargin = titleMargin;
}
- (void)setEdgeMargin:(CGFloat)edgeMargin {
    _edgeMargin = edgeMargin;
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
}
- (void)setTitleBigScale:(CGFloat)titleBigScale {
    _titleBigScale = titleBigScale;
}
- (void)setNormalTitleColor:(UIColor *)normalTitleColor {
    _normalTitleColor = normalTitleColor;
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
}

/** 设置当前标题的指示线*/
- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
}
- (void)setScrollLineWidth:(CGFloat)scrollLineWidth {
    _scrollLineWidth = scrollLineWidth;
}
- (void)setScrollLineHeight:(CGFloat)scrollLineHeight {
    _scrollLineHeight = scrollLineHeight;
}
- (void)setScrollLineBottomMargin:(CGFloat)scrollLineBottomMargin {
    _scrollLineBottomMargin = scrollLineBottomMargin;
    if (scrollLineBottomMargin<0) {
        _scrollLineBottomMargin = 0.0;
    }
    if (scrollLineBottomMargin>5.0) {
        _scrollLineBottomMargin = 5.0;
    }
}
- (void)setScrollLineColor:(UIColor *)scrollLineColor {
    _scrollLineColor = scrollLineColor;
}
- (void)setScrollLineImageName:(NSString *)scrollLineImageName {
    _scrollLineImageName = scrollLineImageName;
}

/** 设置遮盖层属性*/
- (void)setShowCover:(BOOL)showCover {
    _showCover = showCover;
}
- (void)setCoverHeight:(CGFloat)coverHeight {
    _coverHeight = coverHeight;
}
- (void)setCoverHorizatalMargin:(CGFloat)coverHorizatalMargin {
    _coverHorizatalMargin = coverHorizatalMargin;
}
- (void)setCoverCornerRadius:(CGFloat)coverCornerRadius {
    _coverCornerRadius = coverCornerRadius;
}
- (void)setCoverBackgroundColor:(UIColor *)coverBackgroundColor {
    _coverBackgroundColor = coverBackgroundColor;
}
- (void)setCoverBorderColor:(UIColor *)coverBorderColor {
    _coverBorderColor = coverBorderColor;
}

/** 更多按钮*/
- (void)setShowExtraButton:(BOOL)showExtraButton {
    _showExtraButton = showExtraButton;
}
- (void)setExtraBtnWidth:(CGFloat)extraBtnWidth {
    _extraBtnWidth = extraBtnWidth;
}
- (void)setExtraBtnBackgroundImageName:(NSString *)extraBtnBackgroundImageName {
    _extraBtnBackgroundImageName = extraBtnBackgroundImageName;
}

- (void)setSegmentHeight:(CGFloat)segmentHeight {
    _segmentHeight = segmentHeight;
}
@end
