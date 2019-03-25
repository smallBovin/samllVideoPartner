//
//  MBVideoPlayer.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBVideoPlayer.h"

@interface MBVideoPlayer ()

/** 视频播放器*/
@property (nonatomic, strong) AVPlayerItem      *playItem;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;
@property (nonatomic, strong) AVPlayer          *player;


@end

@implementation MBVideoPlayer

SINGLETON_IMPLEMENT(Instance)

- (AVPlayerLayer *)createVideoPlayerWithUrl:(NSURL *)url bounds:(CGRect)bounds {
    // 手机静音时可播放声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.playItem = [AVPlayerItem playerItemWithURL:url];
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    self.playerLayer.frame = bounds;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
    return self.playerLayer;
    
}

- (void)stop {
    [self playFinished];
}

#pragma mark - KVO属性播放属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                [self.player play];
                self.isPlaying = YES;
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}

- (void)playFinished {
    if (self.playFinishedblock) {
        self.playFinishedblock(YES);
    }
    [self.player pause];
    self.isPlaying = NO;
    [self.playItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.playItem = nil;
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
}
@end
