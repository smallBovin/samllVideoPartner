//
//  LSOVideoOneDo.h
//  LanSongEditorFramework
//
//  Created by sno on 2019/1/4.
//  Copyright © 2019 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import "LSOMediaInfo.h"
#import "LanSongFilter.h"


/**
 视频的常见处理:
 当前可以完成:
 1.增加背景音乐+调节音量,2.裁剪时长,3.裁剪画面,4.缩放,5.增加Logo,6.增加文字,7.设置滤镜,8.设置码率(压缩),9.增加美颜,10.增加封面,11增加UI界面,12,增加马赛克.
 调用流程是:
 init--->setXXX--->设置进度完成回调--->start;
 */
@interface LSOVideoOneDo : NSObject

-(id)initWithNSURL:(NSURL *)videoURL;

@property (readonly,nonatomic)LSOMediaInfo *mediaInfo;

@property (readonly)BOOL  isRunning;
/**
 得到视频的宽高
 */
-(float)getVideoWidth;

/**
 得到视频的宽高
 */
-(float)getVideoHeight;

/**
 设置视频的音量大小.
 在需要增加其他声音前调用(addAudio后调用无效).
 不调用默认是原来的声音大小;
 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 设置为0, 则静音;
 */
@property(readwrite, nonatomic) float videoUrlVolume;

/**
 裁剪开始时长
 */
@property(readwrite, nonatomic) float cutStartTimeS;
/**
 要裁剪的时长;
 */
@property(readwrite, nonatomic) float cutDurationTimeS;


/**
 恢复所有默认值;
 [清除所有设置的参数]
 */
-(void)resetAllValue;
/**
 视频裁剪;
 注意:
 1.CGRect中的x,y如是小数,则调整为整数;
 2.CGRect中的width,height如是奇数,则调整为偶数.(能被2整除的数)
 */
@property (readwrite,nonatomic)CGRect cropRect;

/**
 设置视频缩放到的目标大小;
 */
@property (readwrite,nonatomic)CGSize scaleSize;

/**
 视频编码码率;
 (起到视频压缩的作用)
 */
@property (readwrite,nonatomic)int bitrate;

/**
 视频增加UI图层;
 (可以设置logo, 文字, 等其他控件, 不支持用OpenGL实现的控件,比如AVPlayerLayer)
 
 请务必:
 如果裁剪则view的宽高等于裁剪的宽高;
 如果没有,则等于视频的宽高;
 
 UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, encoderSize.width, encoderSize.height)];
 执行流程是: 先裁剪--->执行滤镜--->设置马赛克区域--->增加UI层-->缩放--->设置码率,编码;
 */
-(void)setUIView:(UIView *)view;

/**
设置滤镜
(在开始之前调用)
 */
-(void)setFilter:(LanSongFilter *)filter;
/**
 设置滤镜
(在开始之前调用)
 */
-(void)setFilterWithStart:(LanSongFilter *)startFilter end:(LanSongFilter *)endFilter;



/**
在视频的指定时间范围内覆盖一张图片. 类似增加封面的效果.
 
 比如要增加封面. 则设置时间点为:0---1.0秒;
 注意:如果别的缩略图读取的
 @param image 图片对象
 @param start 开始时间, 单位秒
 @param end 结束时间, 单位秒;
 */
-(void)setCoverPicture:(UIImage *)image startTime:(CGFloat)start endTime:(CGFloat)end;
/**
 增加马赛克区域.
 
 马赛克的参考宽高是:
 如果裁剪了,则以裁剪的宽高; 没有裁剪,则视频的宽高; 视频的左上角XY是:0.0,0.0
 
 (可增加多个)
 */
-(void)addMosaicRect:(CGRect)rect;

/**
 增加音频
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;

/**
 增加音频
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @param isLoop 是否循环
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;


/**
 增加音频, 把音频的哪部分 增加到主视频的指定位置上;
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param start 开始
 @param pos  把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
 增加音频
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入-1
 @param pos 把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;

/**
 开始执行
  执行流程是: 先裁剪--->执行各种滤镜--->设置马赛克区域--->增加UI层-->缩放--->设置码率,编码;
 */
-(BOOL) start;

/**
 停止执行.停止后,不会调用completionBlock回调;
 */
-(void)stop;
/**
 *     执行过程中的进度对调, 返回的当前时间戳 单位是秒.
 
 注意:  内部是在其他队列中调用, 如需要在主队列中调用, 则需要增加一下代码.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^videoProgressBlock)(CGFloat currentFramePts,CGFloat percent);
/**
 结束回调.
 执行后返回结果.
 dispatch_async(dispatch_get_main_queue(), ^{
 .....CODEC....
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *video);
@end


/*
 举例如下:
 LSOVideoOneDo *videoOneDo;
 -(void)testVideoOneDo:(NSURL *)video
 {
 videoOneDo=[[LSOVideoOneDo alloc] initWithNSURL:video];
 
 //时长剪切
 videoOneDo.cutStartTimeS=3;
 videoOneDo.cutDurationTimeS=10;
 
 //画面裁剪
 [videoOneDo setCropRect:CGRectMake(0.0, 0.0, 540, 540)];
 
 //增加马赛克
 [videoOneDo addMosaicRect:CGRectMake(0.0, 0.0, 270, 270)];
 
 //增加一个View来叠加logo,文字等.
 [videoOneDo setUIView:[self createUIView]];
 
 [videoOneDo setCompletionBlock:^(NSString * _Nonnull video) {
 dispatch_async(dispatch_get_main_queue(), ^{
 [LanSongUtils startVideoPlayerVC:self.navigationController dstPath:video];
 });
 }];
 [videoOneDo setVideoProgressBlock:^(CGFloat progess,CGFloat percent) {
 LSOLog(@"进度是:%f, 百分比:%f",progess,percent);
 }];
 [videoOneDo start];
 }
 -(UIView *)createUIView
 {
 UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540,540)];
 rootView.backgroundColor = [UIColor clearColor];
 UIImage *image = [UIImage imageNamed:@"small"];
 UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
 imageView.center = CGPointMake(rootView.bounds.size.width/2, rootView.bounds.size.height/2);
 
 UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 120)];
 label.text=@"杭州蓝松科技";
 label.textColor=[UIColor redColor];
 [rootView addSubview:label];
 [rootView addSubview:imageView];
 return rootView;
 }
 
 */
