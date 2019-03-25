//
//  MBVideoMakeBottomBar.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/21.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBVideoMakeBottomBarDelegate <NSObject>

@optional
/** 发现*/
- (void)findSomeFunnyVideo;
/**录音*/
- (void)beginOrEndRecordAudio:(UIButton *)recordBtn;
/**选择本地视频库*/
- (void)selectLocalVideoLibrary;

@end

@interface MBVideoMakeBottomBar : UIView

/** 代理*/
@property (nonatomic, weak) id<MBVideoMakeBottomBarDelegate> delegate;

/** 最新的视频缩略图*/
@property (nonatomic, strong) UIImage * videoImage;

- (void)handlerShowWhenRecordState:(BOOL)state;


@end

NS_ASSUME_NONNULL_END
