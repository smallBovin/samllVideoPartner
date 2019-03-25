//
//  MBMusicChooseView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBMusicChooseViewDelegate <NSObject>

@optional

- (void)closeMusicChooseView;

- (void)finishChooseMusic;

- (void)addOrChangeBackgroundMusic;

- (void)dragSliderToChangeOriginalVideoVolume:(CGFloat)volume;

- (void)dragSliderToChangeBgMusicVolume:(CGFloat)volume;

@end

@interface MBMusicChooseView : UIView

/** 选择的音乐名称*/
@property (nonatomic, copy) NSString * musicName;

/** 代理*/
@property (nonatomic, weak) id<MBMusicChooseViewDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
