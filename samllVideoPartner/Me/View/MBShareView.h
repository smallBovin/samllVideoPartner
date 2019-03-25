//
//  MBShareView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/3.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 传递参数key*/
UIKIT_EXTERN NSString *const MBSharePlatformIcon;
UIKIT_EXTERN NSString *const MBSharePlatformName;

typedef NS_ENUM(NSUInteger, MBSharePlatformType) {
    MBSharePlatformTypeWechat,          //微信
    MBSharePlatformTypeWechatTimeline,  //朋友圈
    MBSharePlatformTypeQQ,              //QQ
};

typedef void(^MBSharePlatformBlock)(MBSharePlatformType platformType);

typedef void(^MBShareViewCancelBlock)(void);

@interface MBShareView : UIView

+ (instancetype)shareViewFrame:(CGRect)frame platformArrays:(NSArray<NSDictionary *> *)platforms;
/** 取消*/
@property (nonatomic, copy) MBShareViewCancelBlock  cancelBlock;
/** 分享点击事件*/
@property (nonatomic, copy) MBSharePlatformBlock  shareBlock;
@end

NS_ASSUME_NONNULL_END
