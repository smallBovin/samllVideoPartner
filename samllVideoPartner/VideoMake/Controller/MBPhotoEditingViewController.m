//
//  MBPhotoEditingViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/9.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBPhotoEditingViewController.h"
#import "PECropView.h"

@interface MBPhotoEditingViewController ()

/** 图片编辑*/
@property (nonatomic, strong) PECropView *cropView;
/** 取消按钮*/
@property (nonatomic, strong) UIButton * cancelBtn;
/** 确定按钮*/
@property (nonatomic, strong) UIButton * sureBtn;

@end

@implementation MBPhotoEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    self.fd_prefersNavigationBarHidden = YES;
    
    [self.view addSubview:self.cropView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.sureBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kAdapt(23));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kAdapt(15));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-kAdapt(23));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kAdapt(15));
    }];
}
- (void)setModel:(TZAssetModel *)model {
    _model = model;
    [[TZImageManager manager]getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self.cropView.image = photo;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.cropView resetCropRectAnimated:YES];
            [self.cropView setCropAspectRatio:9/16.0];
        });
    }];
}


#pragma mark---action
- (void)cancelPhotoEditing {
    if ([self.navigationController isKindOfClass: [TZImagePickerController class]]) {
        TZImagePickerController *nav = (TZImagePickerController *)self.navigationController;
        if (nav.imagePickerControllerDidCancelHandle) {
            nav.imagePickerControllerDidCancelHandle();
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureChooseEditedPhoto {
    if (self.doneButtonClickBlockCropMode) {
        self.doneButtonClickBlockCropMode(self.cropView.croppedImage, self.model.asset);
    }
}
#pragma mark--lazy--
/** 图片编辑器*/
- (PECropView *)cropView {
    if (!_cropView) {
        _cropView = [[PECropView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kAdapt(40))];
        _cropView.backgroundColor = [UIColor blackColor];
    }
    return _cropView;
}
/** 取消*/
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn addTarget:self action:@selector(cancelPhotoEditing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
/** 确定*/
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_sureBtn addTarget:self action:@selector(sureChooseEditedPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end
