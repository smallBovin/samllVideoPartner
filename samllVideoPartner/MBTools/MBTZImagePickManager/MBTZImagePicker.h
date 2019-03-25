//
//  MBTZImagePicker.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/11.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MBTZImagePickType) {
    MBTZImagePickTypeImage, //只能选择图片
    MBTZImagePickTypeVideo, //只能选择视频
    MBTZImagePickTypeAll,   //可以选择图片与视频
};

@protocol MBTZImagePickerDelegate <NSObject>

@optional

- (void)didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;

- (void)didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset;

/** 自定义的视频剪辑后的视频源*/
- (void)didFinishPickingVideo:(UIImage *)coverImage cropVideo:(NSURL *)cropUrl;

@end


@interface MBTZImagePicker : NSObject

SINGLETON_INTERFACE(Instance)

/** 代理*/
@property (nonatomic, weak) id<MBTZImagePickerDelegate> delegate;

- (void)getLocalAlbumWithType:(MBTZImagePickType)type isAutoDismiss:(BOOL)isAutoDissmiss isNeedCrop:(BOOL)isNeedCrop parentController:(UIViewController *)parentVC delegate:(id<MBTZImagePickerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
