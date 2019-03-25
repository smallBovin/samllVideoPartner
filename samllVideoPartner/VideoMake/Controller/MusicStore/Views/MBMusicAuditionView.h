//
//  MBMusicAuditionView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBMapsModel;
NS_ASSUME_NONNULL_BEGIN

@protocol MBMusicAuditionViewDelegate <NSObject>

@optional

- (void)directUseCurrentAuditionMusic;

- (void)editCurrentAuditionMusic;

@end

@interface MBMusicAuditionView : UIView

/** 代理*/
@property (nonatomic, weak) id<MBMusicAuditionViewDelegate> delegate;

/** 音乐播放model*/
@property (nonatomic, strong) MBMapsModel * audioModel;

/** 本地的音乐链接*/
@property (nonatomic, copy) NSURL * localAudioUrl;

@end

NS_ASSUME_NONNULL_END
