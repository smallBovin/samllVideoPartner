//
//  MBAudioPlayer.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AudioPlayProgressBlock)(CGFloat progress);

typedef NS_ENUM(NSUInteger, MBAudioPlayerState) {
    MBAudioPlayerStateReadyToPlay,
    MBAudioPlayerStatePlaying,
    MBAudioPlayerStatePaused,
    MBAudioPlayerStatePlayEnd,
    MBAudioPlayerStateFailed,
};



@protocol MBAudioPlayerDelegate <NSObject>

@optional
- (void)currentPlayerState:(MBAudioPlayerState)playState;

@end

@interface MBAudioPlayer : NSObject

/** 进度回调*/
@property (nonatomic, copy) AudioPlayProgressBlock  progress;
/** 代理*/
@property (nonatomic, weak) id<MBAudioPlayerDelegate> delegate;

/** 是否需要监听进度*/
@property (nonatomic, assign) BOOL  isObserverProgress;

- (void)playerAudioWithUrl:(NSURL *)URL;

- (void)play;

- (void)setVideoSpeed:(CGFloat)speed;

- (void)setVolume:(float)volume;

- (void)pause;
/** 相当于销毁播放器*/
- (void)stop;
/** 重新从头播放*/
- (void)reStart;
/** 已经播放*/
- (void)seekToTime:(CMTime)startTime;


@end

NS_ASSUME_NONNULL_END
