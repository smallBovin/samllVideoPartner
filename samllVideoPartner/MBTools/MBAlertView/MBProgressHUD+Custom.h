//
//  MBProgressHUD+Custom.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Custom)
/** ======== 仅文字提示弹框===========*/
/**
 纯文字的提示，默认1.5秒隐藏

 @param message 提示的文字
 @return 返回弹框对象可自定义属性
 */
+ (instancetype)showOnlyTextMessage:(NSString *)message;

/**
 纯文字的提示，可自定义隐藏的时间

 @param message 提示文字
 @param afterDalay 多少秒后隐藏
 @return 返回弹框对象可自定义属性
 */
+ (instancetype)showOnlyTextMessage:(NSString *)message afterDalay:(NSTimeInterval)afterDalay;

/**====== 带有静态图片和提示文字的提示框====*/

/**
 返回静态图片与文字的弹框，默认1.5后隐藏

 @param image 静态图片
 @param message 文字提示内容
 @return 返回弹框的对象
 */
+ (instancetype)showIconImage:(UIImage *)image message:(NSString *)message;

/**
 返回静态图片与文字的弹框
 
 @param image 静态图片
 @param message 文字提示内容
 @param afterDalay 多少秒后隐藏
 @return 返回弹框的对象
 */
+ (instancetype)showIconImage:(UIImage *)image message:(NSString *)message afterDalay:(NSTimeInterval)afterDalay;

/**
 返回自定义view与文字的弹框

 @param customView 自定义的view
 @param message 文字提示内容
 @param view 弹框添加到父视图view
 @param afterDalay 多少秒后隐藏
 @return 返回弹框的对象
 */
+ (instancetype)showCustomView:(UIView *)customView message:(NSString *)message toView:(nullable UIView *)view afterDalay:(NSTimeInterval)afterDalay;

+ (instancetype)showUploadOrDownloadProgress:(CGFloat)pregress;

/** 加载菊花带文字*/
+ (instancetype)showLoadingWithMessage:(nullable NSString *)message;

/** 加载进度显示*/
+ (instancetype)showLoadingProgress;

+ (void)hideLoadingHUD;

/** 语音识别的动画*/
+ (instancetype)recogniseAnimationGif;


/** 下载成功，支付成功，清除缓存成功*/
+ (void)showSuccessAlertWithIcon:(NSString *)imageName message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END

@interface MBProgressCustomView : UIView

@end

@interface MBRecognizeGifView : UIView

@end
