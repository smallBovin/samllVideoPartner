//
//  MBMusicAuditionView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicAuditionView.h"
/** 音乐model*/
#import "MBMapsModel.h"
/** 音乐播放器*/
#import "MBAudioPlayer.h"

@interface MBMusicAuditionView ()<MBAudioPlayerDelegate>

/** progress */
@property (nonatomic, strong) UIProgressView * progressView;
/** 音乐海报图*/
@property (nonatomic, strong) UIImageView * posterImageView;
/** 播放按钮*/
@property (nonatomic, strong) UIButton * playOrPauseBtn;
/** 音乐名称*/
@property (nonatomic, strong) UILabel * nameLabel;
/** 作者名称*/
@property (nonatomic, strong) UILabel * singerLabel;
/** 使用*/
@property (nonatomic, strong) UIButton * useBtn;
/** 剪辑*/
@property (nonatomic, strong) UIButton * editBtn;

/** 音频播放器*/
@property (nonatomic, strong) MBAudioPlayer * audioPlayer;

@end

@implementation MBMusicAuditionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}
- (void)setupSubviewsAndConstraints {
    [self addSubview:self.progressView];
    [self addSubview:self.posterImageView];
    [self.posterImageView addSubview:self.playOrPauseBtn];
    [self addSubview:self.nameLabel];
    [self addSubview:self.singerLabel];
    [self addSubview:self.useBtn];
    [self addSubview:self.editBtn];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(6);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.height.mas_equalTo(39);
    }];
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.posterImageView.mas_centerX);
        make.centerY.equalTo(self.posterImageView.mas_centerY);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.posterImageView.mas_top).offset(3);
        make.left.equalTo(self.posterImageView.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.useBtn.mas_left).offset(-10);
        make.width.mas_equalTo(kAdapt(120));
    }];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.posterImageView.mas_bottom).offset(-3);
        make.left.equalTo(self.posterImageView.mas_right).offset(10);
    }];

    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.posterImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.posterImageView.mas_centerY);
        make.right.equalTo(self.editBtn.mas_left).offset(-25);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(25);
    }];
}

- (void)setAudioModel:(MBMapsModel *)audioModel {
    _audioModel = audioModel;
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:audioModel.thumb] placeholderImage:[UIImage imageNamed:@"music_default_icon"]];
    self.playOrPauseBtn.selected = NO;
    self.nameLabel.text = audioModel.title.length>0?audioModel.title:@"";
    self.singerLabel.text = audioModel.singer.length>0?audioModel.singer:@"";
    
}

- (void)setLocalAudioUrl:(NSURL *)localAudioUrl {
    _localAudioUrl = localAudioUrl;
    [self.audioPlayer stop];
    self.progressView.progress = 0;
    if (!self.audioPlayer) {
        self.audioPlayer = [[MBAudioPlayer alloc]init];
    }
    [self.audioPlayer playerAudioWithUrl:localAudioUrl];
    self.audioPlayer.delegate = self;
    __weak typeof(self) weakSelf = self;
    self.audioPlayer.isObserverProgress = YES;
    self.audioPlayer.progress = ^(CGFloat progress) {
        [weakSelf.progressView setProgress:progress animated:YES];
    };
}

#pragma mark--MBAudioPlayerDelegate--
- (void)currentPlayerState:(MBAudioPlayerState)playState {
    if (playState == MBAudioPlayerStatePlaying) {
        self.playOrPauseBtn.selected = YES;
    }else {
        self.playOrPauseBtn.selected = NO;
    }
    if (playState == MBAudioPlayerStatePlayEnd) {
        self.progressView.progress = 0.0;
    }
}

#pragma mark--action---
- (void)playOrPauseAuditionMusic:(UIButton *)playOrPauseBtn {
    if (playOrPauseBtn.selected) {
        [self.audioPlayer pause];
    }else {
        [self.audioPlayer play];
    }
}

- (void)useSelectMusicAsDubMusic {
    [self.audioPlayer stop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(directUseCurrentAuditionMusic)]) {
        [self.delegate directUseCurrentAuditionMusic];
    }
}

- (void)editSelectMusic {
    [self.audioPlayer stop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCurrentAuditionMusic)]) {
        [self.delegate editCurrentAuditionMusic];
    }
}

#pragma mark--lazy--
/** progress */
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#E51B1B"];
        _progressView.trackTintColor = [UIColor colorWithHexString:@"#EFEFEF"];
    }
    return _progressView;
}
/** 海报图*/
- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc]init];
        _posterImageView.image = [UIImage imageNamed:@"music_default_icon"];
        _posterImageView.userInteractionEnabled = YES;
        _posterImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _posterImageView;
}
/** 播放暂停按钮*/
- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseBtn.backgroundColor = [UIColor clearColor];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"music_play"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(playOrPauseAuditionMusic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPauseBtn;
}
/** 名称*/
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"名称";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}
/** 名称*/
- (UILabel *)singerLabel {
    if (!_singerLabel) {
        _singerLabel = [[UILabel alloc]init];
        _singerLabel.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
        _singerLabel.font = [UIFont systemFontOfSize:11];
        _singerLabel.textAlignment = NSTextAlignmentLeft;
        _singerLabel.text = @"演唱者";
        [_singerLabel sizeToFit];
    }
    return _singerLabel;
}
/** 使用按钮*/
- (UIButton *)useBtn {
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_useBtn setTitle:@"使用" forState:UIControlStateNormal];
        [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _useBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _useBtn.layer.cornerRadius = 5;
        _useBtn.layer.masksToBounds = YES;
        [_useBtn addTarget:self action:@selector(useSelectMusicAsDubMusic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useBtn;
}
/** 剪辑*/
- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setBackgroundColor:[UIColor blackColor] state:UIControlStateNormal];
        [_editBtn setTitle:@"剪辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _editBtn.layer.cornerRadius = 5;
        _editBtn.layer.masksToBounds = YES;
        [_editBtn addTarget:self action:@selector(editSelectMusic) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}
- (void)dealloc {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    NSLog(@"%@==== 释放了",[self description]);
}

@end
