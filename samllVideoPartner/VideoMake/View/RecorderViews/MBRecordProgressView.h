//
//  MBRecordProgressView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/21.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBRecordProgressView : UIView

/** 录音的最大时长，默认15，VIP 60*/
@property (nonatomic, assign) float  maxValue;

/** 定时器适时更新时间*/
@property (nonatomic, copy) NSString *time;

/** 重置到最初状态*/
- (void)resetProgressView;

/** 适时添加声音振幅值，绘制音波图像*/
- (void)addRecorderLevels:(NSNumber *)value;

@end

NS_ASSUME_NONNULL_END
