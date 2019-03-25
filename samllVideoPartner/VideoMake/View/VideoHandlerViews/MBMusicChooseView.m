//
//  MBMusicChooseView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicChooseView.h"

@interface MBMusicChooseView ()
/** 关闭按钮*/
@property (nonatomic, strong) UIButton * closeBtn;
/** 完成*/
@property (nonatomic, strong) UIButton * finishBtn;
/** 原声*/
@property (nonatomic, strong) UILabel * orignalLabel;
/** 原声控制slider*/
@property (nonatomic, strong) UISlider * orginalSoundSlider;
/** 配乐*/
@property (nonatomic, strong) UILabel * bgMusicLabel;
/** 音乐名称*/
@property (nonatomic, strong) UILabel * musicNameLabel;
/** 添加or切换配乐*/
@property (nonatomic, strong) UIButton * addOrChangeMusicBtn;
/** 配乐声音控制slider*/
@property (nonatomic, strong) UISlider * bgMusicSoundSlider;

@end

@implementation MBMusicChooseView

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
    [self addSubview:self.orignalLabel];
    [self addSubview:self.orginalSoundSlider];
    [self addSubview:self.bgMusicLabel];
    [self addSubview:self.musicNameLabel];
    [self addSubview:self.addOrChangeMusicBtn];
    [self addSubview:self.bgMusicSoundSlider];
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
    [self.orignalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(50));
        make.left.equalTo(self.mas_left).offset(kAdapt(14));
    }];
    [self.orginalSoundSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.orignalLabel.mas_centerY);
        make.left.equalTo(self.orignalLabel.mas_right).offset(kAdapt(8));
        make.right.equalTo(self.mas_right).offset(-kAdapt(24));
    }];
    [self.bgMusicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orignalLabel.mas_left);
        make.top.equalTo(self.orignalLabel.mas_bottom).offset(kAdapt(20));
    }];
    [self.bgMusicSoundSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgMusicLabel.mas_centerY);
        make.left.equalTo(self.bgMusicLabel.mas_right).offset(kAdapt(8));
        make.right.equalTo(self.mas_right).offset(-kAdapt(24));
    }];
    [self.addOrChangeMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.musicNameLabel.mas_centerY);
        make.right.equalTo(self.orginalSoundSlider.mas_right);
        make.width.mas_equalTo(kAdapt(68));
        make.height.mas_equalTo(kAdapt(23));
    }];
    [self.musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orginalSoundSlider.mas_left);
        make.centerY.equalTo(self.bgMusicLabel.mas_centerY);
        make.right.lessThanOrEqualTo(self.addOrChangeMusicBtn.mas_left).offset(-kAdapt(10));
    }];
    
}

#pragma mark--setter---
- (void)setMusicName:(NSString *)musicName {
    _musicName = musicName;
    if (musicName.length>0) {
        self.musicNameLabel.text = musicName;
        [self updateUIAndConstranits];
    }
}

#pragma mark--action---
-  (void)changeOrigionVideoVolume:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragSliderToChangeOriginalVideoVolume:)]) {
        [self.delegate dragSliderToChangeOriginalVideoVolume:slider.value];
    }
}

- (void)changeBgMusicVolume:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragSliderToChangeBgMusicVolume:)]) {
        [self.delegate dragSliderToChangeBgMusicVolume:slider.value];
    }
}


#pragma mark--private method---
- (void)updateUIAndConstranits {
    self.bgMusicSoundSlider.hidden = NO;
    self.musicNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.addOrChangeMusicBtn setTitle:@"切换配乐>>" forState:UIControlStateNormal];
    self.addOrChangeMusicBtn.layer.borderColor = [UIColor clearColor].CGColor;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"切换配乐>>"];
    [string addAttributes:@{NSUnderlineStyleAttributeName:@1} range:NSMakeRange(0, string.string.length)];
    self.addOrChangeMusicBtn.titleLabel.attributedText = string;
    [self.musicNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgMusicSoundSlider.mas_bottom).offset(kAdapt(10));
        make.left.equalTo(self.orginalSoundSlider.mas_left);
        make.right.lessThanOrEqualTo(self.addOrChangeMusicBtn.mas_left).offset(-kAdapt(10));
    }];
    [self.addOrChangeMusicBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.musicNameLabel.mas_centerY);
        make.right.equalTo(self.orginalSoundSlider.mas_right);
        make.width.mas_equalTo(kAdapt(68));
        make.height.mas_equalTo(kAdapt(23));
    }];
}

