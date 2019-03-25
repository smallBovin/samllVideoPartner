//
//  MBSegmentStyle.h
//  MBTodayNews
//
//  Created by Bovin on 2017/12/13.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBSegmentStyle : NSObject

/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic, getter=isShowLine) BOOL showLine;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的宽度 默认为标题宽度*/
@property (assign, nonatomic) CGFloat scrollLineWidth;
/** 滚动条距离底部的距离0~5.0，默认为2.0*/
@property (assign, nonatomic) CGFloat scrollLineBottomMargin;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 滚动条的图片名,与scrollLineHeight和scrollLineColor不共存*/
@property (strong, nonatomic) NSString *scrollLineImageName;

/** 是否显示遮盖 默认为NO */
@property (assign, nonatomic, getter=isShowCover) BOOL showCover;
/** 遮盖的颜色 */
@property (strong, nonatomic) UIColor *coverBackgroundColor;
/** 遮盖的圆角 默认为4*/
@property (assign, nonatomic) CGFloat coverCornerRadius;
/** 遮盖的高度 默认为28*/
@property (assign, nonatomic) CGFloat coverHeight;
/** 遮盖在横向与控件的间隙 默认为5*/
@property (assign, nonatomic) CGFloat coverHorizatalMargin;
/** 遮盖的边框颜色，默认颜色透明、宽度为 1*/
@property (strong, nonatomic) UIColor *coverBorderColor;


/** 是否缩放标题 默认为NO*/
@property (assign, nonatomic, getter=isScaleTitle) BOOL scaleTitle;
/** 是否滚动标题 默认为YES*/
@property (assign, nonatomic, getter=isScrollTitle) BOOL scrollTitle;
/** 是否颜色渐变 默认为NO*/
@property (assign, nonatomic, getter=isGradualChangeTitleColor) BOOL gradualChangeTitleColor;
/** 标题之间的间隙 默认为15.0 */
@property (assign, nonatomic) CGFloat titleMargin;
/**标题最左与最右边缘的距离*/
@property (nonatomic, assign) CGFloat edgeMargin;
/** 标题的字体 默认为15 */
@property (strong, nonatomic) UIFont *titleFont;
/** 标题缩放倍数, 默认1.0 */
@property (assign, nonatomic) CGFloat titleBigScale;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;


/** 是否显示附加的按钮 默认为NO*/
@property (assign, nonatomic, getter=isShowExtraButton) BOOL showExtraButton;
/** 附加按钮的宽度，默认与高度相等为控件高度*/
@property (assign, nonatomic) CGFloat extraBtnWidth;
/** 设置附加按钮的背景图片 默认为nil*/
@property (strong, nonatomic) NSString *extraBtnBackgroundImageName;
/** segmentVIew的高度, 这个属性只在使用MBPageScrollVIew的时候设置生效 默认44*/
@property (assign, nonatomic) CGFloat segmentHeight;

@end
