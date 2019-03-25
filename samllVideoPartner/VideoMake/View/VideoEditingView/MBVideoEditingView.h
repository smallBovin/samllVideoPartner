//
//  MBVideoEditingView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol MBVideoEditingViewDelegate <NSObject>

@optional

- (void)saveAndUploadfinishEditedVideo;
/** 开始拖拽时*/
- (void)beginDragToCropVideo;
/** 拖拽过程中适时改变预览当前帧*/
- (void)dragingToChangeCurrentPlayerVideoFrameWithStartTime:(CMTime)startTime flag:(BOOL)flag;
/** 拖拽结束后显示开始与结束时间帧*/
- (void)dragedWithCropVideoStartTime:(CMTime)startTime endTime:(CMTime)endTime;


@end


@interface MBVideoEditingView : UIView

/** 图片帧数组*/
@property (nonatomic, strong) NSMutableArray<UIImage *> * imageArray;

/** 选择的视频*/
@property (nonatomic, strong) AVAsset *asset;

/** 代理*/
@property (nonatomic, weak) id<MBVideoEditingViewDelegate> delegate;

- (void)changePlayLinePosition;
@end

NS_ASSUME_NONNULL_END