#pragma mark--lazy--
/** 关闭按钮*/
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_closeBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(closeMusicChooseView)]) {
                [weakSelf.delegate closeMusicChooseView];
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
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(finishChooseMusic)]) {
                [weakSelf.delegate finishChooseMusic];
            }
        }];
    }
    return _finishBtn;
}
/** 原声*/
- (UILabel *)orignalLabel {
    if (!_orignalLabel) {
        _orignalLabel = [[UILabel alloc]init];
        _orignalLabel.textAlignment = NSTextAlignmentLeft;
        _orignalLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _orignalLabel.font = [UIFont systemFontOfSize:11];
        _orignalLabel.text = @"原声";
        [_orignalLabel sizeToFit];
    }
    return _orignalLabel;
}
/** 原声控制slider*/
- (UISlider *)orginalSoundSlider {
    if (!_orginalSoundSlider) {
        _orginalSoundSlider = [[UISlider alloc]init];
        _orginalSoundSlider.value = 1.0;
        _orginalSoundSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#E51B1B"];
        _orginalSoundSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#999999"];
        [_orginalSoundSlider setThumbImage:[UIImage imageNamed:@"slider_thum"] forState:UIControlStateNormal];
        [_orginalSoundSlider addTarget:self action:@selector(changeOrigionVideoVolume:) forControlEvents:UIControlEventValueChanged];
    }
    return _orginalSoundSlider;
}
/** 配乐*/
- (UILabel *)bgMusicLabel {
    if (!_bgMusicLabel) {
        _bgMusicLabel = [[UILabel alloc]init];
        _bgMusicLabel.textAlignment = NSTextAlignmentLeft;
        _bgMusicLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _bgMusicLabel.font = [UIFont systemFontOfSize:11];
        _bgMusicLabel.text = @"配乐";
        [_bgMusicLabel sizeToFit];
    }
    return _bgMusicLabel;
}
/** 配乐控制slider*/
- (UISlider *)bgMusicSoundSlider {
    if (!_bgMusicSoundSlider) {
        _bgMusicSoundSlider = [[UISlider alloc]init];
        _bgMusicSoundSlider.value = 1.0;
        _bgMusicSoundSlider.minimumTrackTintColor = [UIColor colorWithHexString:@"#E51B1B"];
        _bgMusicSoundSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#999999"];
        [_bgMusicSoundSlider setThumbImage:[UIImage imageNamed:@"slider_thum"] forState:UIControlStateNormal];
        _bgMusicSoundSlider.hidden = YES;
        [_bgMusicSoundSlider addTarget:self action:@selector(changeBgMusicVolume:) forControlEvents:UIControlEventValueChanged];
    }
    return _bgMusicSoundSlider;
}
/** 音乐名称*/
- (UILabel *)musicNameLabel {
    if (!_musicNameLabel) {
        _musicNameLabel = [[UILabel alloc]init];
        _musicNameLabel.textAlignment = NSTextAlignmentLeft;
        _musicNameLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _musicNameLabel.font = [UIFont systemFontOfSize:11];
        _musicNameLabel.text = @"试试添加配乐";
        [_musicNameLabel sizeToFit];
    }
    return _musicNameLabel;
}
/** 添加或更换配乐*/
- (UIButton *)addOrChangeMusicBtn {
    if (!_addOrChangeMusicBtn) {
        _addOrChangeMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addOrChangeMusicBtn setTitle:@"添加配乐" forState:UIControlStateNormal];
        [_addOrChangeMusicBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _addOrChangeMusicBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _addOrChangeMusicBtn.layer.borderWidth = 1;
        _addOrChangeMusicBtn.layer.cornerRadius = 5;
        _addOrChangeMusicBtn.layer.masksToBounds = YES;
        _addOrChangeMusicBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        __weak typeof(self) weakSelf = self;
        [_addOrChangeMusicBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addOrChangeBackgroundMusic)]) {
                [weakSelf.delegate addOrChangeBackgroundMusic];
            }        }];
    }
    return _addOrChangeMusicBtn;
}
@end
