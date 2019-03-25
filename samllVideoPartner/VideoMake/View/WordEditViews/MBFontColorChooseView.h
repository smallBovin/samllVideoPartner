//
//  MBFontColorChooseView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBWordFontColorModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBWordEditType) {
    MBWordEditTypeFont,     //字体编辑
    MBWordEditTypeColor,    //文字颜色编辑
};

@protocol MBFontColorChooseDelegate <NSObject>

-(void)selectWordFontColor:(MBWordEditType)editType model:(MBWordFontColorModel *)model;

@end


@interface MBFontColorChooseView : UIView
/**   */
@property (nonatomic , weak)id <MBFontColorChooseDelegate> delegate;

/** 选择类型*/
@property (nonatomic, assign) MBWordEditType  editType;

/** 父控制器*/
@property (nonatomic, weak) UIViewController * superVC;

/** cell的尺寸size*/
@property (nonatomic, assign) CGSize  itemSize;
/** cell之间的间隙*/
@property (nonatomic, assign) CGFloat  spaceMargin;
/** section的inset*/
@property (nonatomic, assign) UIEdgeInsets  edgeInset;
/** cell的圆角大小*/
@property (nonatomic, assign) CGFloat  cellCornerRadius;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;

/** */
@property (nonatomic , copy) NSString *fontTitle;

@end


@interface MBWordEditCollectionCell : UICollectionViewCell
/** 类型选择*/
@property (nonatomic, assign)MBWordEditType  type;
/**   */
@property (nonatomic , strong)MBWordFontColorModel *model;

@end

NS_ASSUME_NONNULL_END
