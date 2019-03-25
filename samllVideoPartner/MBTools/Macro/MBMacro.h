//
//  MBMacro.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#ifndef MBMacro_h
#define MBMacro_h

// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IsIphoneXSeries ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad||CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad||CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad) : NO)

/**主屏幕的物理尺寸*/
#define kMainScreenBounds      [UIScreen mainScreen].bounds
/**主屏幕的物理宽度*/
#define kMainScreenWidth       [UIScreen mainScreen].bounds.size.width
/**主屏幕的物理高度*/
#define kMainScreenHeight      [UIScreen mainScreen].bounds.size.height

#define SCREEN_WIDTH            MIN(kMainScreenWidth, kMainScreenHeight)

#define SCREEN_HEIGHT           MAX(kMainScreenWidth, kMainScreenHeight)

#define STATUS_BAR_HEIGHT       (IsIphoneXSeries ?44.0:20.0)

#define NAVIGATION_BAR_HEIGHT   (IsIphoneXSeries ?88.0:64.0)

#define TAB_BAR_HEIGHT          (IsIphoneXSeries ?83.0:49.0)

#define SAFE_INDICATOR_BAR      (IsIphoneXSeries ?34.0:0.0)

#define kAdapt(x)              (x)*(SCREEN_WIDTH/375.0)

#define kAPIVersion11Later     @available(iOS 11.0, *)

//随机色
#define kRGBRandomColor     kRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define kRGBColor(R,G,B)    [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]

#define kRGBaColor(R,G,B,a) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:a]


//**根据输出进行调试
//#ifdef DEBUG
//#   define NSLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#   define NSLog(...)
//#endif

#define NSFoundationLog    NSLog(@"%s",__func__);

#define LOCK    dispatch_semaphore_t sem = dispatch_semaphore_create(1);\
dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);

#define UNLOCK  dispatch_semaphore_signal(sem);


#define SINGLETON_INTERFACE(MethodName)  + (instancetype)share##MethodName;

#define SINGLETON_IMPLEMENT(MethodName)    static id _instance = nil;\
\
+ (instancetype)share##MethodName {  \
    static dispatch_once_t onceToken;   \
    dispatch_once(&onceToken, ^{    \
        _instance = [[self alloc]init]; \
    }); \
    return _instance;   \
}   \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {  \
    static dispatch_once_t onceToken;   \
    dispatch_once(&onceToken, ^{    \
        _instance = [super allocWithZone:zone];  \
    }); \
    return _instance;   \
}   \
- (id)copyWithZone:(NSZone *)zone { \
    return _instance;   \
}\


#endif /* MBMacro_h */
