//
//  DrawPadAEPreview.h
//  LanSongEditorFramework
//
//  Created by sno on 2018/8/27.
//  Copyright © 2018 sno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSOVideoPen.h"
#import "LSOViewPen.h"
#import "LSOPen.h"
#import "LanSongView2.h"
#import "LSOBitmapPen.h"
#import "LSOMVPen.h"
#import "LSOAeView.h"

/**
 Ae模板的前台预览容器
 把Ae模板的各种素材, 按照顺序一层一层增加到容器中, 然后开始播放;
 */
@interface DrawPadAEPreview : NSObject


/**
 用initWithURL/initWithPath 增加的背景视频后, 得到的视频图层对象;
 */
@property (nonatomic)   LSOVideoPen *videoPen;
/**
 当前容器大小, 创建后,如果用 initWithURL/initWithPath 则等于视频本身的分辨率
 如果用init创建的,则等于第一个增加的json文件或MV的分辨率;
 */
@property (nonatomic,assign) CGSize drawpadSize;


/**
 初始化
 @param videoPath输入的视频路径
 */
-(id)initWithURL:(NSURL *)videoPath;

/**
 初始化
 @param videoPath 输入的视频路径
 @return
 */
-(id)initWithPath:(NSString *)videoPath;


/**
 不增加背景视频的初始化方法;
 容器大小,生成视频的帧率,时长等于第一个增加的AEJson 图层或 MV图层的分辨率;
 */
-(id)init;

/**
 增加预览的显示创建;
 @param view
 */
-(void)addLanSongView:(LanSongView2 *)view;



/**
 增加UI图层;
 
 @param view UI图层
 @param from  这个UI是否来自界面, 如果你已经self.view addSubView增加了这个view,则这里设置为YES;
 @return 返回对象
 */
-(LSOViewPen *)addViewPen:(UIView *)view isFromUI:(BOOL)from;


/**
 增加图片图层

 @param image 图片对象
 @return 返回图片图层对象
 */
-(LSOBitmapPen *)addBitmapPen:(UIImage *)image;


/**
 增加mv图层;
 
 各种透明的动画, 在我们SDK中, 认为是MV效果, 关于MV的 原理和制作步骤,请参考我们的指导文件.
 @param colorPath mv效果中的彩色视频路径
 @param maskPath mv效果中的黑白视频路径
 @return MV对象
 */
-(LSOMVPen *)addMVPen:(NSURL *)colorPath withMask:(NSURL *)maskPath;


/**
 增加Ae图层
 
 在start前增加
 */
-(LSOAeView *)addAEJsonPath:(NSString *)jsonPath;


/**
 交换两个图层的位置
 在开始前调用;
 @param first 第一个图层对象
 @param second 第二个图层对象
 */
-(BOOL)exchangePenPosition:(LSOPen *)first second:(LSOPen *)second;

/**
 设置图层的位置
 [在开始前调用]
 
 @param pen 图层对象
 @param index 位置, 最里层是0, 最外层是 getPenSize-1
 */
-(BOOL)setPenPosition:(LSOPen *)pen index:(int)index;

/**
 当前容器的总时长;
 */
@property CGFloat duration;


-(void)removePen:(LSOPen *)pen;

/**
 开始执行
 这个只是预览, 开始后,不会编码, 不会有完成回调
 @return 执行成功返回YES, 失败返回NO;
 */
-(BOOL)start;


/**
 开始执行,并实时录制;
 @return
 */
-(BOOL)startWithEncode;

/**
 取消
 */
-(void)cancel;

/**
 进度回调,
 当在编码的时候, 等于当前视频图层的视频播放进度 时间单位是秒;;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^progressBlock)(CGFloat progress);

//内部使用
-(void)setAeController:(NSMutableArray *)imageArray;

/**
 文字使用.
 */
@property(nonatomic, copy) void(^frameProgressBlock)(int frames);

/**
 编码完成回调, 完成后返回生成的视频路径;
 注意:生成的dstPath目标文件, 我们不会删除.如果你多次调用,就会生成多个视频文件;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);

/**
 当前是否在运行;
 */
@property (nonatomic,readonly) BOOL isRunning;

/**
 当前是否在录制
 */
@property (nonatomic,readonly) BOOL isRecording;


@property (nonatomic,readonly) int penCount;



/**
 设置Ae模板中的视频的音量大小.
 在需要增加其他声音前调用(addAudio后调用无效).
 不调用默认是原来的声音大小;
 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 设置为0, 则删除Ae模板中的音频;
 */
@property(readwrite, nonatomic) float aeAudioVolume;

/**
 增加音频图层, 在增加完图层后调用;
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume;

/**
 增加音频图层, 在增加完图层后调用;
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @param isLoop 是否循环
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio volume:(CGFloat)volume loop:(BOOL)isLoop;

/**
 增加音频图层, 在增加完图层后调用;
 把音频的哪部分 增加到主视频的指定位置上;
 可多次调用
 
 @param audio 音频路径.或带有音频的视频路径
 @param start 开始
 @param pos  把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量. 1.0 是原音量; 0.5是降低一倍. 2.0是提高一倍;
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start pos:(CGFloat)pos volume:(CGFloat)volume;
/**
 增加音频图层, 在增加完图层后调用;
 可多次调用
 @param audio 音频路径.或带有音频的视频路径
 @param start 音频的开始时间段
 @param end 音频的结束时间段 如果增加到结尾, 则可以输入-1
 @param pos 把这个音频 增加到 主音频的那个位置,比如从5秒钟开始增加这个音频
 @param volume 混合时的音量
 @return 增加成功,返回YES, 失败返回NO;
 */
-(BOOL)addAudio:(NSURL *)audio start:(CGFloat)start end:(CGFloat)end pos:(CGFloat)pos volume:(CGFloat)volume;
@end
