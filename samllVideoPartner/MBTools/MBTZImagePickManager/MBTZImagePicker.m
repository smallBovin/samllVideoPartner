//
//  MBTZImagePicker.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/11.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBTZImagePicker.h"

@interface MBTZImagePicker ()<TZImagePickerControllerDelegate>

/** 手动取消*/
@property (nonatomic, assign) BOOL  isNeedDissmissByUser;

/** */
@property (nonatomic, weak) TZImagePickerController * weakPicker;

@end

@implementation MBTZImagePicker

SINGLETON_IMPLEMENT(Instance)

- (void)getLocalAlbumWithType:(MBTZImagePickType)type isAutoDismiss:(BOOL)isAutoDissmiss isNeedCrop:(BOOL)isNeedCrop parentController:(nonnull UIViewController *)parentVC delegate:(nonnull id<MBTZImagePickerDelegate>)delegate {
    self.delegate = delegate;
    //MaxImagesCount  可以选着的最大条目数
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    self.weakPicker = imagePicker;
    // 是否显示可选原图按钮
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.autoDismiss = isAutoDissmiss;
    self.isNeedDissmissByUser = !isAutoDissmiss;
    if (type == MBTZImagePickTypeVideo) {
        // 是否允许显示视频
        imagePicker.allowPickingVideo = YES;
        // 是否允许显示图片
        imagePicker.allowPickingImage = NO;
    }else if (type == MBTZImagePickTypeImage) {
        // 是否允许显示视频
        imagePicker.allowPickingVideo = NO;
        // 是否允许显示图片
        imagePicker.allowPickingImage = YES;
    }else {
        // 是否允许显示视频
        imagePicker.allowPickingVideo = YES;
        // 是否允许显示图片
        imagePicker.allowPickingImage = YES;
    }
    imagePicker.allowTakeVideo = NO;
    imagePicker.allowTakePicture = NO;
    if (isNeedCrop) {
        imagePicker.allowPreview = YES;
    }else {
        imagePicker.allowPreview = NO;
    }
    
    imagePicker.navLeftBarButtonSettingBlock = ^(UIButton *leftButton) {
        leftButton = nil;
    };
    imagePicker.uiImagePickerControllerSettingBlock = ^(UIImagePickerController *imagePickerController) {
        imagePickerController.interactivePopGestureRecognizer.enabled = NO;
    };
    // 这是一个navigation 只能present
    [parentVC presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark--TZImagePickerControllerDelegate---
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [self.delegate didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto];
        if (self.isNeedDissmissByUser) {
            [self.weakPicker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage cropVideo:(NSURL *)cropUrl {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingVideo:cropVideo:)]) {
        [self.delegate didFinishPickingVideo:coverImage cropVideo:cropUrl];
    }
    if (self.isNeedDissmissByUser) {
        [self.weakPicker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingVideo:sourceAssets:)]) {
        [self.delegate didFinishPickingVideo:coverImage sourceAssets:asset];
    }
    if (self.isNeedDissmissByUser) {
        [self.weakPicker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    if (self.isNeedDissmissByUser) {
        [self.weakPicker dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
