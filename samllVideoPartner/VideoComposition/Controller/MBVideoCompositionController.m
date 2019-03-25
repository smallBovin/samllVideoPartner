//
//  MBVideoCompositionController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBVideoCompositionController.h"
/** 背景库*/
#import "MBBackgroundThemeController.h"

/****==== 审核状态使用===*/
/** 微信授权登录界面*/
#import "MBWechatLoginView.h"
/** 微信授权登录管理类*/
#import "MBWechatApiManager.h"
/** 绑定手机界面*/
#import "MBBindingMobileViewController.h"
/** 网页加载界面*/
#import "MBProtocolWebViewController.h"

typedef NS_ENUM(NSUInteger, MBVideoPosition) {
    MBVideoPositionTop,
    MBVideoPositionCenter,
    MBVideoPositionBottom,
};

@interface MBVideoCompositionController ()<MBTZImagePickerDelegate>

/** 视频放置的位置*/
@property (nonatomic, strong) UILabel * postionLabel;
/** 左侧按钮*/
@property (nonatomic, strong) UIButton * leftBtn;
/** 中间按钮*/
@property (nonatomic, strong) UIButton * centerBtn;
/** 右侧按钮*/
@property (nonatomic, strong) UIButton * rightBtn;
/** 要合成到视频中的图片*/
@property (nonatomic, strong) UIImageView * bgImageView;
/** 视频层*/
@property (nonatomic, strong) UIImageView * videoContainer;
/** 上传视频按钮*/
@property (nonatomic, strong) UIButton * uploadBtn;
/** 背景库*/
@property (nonatomic, strong) UIButton * bgStoreBtn;
/** 本地上传*/
@property (nonatomic, strong) UIButton * localUploadBtn;
/** 本地上传*/
@property (nonatomic, strong) UIButton * saveBtn;

/** 视频播放器*/
@property (nonatomic, strong) AVPlayerItem      *playItem;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;
@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, strong) NSURL *videoUrl;


/** ae 容器*/
@property (nonatomic, strong) DrawPadVideoExecute * videoExecute;
/** 背景图*/
@property (nonatomic, strong) LSOBitmapPen * imagePen;
/** 播放图*/
@property (nonatomic, strong) LSOVideoPen2 * videoLayer;
/** 蓝松转码*/
@property (nonatomic, strong) LSOEditMode *editor;
/** 展示层*/
@property (nonatomic, strong) UIImage *bgImage;
/** 播放层位置*/
@property (nonatomic, assign) MBVideoPosition videoPosition;
/** 合成的进图提示*/
@property (nonatomic, strong) MBProgressHUD * comprissionHud;

@end

@implementation MBVideoCompositionController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    self.editor = nil;
    self.videoExecute = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频拼接";
    
    [self setupSubviews];
    
}
- (void)exportCompositionVideoInBackgroundWithUrl:(NSURL *)url {
    LSOMediaInfo *info = [[LSOMediaInfo alloc]initWithURL:url];
    if ([info prepare]) {
        [self compossionWithUrl:url];
    }else {
        __weak typeof(self) weakSelf = self;
        self.editor=[[LSOEditMode alloc] initWithURL:url];
        [self.editor setProgressBlock:^(CGFloat progess) {
           
        }];
        [self.editor setCompletionBlock:^(NSString * _Nonnull dstPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LSOMediaInfo *new = [[LSOMediaInfo alloc]initWithURL:[NSURL fileURLWithPath:dstPath]];
                if ([new prepare]) {
                    [weakSelf compossionWithUrl:[NSURL fileURLWithPath:dstPath]];
                }
            });
        }];
        
        [self.editor startImport];
    }
}

