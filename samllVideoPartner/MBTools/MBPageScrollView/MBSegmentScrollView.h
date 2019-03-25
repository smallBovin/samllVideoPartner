//
//  MBSegmentScrollView.h
//  MBTodayNews
//
//  Created by Bovin on 2017/12/13.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBSegmentStyle;

typedef void(^MBSegmentTitleClickBlock)(UILabel *titleLabel,NSInteger index);
typedef void(^MBExtraBtnClickBlock)(void);

@interface MBSegmentScrollView : UIView
/** 自定义背景图，默认nil*/
@property (nonatomic, strong) UIImage *backgroundImage;
/** 自定义背景色，默认为透明*/
@property (nonatomic, strong) UIColor *backgroundColor;


@property (nonatomic, copy) MBExtraBtnClickBlock extraBtnBlock;

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(MBSegmentStyle *)style titles:(NSArray *)titles titleDidClick:(MBSegmentTitleClickBlock)block;

/** 点击按钮的时候调整UI,点击顶部的标题调用*/
- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated;
/** 切换下标的时候根据progress同步设置UI，下方内容滚动时调用*/
- (void)adjustUIWithProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex currentIndex:(NSInteger)currentIndex;
/** 让选中的标题居中*/
- (void)setTitleOffSetToCurrentIndex:(NSInteger)currentIndex;
/** 设置选中的下标*/
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
/** 重新刷新标题的内容*/
//- (void)reloadTitlesWithNewTitles:(NSArray *)titles;

@end
