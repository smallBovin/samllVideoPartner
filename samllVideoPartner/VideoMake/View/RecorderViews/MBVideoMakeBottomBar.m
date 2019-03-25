//
//  MBVideoMakeBottomBar.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/21.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBVideoMakeBottomBar.h"

@interface MBVideoMakeBottomBar ()
/** 发现*/
@property (nonatomic, strong) UIImageView * findImageView;
/** 发现label*/
@property (nonatomic, strong) UILabel * findLabel;
/** 发现按钮*/
@property (nonatomic, strong) UIButton * findBtn;
/** 录音与暂停*/
@property (nonatomic, strong) UIButton * recordBtn;
/** 视频相册*/
@property (nonatomic, strong) UIImageView * myVideoImageView;
/** 视频相册label*/
@property (nonatomic, strong) UILabel * myVideoLabel;
/** 我的视频相册*/
@property (nonatomic, strong) UIButton * myVideoBtn;

@end

@implementation MBVideoMakeBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerRadius:kAdapt(20) rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.recordBtn];
    [self addSubview:self.findImageView];
    [self addSubview:self.findBtn];
    [self addSubview:self.findLabel];
    [self addSubview:self.myVideoImageView];
    [self addSubview:self.myVideoLabel];
    [self addSubview:self.myVideoBtn];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kAdapt(20));
        make.width.height.mas_equalTo(kAdapt(60));
    }];
    [self.findImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtn.mas_centerY);
        make.right.equalTo(self.recordBtn.mas_left).offset(-kAdapt(55));
        make.width.height.mas_equalTo(kAdapt(42));
    }];
    [self.findLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.findImageView.mas_centerX);
        make.top.equalTo(self.findImageView.mas_bottom).offset(kAdapt(5));
    }];
    [self.findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.findImageView.mas_centerX);
        make.centerY.equalTo(self.recordBtn.mas_centerY);
        make.width.height.mas_equalTo(kAdapt(65));
    }];
    [self.myVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordBtn.mas_centerY);
        make.left.equalTo(self.recordBtn.mas_right).offset(kAdapt(55));
        make.width.height.mas_equalTo(kAdapt(42));
    }];
    [self.myVideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.myVideoImageView.mas_centerX);
        make.top.equalTo(self.myVideoImageView.mas_bottom).offset(kAdapt(5));
    }];
    [self.myVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.myVideoImageView.mas_centerX);
        make.centerY.equalTo(self.recordBtn.mas_centerY);
        make.width.height.mas_equalTo(kAdapt(65));
    }];
    
}

//录音时处理显示
- (void)handlerShowWhenRecordState:(BOOL)state {
    if (state) {
        self.findImageView.hidden = YES;
        self.findLabel.hidden = YES;
        self.findBtn.hidden = YES;
        self.myVideoImageView.hidden = YES;
        self.myVideoLabel.hidden = YES;
        self.myVideoBtn.hidden = YES;
    }else {
        self.findImageView.hidden = NO;
        self.findLabel.hidden = NO;
        self.findBtn.hidden = NO;
        self.myVideoImageView.hidden = NO;
        self.myVideoLabel.hidden = NO;
        self.myVideoBtn.hidden = NO;
    }
}

#pragma mark--setter--
- (void)setVideoImage:(UIImage *)videoImage {
    _videoImage = videoImage;
    self.myVideoImageView.image = videoImage;
}

#pragma mark--lazy---
/** 发现图片*/
- (UIImageView *)findImageView {
    if (!_findImageView) {
        _findImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"find_video"]];
    }
    return _findImageView;
}
/** 发现标题*/
- (UILabel *)findLabel {
    if (!_findLabel) {
        _findLabel = [[UILabel alloc]init];
        _findLabel.textAlignment = NSTextAlignmentCenter;
        _findLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _findLabel.font = [UIFont systemFontOfSize:11];
        _findLabel.text = @"发现";
    }
    return _findLabel;
}
/** 发现*/
- (UIButton *)findBtn {
    if (!_findBtn) {
        _findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _findBtn.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        [_findBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(findSomeFunnyVideo)]) {
                [weakSelf.delegate findSomeFunnyVideo];
            }
        }];
    }
    return _findBtn;
}
/** 录音与暂停*/
- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setImage:[UIImage imageNamed:@"record_pause"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"record_play"] forState:UIControlStateSelected];
        __weak typeof(self) weakSelf = self;
        [_recordBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(beginOrEndRecordAudio:)]) {
                [weakSelf.delegate beginOrEndRecordAudio:btn];
            }
        }];
    }
    return _recordBtn;
}
/** 视频相册图片*/
- (UIImageView *)myVideoImageView {
    if (!_myVideoImageView) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:kNewestVideoThum];
        UIImage *image;
        if (imageData && imageData.length>0) {
            image = [UIImage imageWithData:imageData];
        }else {
            image = [UIImage imageNamed:@"input_video"];
        }
        _myVideoImageView = [[UIImageView alloc]initWithImage:image];
        _myVideoImageView.layer.cornerRadius = kAdapt(21);
        _myVideoImageView.layer.masksToBounds = YES;
        _myVideoImageView.layer.borderColor = [UIColor blackColor].CGColor;
        _myVideoImageView.layer.borderWidth = 1;
    }
    return _myVideoImageView;
}
/** 视频标题*/
- (UILabel *)myVideoLabel {
    if (!_myVideoLabel) {
        _myVideoLabel = [[UILabel alloc]init];
        _myVideoLabel.textAlignment = NSTextAlignmentCenter;
        _myVideoLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _myVideoLabel.font = [UIFont systemFontOfSize:11];
        _myVideoLabel.text = @"导入";
    }
    return _myVideoLabel;
}/** 我的视频相册*/
- (UIButton *)myVideoBtn {
    if (!_myVideoBtn) {
        _myVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myVideoBtn.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        [_myVideoBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectLocalVideoLibrary)]) {
                [weakSelf.delegate selectLocalVideoLibrary];
            }
        }];
    }
    return _myVideoBtn;
}
@end