- (void)compossionWithUrl:(NSURL *)url {
    self.videoExecute = [[DrawPadVideoExecute alloc]initWithURL:url drawPadSize:CGSizeMake(540, 960)];
    self.imagePen = [self.videoExecute addBitmapPen:[UIImage scaleImage:self.bgImage toSize:CGSizeMake(540, 960)]];
    [self.videoExecute setPenPosition:self.imagePen index:0];
    
    self.videoLayer = self.videoExecute.videoPen;
  
    if (self.videoLayer.mediaInfo.getWidth>self.videoLayer.mediaInfo.getHeight)  { //横屏视频
        if (self.videoPosition == MBVideoPositionTop) {
            self.videoLayer.positionX = self.videoExecute.drawpadSize.width/2;
            self.videoLayer.positionY = self.videoLayer.mediaInfo.getHeight*540/self.videoLayer.mediaInfo.getWidth/2;
        }else if (self.videoPosition == MBVideoPositionBottom){
            self.videoLayer.positionX = self.videoExecute.drawpadSize.width/2;
            self.videoLayer.positionY =self.videoExecute.drawpadSize.height-self.videoLayer.mediaInfo.getHeight*540/self.videoLayer.mediaInfo.getWidth/2;
        }else {
            self.videoLayer.positionX = self.videoExecute.drawpadSize.width/2;
            self.videoLayer.positionY = self.videoExecute.drawpadSize.height/2;
        }
    }else {
        
        self.videoLayer.scaleWH = 0.5;
        if (self.videoPosition == MBVideoPositionTop) {
            self.videoLayer.positionX = self.videoExecute.drawpadSize.width/2;
            self.videoLayer.positionY = self.videoLayer.mediaInfo.getHeight*(540/self.videoLayer.mediaInfo.getWidth)*0.5/2;
        }else if (self.videoPosition == MBVideoPositionBottom){
            self.videoLayer.positionX = self.videoExecute.drawpadSize.width/2;
            self.videoLayer.positionY = self.videoExecute.drawpadSize.height-(self.videoLayer.mediaInfo.getHeight*(540/self.videoLayer.mediaInfo.getWidth)*0.5/2);
        }else {
            self.videoLayer.positionX = self.videoExecute.drawpadSize.width/2;
            self.videoLayer.positionY = self.videoExecute.drawpadSize.height/2;
        }
    }
    
    
    //开始执行
    __weak typeof(self) weakSelf = self;
    [self.videoExecute setProgressBlock:^(CGFloat progess) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadProgress:progess];
        });
    }];
    
    [self.videoExecute setCompletionBlock:^(NSString *dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf drawpadCompleted:dstPath];
        });
    }];
    [self.videoExecute start];
}

-(void)drawpadProgress:(CGFloat) progress
{
    NSLog(@"视频的合成进度 %f",progress);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.comprissionHud) {
            self.comprissionHud = [MBProgressHUD showUploadOrDownloadProgress:0];
        }
        self.comprissionHud.progress = progress/100.0;
        self.comprissionHud.label.text = @"正在导出视频";
        if (progress >= 100) {
            self.comprissionHud.label.text = @"导出视频完成";
            [self.comprissionHud hideAnimated:YES];
            self.comprissionHud = nil;
        }
    });
    
}
-(void)drawpadCompleted:(NSString *)path
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:path] completionBlock:^(NSURL *assetURL, NSError *error) {
        [MBProgressHUD hideLoadingHUD];
        [MBProgressHUD showOnlyTextMessage:@"视频已保存到相册"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}

- (void)setupSubviews {
    [self.view addSubview:self.postionLabel];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.centerBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.videoContainer];
    [self.bgImageView addSubview:self.uploadBtn];
    [self.view addSubview:self.bgStoreBtn];
    [self.view addSubview:self.localUploadBtn];
    [self.view addSubview:self.saveBtn];
    [self.postionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kAdapt(39));
        make.top.equalTo(self.view.mas_top).offset(kAdapt(15)+NAVIGATION_BAR_HEIGHT);
    }];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postionLabel.mas_left);
        make.top.equalTo(self.postionLabel.mas_bottom).offset(kAdapt(5));
        make.height.mas_equalTo(kAdapt(30));
        make.width.mas_equalTo(kAdapt(60));
    }];
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.leftBtn.mas_centerY);
        make.height.equalTo(self.leftBtn.mas_height);
        make.width.mas_equalTo(kAdapt(60));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-kAdapt(37));
        make.centerY.equalTo(self.leftBtn.mas_centerY);
        make.height.equalTo(self.leftBtn.mas_height);
        make.width.mas_equalTo(kAdapt(60));
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.leftBtn.mas_bottom).offset(kAdapt(5));
        make.width.mas_equalTo(kAdapt(393)*540/960);
        make.height.mas_equalTo(kAdapt(393));
    }];
    [self.videoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgImageView);
        make.height.mas_equalTo(200);
    }];
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.width.height.equalTo(self.bgImageView);
    }];
    [self.bgStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(kAdapt(15));
        make.left.equalTo(self.bgImageView.mas_left);
        make.width.mas_equalTo(kAdapt(60));
        make.height.mas_equalTo(kAdapt(50));
    }];
    [self.localUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(kAdapt(15));
        make.left.equalTo(self.bgStoreBtn.mas_right).offset(kAdapt(10));
        make.width.mas_equalTo(kAdapt(60));
        make.height.mas_equalTo(kAdapt(50));
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kAdapt(15)-SAFE_INDICATOR_BAR);
        make.width.mas_equalTo(kAdapt(126));
        make.height.mas_equalTo(kAdapt(36));
    }];
}

