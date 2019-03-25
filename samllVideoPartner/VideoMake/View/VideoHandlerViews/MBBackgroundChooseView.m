//
//  MBBackgroundChooseView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBackgroundChooseView.h"

@interface MBBackgroundChooseView ()
/** 关闭按钮*/
@property (nonatomic, strong) UIButton * closeBtn;
/** 完成*/
@property (nonatomic, strong) UIButton * finishBtn;
/** 透明度*/
@property (nonatomic, strong) UILabel * alphaLabel;
/** t背景图透明度控制slider*/
@property (nonatomic, strong) UISlider * bgAlphaSlider;
/** 背景库*/
@property (nonatomic, strong) UIButton * bgStoreBtn;
/** 本地上传*/
@property (nonatomic, strong) UIButton * localUploadBtn;
@end

@implementation MBBackgroundChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerRadius:kAdapt(20) rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
        [self seupSubviewsAndConstraints];
    }
    return self;
}

- (void)seupSubviewsAndConstraints {
    [self addSubview:self.closeBtn];
    [self addSubview:self.finishBtn];
    [self addSubview:self.alphaLabel];
    [self addSubview:self.bgAlphaSlider];
    [self addSubview:self.bgStoreBtn];
    [self addSubview:self.localUploadBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kAdapt(15));
        make.top.equalTo(self.mas_top).offset(kAdapt(11));
        make.width.height.mas_equalTo(kAdapt(16));
    }];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(12));
        make.right.equalTo(self.mas_right).offset(-kAdapt(13));
        make.width.mas_equalTo(kAdapt(19));
        make.height.mas_equalTo(kAdapt(15));
    }];
    [self.alphaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(50));
        make.left.equalTo(self.mas_left).offset(kAdapt(14));
    }];
    [self.bgAlphaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alphaLabel.mas_centerY);
        make.left.equalTo(self.alphaLabel.mas_right).offset(kAdapt(10));
        make.right.equalTo(self.mas_right).offset(-kAdapt(25));
    }];
    [self.bgStoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alphaLabel.mas_bottom).offset(kAdapt(10));
        make.left.equalTo(self.alphaLabel.mas_left);
        make.width.mas_equalTo(kAdapt(59));
        make.height.mas_equalTo(kAdapt(50));
    }];
    [self.localUploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgStoreBtn.mas_centerY);
        make.left.equalTo(self.bgStoreBtn.mas_right).offset(kAdapt(10));
        make.width.mas_equalTo(kAdapt(59));
        make.height.mas_equalTo(kAdapt(50));
    }];
    
}

- (void)sliderIsDraging:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bgImageAlphaWithProgress:)]) {
        [self.delegate bgImageAlphaWithProgress:slider.value];
    }
}

#pragma mark--lazy--
/** 关闭按钮*/
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_closeBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(closeBackgroundChooseView)]) {
                [weakSelf.delegate closeBackgroundChooseView];
            }
        }];
    }
    return _closeBtn;
}
/** 完成按钮*/
- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_finishBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(finishChooseBackground)]) {
                [weakSelf.delegate finishChooseBackground];
            }
        }];
    }
    return _finishBtn;
}
/** 原声*/
- (UILabel *)alphaLabel {
    if (!_alphaLabel) {
        _alphaLabel = [[UILabel alloc]init];
        _alphaLabel.textAlignment = NSTextAlignmentLeft;
        _alphaLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _alphaLabel.font = [UIFont systemFontOfSize:11];
        _alphaLabel.text = @"透明度";
        [_alphaLabel sizeToFit];
    }
    return _alphaLabel;
}
/** 原声控制slider*/
- (UISlider *)bgAlphaSlider {
    if (!_bgAlphaSlider) {
        _bgAlphaSlider = [[UISlider alloc]init];
        _bgAlphaSlider.value = 1.0;
        _bgAlphaSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#E51B1B"];
        _bgAlphaSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#999999"];
        [_bgAlphaSlider setThumbImage:[UIImage imageNamed:@"slider_thum"] forState:UIControlStateNormal];
        [_bgAlphaSlider addTarget:self action:@selector(sliderIsDraging:) forControlEvents:UIControlEventValueChanged];
    }
    return _bgAlphaSlider;
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
        __weak typeof(self) weakSelf = self;
        [_bgStoreBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chooseBackgroundOnStore)]) {
                [weakSelf.delegate chooseBackgroundOnStore];
            }
        }];
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
        __weak typeof(self) weakSelf = self;
        [_localUploadBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(uploadBackgroundFromLocal)]) {
                [weakSelf.delegate uploadBackgroundFromLocal];
            }
        }];
    }
    return _localUploadBtn;
}

@end
