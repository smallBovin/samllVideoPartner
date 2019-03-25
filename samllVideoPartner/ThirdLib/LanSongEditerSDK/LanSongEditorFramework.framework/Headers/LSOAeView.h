//
//  LSOAnimationView
//
//  Created by Brandon Withrow on 12/14/15.
//  Copyright © 2015 Brandon Withrow. All rights reserved.
//  Dream Big.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSOKeypath.h"
//#import "LSOValueDelegate.h"  //LSTODO
#import "LSOAeText.h"
#import "LSOAeImage.h"
#import "LSOAeImageLayer.h"
#import "LSOAEVideoSetting.h"




typedef void (^LSOAnimationCompletionBlock)(BOOL animationFinished);

@interface LSOAeView : UIView

+(void)setGLanSongForcePrecomWidth:(CGFloat)w;
+(void)setGLanSongForcePrecomHeight:(CGFloat)h;
+(void)setLanSongAEWorkForPreview:(BOOL)is;
/**
 但输入的图片和 json中的图片宽高不同时,是否要强制等于输入图片的宽高;
 */
+(void)setGLanSongForceAdjustLayerSize:(BOOL)is;


/**
 从指定位置 增加动画文件json;
 从main bundle中找images文件夹;
 @param filePath json完整路径
 @return return value description
 */
+ (nonnull instancetype)animationWithFilePath:(nonnull NSString *)filePath NS_SWIFT_NAME(init(filePath:));

- (nonnull instancetype)initWithContentsOfURL:(nonnull NSURL *)url;

@property (nonatomic, strong) IBInspectable NSString * _Nullable animation;

- (void)setAnimationNamed:(nonnull NSString *)animationName NS_SWIFT_NAME(setAnimation(named:));

@property (nonatomic, readonly) BOOL isAnimationPlaying;

@property (nonatomic, assign) BOOL loopAnimation;

@property (nonatomic, assign) BOOL autoReverseAnimation;

/// Sets a progress from 0 - 1 of the animation. If the animation is playing it will stop and the completion block will be called.
/// The current progress of the animation in absolute time.
/// e.g. a value of 0.75 always represents the same point in the animation, regardless of positive
/// or negative speed.
@property (nonatomic, assign) CGFloat animationProgress;

@property (nonatomic, assign) CGFloat animationSpeed;

@property (nonatomic, readonly) CGFloat animationDuration;

@property (nonatomic, assign) BOOL cacheEnable;

@property (nonatomic, copy, nullable) LSOAnimationCompletionBlock completionBlock;



@property (nonatomic, assign) BOOL shouldRasterizeWhenIdle;


@property (nonatomic) CGFloat jsonWidth;
@property (nonatomic) CGFloat jsonHeight;

@property (nonatomic) CGFloat jsonFrameRate;//帧率
@property (nonatomic) int totalFrames;//总帧数.
@property (nonatomic) CGFloat jsonDuration; //总时长 =(结束帧数 - 开始帧数)/帧率; 单位秒;两位有效小数;
/**
 拿到json中所有图片的信息, 一个LSOAeImage对象数组;
 
 比如打印出来:
     for(LSOAeImage *info in aeView.imageInfoArray){
         LSOLog(@"id:%@, width:%d %d, ame:%@",info.imgId,info.imgWidth,info.imgHeight,info.imgName);
     }
 */
@property (nonatomic) NSMutableArray *imageInfoArray;


/**
 拿到json中所有文本图层的文本信息,
 获取到的是 LSOAeText对象;
 用
     for (LSOAeText *tex in ret.textInfoArray) {
        NSLog(@"text is :%@", tex.textContents);
     }
 */
@property (nonatomic) NSMutableArray *textInfoArray;



/**
 当前json中所有图片图层的信息;
  获取到的是 LSOAeImageLayer对象;
 里面放了一个LSOXLayerContainer对象;
 比如;
 for (LSOAeImageLayer *layer in view.imageLayerArray) {
 LSOLog(@"id:%@,width:%d,height:%d,start frame:%d, end frame:%d",layer.imgName,layer.imgWidth,layer.imgHeight,layer.startFrame,layer.endFrame);
 }
 */
@property (nonatomic) NSMutableArray *imageLayerArray;


/**
不再使用.
 */
- (void)updateImage:(NSString *)assetID image:(UIImage*)image;
/**
 在开始执行前调用, 替换指定key的图片

 @param key "json中的图片ID号, image_0 image_1等;
 @param image 图片对象
 @return 替换成功返回YES
 */
-(BOOL)updateImageWithKey:(NSString*)key image:(UIImage *)image;


/**
 替换图片
 json中的每个图片有一个唯一的ID, 根据id来替换指定json中的图片.

 @param key "json中的图片ID号, image_0 image_1等;
 @param image 图片对象
 @param needCrop 如果替换的图片和json的图片宽高不一致,是否SDK内部裁剪(内部是居中裁剪);
 @return 替换成功返回YES
 */
-(BOOL)updateImageWithKey:(NSString*)key image:(UIImage *)image needCrop:(BOOL)needCrop;

