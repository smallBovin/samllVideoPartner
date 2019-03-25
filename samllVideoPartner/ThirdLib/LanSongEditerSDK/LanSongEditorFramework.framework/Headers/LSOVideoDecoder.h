//
//  LSOVideoDecoder.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/4.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanSongFilter.h"
#import "LSOMediaInfo.h"
#import "LSOFileUtil.h"


/**
 提取视频帧, 同步模式;
 */
@interface LSOVideoDecoder : LanSongOutput


@property(readonly, assign)BOOL isEnd;

/**
 初始化
 */
- (id)initWithURL:(NSURL *)url;

/**
 开始, 从0帧
 开启成功返回YES;
 */
-(BOOL)start;

/**
 从指定时间开启; 可以多次调用
 */
- (BOOL)start:(CGFloat)time;

/**
 停止;
 */
- (void)stop;


/**
 解码失败或解码结束,返回NO, 成功返回YES
 */
-(UIImage *)getOneFrame;
/**
 当前的进度的百分比;
 当前帧在总帧中的百分比
 @return 当前进度系数, 0.0---1.0f;
 */
- (float)progress;

/**
 当前 getOneFrame得到的图片的时间戳;
 */
-(float)getCurrentFramePts;
@property (nonatomic,readonly)   NSURL *videoUrl;
@end
