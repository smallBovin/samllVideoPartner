//
//  MBMusicEditingView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBMusicEditingViewDelegate <NSObject>

@optional

- (void)closeMusicEditingView;

- (void)finishChooseEditingMusicWithBeginTime:(CMTime)startTime;




@end

@interface MBMusicEditingView : UIView

/** 代理*/
@property (nonatomic, weak) id<MBMusicEditingViewDelegate> delegate;

/** 关闭*/
@property (nonatomic, copy) void(^closeMusicEditingViewBlock)(void);
/** 完成*/
@property (nonatomic, copy) void(^FinishMusicEditingBlock)(CMTime startTime);

/** 当前的音乐链接*/
@property (nonatomic, strong) NSURL * audioUrl;


@end


NS_ASSUME_NONNULL_END
