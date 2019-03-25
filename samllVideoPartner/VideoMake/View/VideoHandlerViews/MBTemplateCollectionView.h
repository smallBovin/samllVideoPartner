//
//  MBTemplateCollectionView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBStyleTemplateModel,MBMapsModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBTemplateType) {
    MBTemplateTypeStyle,
    MBTemplateTypeMaps,
};

@protocol MBTemplateCollectionViewDelegate <NSObject>

@optional

- (void)chooseTemplateWithType:(MBTemplateType)type isVipTemplate:(BOOL)isVip stickerImage:(nullable UIImage *)stickerImage templateModel:(nullable MBStyleTemplateModel *)templateModel;

- (void)closeChooseTemplateViewWithType:(MBTemplateType)type;

- (void)finishChooseTemplateWithType:(MBTemplateType)type;

@end

@interface MBTemplateCollectionView : UIView

/** 类型*/
@property (nonatomic, assign) MBTemplateType  type;

/** cell的尺寸size*/
@property (nonatomic, assign) CGSize  itemSize;
/** cell之间的间隙*/
@property (nonatomic, assign) CGFloat  spaceMargin;
/** section的inset*/
@property (nonatomic, assign) UIEdgeInsets  edgeInset;
/** cell的圆角大小*/
@property (nonatomic, assign) CGFloat  cellCornerRadius;
/** cell的阴影颜色*/
@property (nonatomic, strong) UIColor * cellShadowColor;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;

/** 代理*/
@property (nonatomic, weak) id<MBTemplateCollectionViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END


@interface MBTemplateCollectionCell : UICollectionViewCell

/** cell的圆角大小*/
@property (nonatomic, assign) CGFloat  cornerRadius;
/** cell的阴影颜色*/
@property (nonatomic, strong) UIColor * shadowColor;

/** 加载的图片*/
@property (nonatomic, strong) UIImage * showImage;

/**贴图 model*/
@property (nonatomic, strong) MBMapsModel * mapModel;
/**风格 model*/
@property (nonatomic, strong) MBStyleTemplateModel * styleModel;

@end