#pragma mark--action---
- (void)videoLayerPosition:(UIButton *)sender {
    if (self.leftBtn == sender) {
        self.leftBtn.selected = YES;
        self.centerBtn.selected = NO;
        self.rightBtn.selected = NO;
        self.videoPosition = MBVideoPositionTop;
        [self.videoContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.bgImageView);
            make.height.mas_equalTo(200);
        }];
    }else if (self.centerBtn == sender) {
        self.leftBtn.selected = NO;
        self.centerBtn.selected = YES;
        self.rightBtn.selected = NO;
        self.videoPosition = MBVideoPositionCenter;
        [self.videoContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgImageView);
            make.height.mas_equalTo(200);
            make.centerY.equalTo(self.bgImageView.mas_centerY);
        }];
    }else {
        self.leftBtn.selected = NO;
        self.centerBtn.selected = NO;
        self.rightBtn.selected = YES;
        self.videoPosition = MBVideoPositionBottom;
        [self.videoContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgImageView);
            make.height.mas_equalTo(200);
            make.bottom.equalTo(self.bgImageView.mas_bottom);
        }];
    }
}
/** 本地视频上传*/
- (void)uploadLocalVideo {
    [[MBTZImagePicker shareInstance]getLocalAlbumWithType:MBTZImagePickTypeVideo isAutoDismiss:YES isNeedCrop:YES parentController:self delegate:self];
}
/** 图片库选择*/
- (void)selectBgImageViewOnStore {
    LOCK
    if (![[MBUserManager manager]isLogin]) { //审核状态
        [self showWechatAuthoLoginAlert];
    }else {
        MBBackgroundThemeController *themeVC = [MBBackgroundThemeController new];
        __weak typeof(self) weakSelf = self;
        themeVC.bgCompleteAction = ^(UIImage * _Nonnull image) {
            weakSelf.bgImageView.image = image;
            weakSelf.bgImage = image;
        };
        [self.navigationController pushViewController:themeVC animated:YES];
    }
    UNLOCK
}
/** 本地相册上传照片*/
- (void)uploadLocalImage {
    [[MBTZImagePicker shareInstance]getLocalAlbumWithType:MBTZImagePickTypeImage isAutoDismiss:YES isNeedCrop:YES parentController:self delegate:self];
}
/** 保存合成*/
- (void)saveStictchingVideoToLocal {
    if (!self.videoUrl) {
        [MBProgressHUD showOnlyTextMessage:@"请导入要合成的视频文件"];
        return;
    }
    if (!self.bgImage) {
        [MBProgressHUD showOnlyTextMessage:@"请设置背景图片"];
        return;
    }
    
    [self exportCompositionVideoInBackgroundWithUrl:self.videoUrl];
}

