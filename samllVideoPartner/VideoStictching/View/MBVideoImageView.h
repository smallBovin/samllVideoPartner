//
//  MBVideoImageView.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBUploadDataType) {
    MBUploadDataTypeNone,   //没有上传
    MBUploadDataTypeImage,  //上传图片
    MBUploadDataTypeVideo,  //上传视频
};

@interface MBVideoImageView : UIView

/** 父控制器*/
@property (nonatomic, weak) UIViewController * superVC;

/** 上传文件的类型*/
@property (nonatomic, assign) MBUploadDataType  uploadType;

/** 视频路径*/
@property (nonatomic, copy ,readonly) NSURL * uploadVideoURL;

/** 上传的图片*/
@property (nonatomic, copy ,readonly) UIImage * uploadImage;
/** 展示的时长*/
@property (nonatomic, assign) float  duration;

@end

NS_ASSUME_NONNULL_END
