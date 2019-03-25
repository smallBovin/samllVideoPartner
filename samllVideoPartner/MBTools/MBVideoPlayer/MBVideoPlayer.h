//
//  MBVideoPlayer.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBVideoPlayer : NSObject

SINGLETON_INTERFACE(Instance)

/** 是否正在播放*/
@property (nonatomic, assign) BOOL  isPlaying;

/** 播放完成回调*/
@property (nonatomic, copy) void(^playFinishedblock)(BOOL isFinish);

- (AVPlayerLayer *)createVideoPlayerWithUrl:(NSURL *)url bounds:(CGRect)bounds;

- (void)stop;
@end

NS_ASSUME_NONNULL_END