#pragma mark--TZImagePickerControllerDelegate---
- (void)didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSLog(@"选择完成");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bgImageView.image = [photos firstObject];
        self.bgImage = [photos firstObject];
    });
}

- (void)didFinishPickingVideo:(UIImage *)coverImage cropVideo:(NSURL *)cropUrl {
    self.uploadBtn.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoContainer.image = coverImage;
        self.videoUrl = cropUrl;
    });
}

#pragma mark--微信授权登录弹框---
- (void)showWechatAuthoLoginAlert {
    @autoreleasepool {
        MBWechatLoginView *loginView = [[MBWechatLoginView alloc]initWithFrame:CGRectMake(0, 0, kAdapt(290), kAdapt(180))];
        TYAlertController *alert = [TYAlertController alertControllerWithAlertView:loginView preferredStyle:TYAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        __weak typeof(alert) weakAlert = alert; //防止循环引用
        loginView.closeAction = ^{
            [weakAlert dismissViewControllerAnimated:YES];
        };
        loginView.loginAction = ^{
            [weakAlert dismissViewControllerAnimated:YES];
            [weakSelf wechatAuthLoginHandler];
        };
        loginView.protocolAction = ^{   //用户协议
            [weakSelf skitToSeeUserProtocolWithUrl:USER_PROTOCOL alertController:weakAlert];
        };
        loginView.privacyAction = ^{    //隐私政策
            [weakSelf skitToSeeUserProtocolWithUrl:USER_PRIVACY_PROTOCOL alertController:weakAlert];
        };
        alert.view.backgroundColor = [UIColor colorWithHexString:@"#343434" alpha:0.6];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//跳转到用户协议
- (void)skitToSeeUserProtocolWithUrl:(NSString *)url alertController:(TYAlertController *)alert {
    LOCK
    [alert dismissViewControllerAnimated:YES];
    MBProtocolWebViewController *webVC = [MBProtocolWebViewController new];
    [webVC loadUrl:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webVC animated:YES];
    UNLOCK
}

#pragma mark--微信授权登录处理---
- (void)wechatAuthLoginHandler {
    LOCK
    [[MBWechatApiManager shareManager]sendAuthRequestWithController:self delegate:self];
    UNLOCK
}
#pragma mark--MBWechatApiManagerDelegate---
/** 微信授权登录接口*/
- (void)weChatAuthSuccessWithCode:(NSString *)code {
    //根据code到后台请求用户信息接口
    NSLog(@"success code %@ ",code);
    [[MBUserManager manager]WechatAuthLoginWithCode:code complement:^(BOOL isNeedBind) {
        if (isNeedBind) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LOCK
                MBBindingMobileViewController *bindVC = [MBBindingMobileViewController new];
                [self.navigationController pushViewController:bindVC animated:YES];
                UNLOCK
            });
        }
    }];
}
- (void)cancelWechatAuth {
    [MBProgressHUD showOnlyTextMessage:@"取消授权"];
}
- (void)weChatAuthDeny {
    [MBProgressHUD showOnlyTextMessage:@"授权失败"];
}