/**
 替换指定图片的视频;
 @param key json中的图片ID号, image_0 image_1等;
 @param url 视频文件路径
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageWithKey:(NSString*)key url:(NSURL *)url;


/**
 替换指定图片中的视频

 @param key json中的图片ID号, image_0 image_1等;
 @param url 视频文件路径
 @param setting 视频文件在处理中的选项设置;
 @return 可以替换返回YES;
 */
-(BOOL)updateVideoImageWithKey:(NSString*)key url:(NSURL *)url setting:(LSOAEVideoSetting *)setting;

/**
 当设置updateVideoImageWithKey后, 你可以通过这个来调整视频中每一帧;

 @param key json中的refId, image_0 image_1等, 给哪个id设置回调
 @param frameUpdateBlock 视频每更新一帧, 会直接执行这里的回调, 注意回调返回的是UIImage * 类型
 @return 可以设置返回YES
 */
- (BOOL)setVideoImageFrameBlock:(NSString *)key updateblock:(UIImage *(^)(NSString *imgId,CGFloat framePts,UIImage *image))frameUpdateBlock;


/**
 更新文字, 用图层的名字来更新;

 @param layerName 图层名字
 @param newText 新的文字;
 @return 更新成功返回YES
 */
- (BOOL) updateTextWithLayerName:(NSString *)layerName newText:(NSString *)newText;
/**
 更新文本
 @param textText: json中的文字; 可以用textInfoArray获得;
 @param newText: 新的文字
 @return 更新成功返回YES;
 */
- (BOOL) updateTextWithOldText:(NSString *)text newText:(NSString *)newText;


/**
 设置文本的字体库;
 
 @param text json中的文字; 可以用textInfoArray获得;
 @param font 在包中的字体;
 @return
 */
- (BOOL) updateFontWithText:(NSString *)text font:(NSString *)font;


/**********************************以下不要使用********************************************************************/
- (void)playToProgress:(CGFloat)toProgress
        withCompletion:(nullable LSOAnimationCompletionBlock)completion;

- (void)playFromProgress:(CGFloat)fromStartProgress
              toProgress:(CGFloat)toEndProgress
          withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playToFrame:(nonnull NSNumber *)toFrame
     withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playFromFrame:(nonnull NSNumber *)fromStartFrame
              toFrame:(nonnull NSNumber *)toEndFrame
       withCompletion:(nullable LSOAnimationCompletionBlock)completion;
- (void)playWithCompletion:(nullable LSOAnimationCompletionBlock)completion;

- (void)play;
- (void)pause;
- (void)stop;
- (void)setProgressWithFrame:(nonnull NSNumber *)currentFrame;
- (void)forceDrawingUpdate;
- (void)logHierarchyKeypaths;
//- (void)setValueDelegate:(id<LSOValueDelegate> _Nonnull)delegates
//              forKeypath:(LSOKeypath * _Nonnull)keypath;
- (nullable NSArray *)keysForKeyPath:(nonnull LSOKeypath *)keypath;
- (CGPoint)convertPoint:(CGPoint)point
         toKeypathLayer:(nonnull LSOKeypath *)keypath;
- (CGRect)convertRect:(CGRect)rect  toKeypathLayer:(nonnull LSOKeypath *)keypath;
- (CGPoint)convertPoint:(CGPoint)point fromKeypathLayer:(nonnull LSOKeypath *)keypath;
- (CGRect)convertRect:(CGRect)rect fromKeypathLayer:(nonnull LSOKeypath *)keypath;

- (void)addSubview:(nonnull UIView *)view toKeypathLayer:(nonnull LSOKeypath *)keypath;
- (void)addSubLayer:(nonnull CALayer *)layer;
- (void)maskSubview:(nonnull UIView *)view toKeypathLayer:(nonnull LSOKeypath *)keypath;

#if !TARGET_OS_IPHONE && !TARGET_OS_SIMULATOR
@property (nonatomic) LSOViewContentMode contentMode;
#endif

- (void)setValue:(nonnull id)value forKeypath:(nonnull NSString *)keypath atFrame:(nullable NSNumber *)frame __deprecated;

- (void)addSubview:(nonnull UIView *)view toLayerNamed:(nonnull NSString *)layer
    applyTransform:(BOOL)applyTransform __deprecated;

- (CGRect)convertRect:(CGRect)rect toLayerNamed:(NSString *_Nullable)layerName __deprecated;
+ (nonnull instancetype)animationFromJSON:(nullable NSDictionary *)animationJSON inBundle:(nullable NSBundle *)bundle NS_SWIFT_NAME(init(json:bundle:));
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName NS_SWIFT_NAME(init(name:));
+ (nonnull instancetype)animationNamed:(nonnull NSString *)animationName inBundle:(nonnull NSBundle *)bundle NS_SWIFT_NAME(init(name:bundle:));
+ (nonnull instancetype)animationFromJSON:(nonnull NSDictionary *)animationJSON NS_SWIFT_NAME(init(json:));
@end