#pragma mark--lazy--
/** 放置位置提示*/
- (UILabel *)postionLabel {
    if (!_postionLabel) {
        _postionLabel = [[UILabel alloc]init];
        _postionLabel.text = @"请选择视频放置位置";
        _postionLabel.textColor = [UIColor blackColor];
        _postionLabel.textAlignment = NSTextAlignmentLeft;
        _postionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _postionLabel;
}
/** 居左显示*/
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateSelected];
        [_leftBtn setTitle:@"顶部" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _leftBtn.spaceMargin = 6;
        _leftBtn.type = MBButtonTypeLeftImageRightTitle;
        _leftBtn.textAlignment = MBButtonAlignmentLeft;
        _leftBtn.selected = YES;
        [_leftBtn addTarget:self action:@selector(videoLayerPosition:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
/** 居中显示*/
- (UIButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [_centerBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateSelected];
        [_centerBtn setTitle:@"中部" forState:UIControlStateNormal];
        [_centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _leftBtn.spaceMargin = 6;
        _centerBtn.type = MBButtonTypeLeftImageRightTitle;
        [_centerBtn addTarget:self action:@selector(videoLayerPosition:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}
/** 居左显示*/
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateSelected];
        [_rightBtn setTitle:@"底部" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _rightBtn.spaceMargin = 6;
        _rightBtn.type = MBButtonTypeLeftImageRightTitle;
        _rightBtn.textAlignment = MBButtonAlignmentRight;
        [_rightBtn addTarget:self action:@selector(videoLayerPosition:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
/** 背景图*/
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        _bgImageView.layer.cornerRadius = kAdapt(5);
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.layer.masksToBounds = YES;
        _bgImageView.layer.cornerRadius = 5;
        _bgImageView.layer.borderColor = [UIColor colorWithHexString:@"#E74744"].CGColor;
        _bgImageView.layer.borderWidth = 1;
    }
    return _bgImageView;
}
/** 视频图层*/
- (UIImageView *)videoContainer {
    if (!_videoContainer) {
        _videoContainer = [[UIImageView alloc]init];
        _videoContainer.contentMode = UIViewContentModeScaleAspectFit;
        _videoContainer.backgroundColor = [UIColor clearColor];
        _videoContainer.userInteractionEnabled = YES;
        _videoContainer.layer.masksToBounds = YES;
    }
    return _videoContainer;
}
/** 上传视频按钮*/
- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadBtn.backgroundColor = [UIColor clearColor];
        [_uploadBtn setImage:[UIImage imageNamed:@"upload_video"] forState:UIControlStateNormal];
        [_uploadBtn setTitle:@"本地视频" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor colorWithHexString:@"#E74744"] forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _uploadBtn.type = MBButtonTypeTopImageBottomTitle;
        _uploadBtn.spaceMargin = kAdapt(20);
        [_uploadBtn addTarget:self action:@selector(uploadLocalVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}
/** 背景库*/
- (UIButton *)bgStoreBtn {
    if (!_bgStoreBtn) {
        _bgStoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgStoreBtn setImage:[UIImage imageNamed:@"bgimage_responsitory"] forState:UIControlStateNormal];
        [_bgStoreBtn setTitle:@"背景库" forState:UIControlStateNormal];
        [_bgStoreBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _bgStoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _bgStoreBtn.type = MBButtonTypeTopImageBottomTitle;
        _bgStoreBtn.spaceMargin = 5;
        _bgStoreBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _bgStoreBtn.layer.borderWidth = 1;
        _bgStoreBtn.layer.cornerRadius = kAdapt(5);
        _bgStoreBtn.layer.masksToBounds = YES;
        [_bgStoreBtn addTarget:self action:@selector(selectBgImageViewOnStore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgStoreBtn;
}
/** 完成按钮*/
- (UIButton *)localUploadBtn {
    if (!_localUploadBtn) {
        _localUploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_localUploadBtn setImage:[UIImage imageNamed:@"location_upload"] forState:UIControlStateNormal];
        [_localUploadBtn setTitle:@"本地上传" forState:UIControlStateNormal];
        [_localUploadBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _localUploadBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _localUploadBtn.type = MBButtonTypeTopImageBottomTitle;
        _localUploadBtn.spaceMargin = 5;
        _localUploadBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _localUploadBtn.layer.borderWidth = 1;
        _localUploadBtn.layer.cornerRadius = kAdapt(5);
        _localUploadBtn.layer.masksToBounds = YES;
        [_localUploadBtn addTarget:self action:@selector(uploadLocalImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _localUploadBtn;
}
/** 保存按钮*/
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _saveBtn.layer.cornerRadius = kAdapt(18);
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn addTarget:self action:@selector(saveStictchingVideoToLocal) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

@end
