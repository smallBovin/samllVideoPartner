//
//  MBBackgroundCollectionCell.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBackgroundCollectionCell.h"
#import "MBMapsModel.h"

@interface MBBackgroundCollectionCell ()

/** 背景图*/
@property (nonatomic, strong) UIImageView * bgImageView;
/** vipLogo*/
@property (nonatomic, strong) UIImageView * vipLogo;
/** 下载标识*/
@property (nonatomic, strong) UIImageView * downloadLogo;
/** 名称*/
@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation MBBackgroundCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.vipLogo];
    [self.bgImageView addSubview:self.downloadLogo];
    [self.contentView addSubview:self.nameLabel];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(kAdapt(160));
    }];
    [self.vipLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top).offset(kAdapt(6));
        make.right.equalTo(self.bgImageView.mas_right).offset(-kAdapt(6));
        make.width.mas_equalTo(kAdapt(16));
        make.height.mas_equalTo(kAdapt(6));
    }];
    [self.downloadLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-kAdapt(6));
        make.right.equalTo(self.bgImageView.mas_right).offset(-kAdapt(10));
        make.width.height.mas_equalTo(kAdapt(20));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.bgImageView.mas_bottom).offset(kAdapt(10));
    }];
}

#pragma mark--setter---
- (void)setModel:(MBMapsModel *)model {
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor]]];
    if ([[MBUserManager manager]isUnderReview]) {
        self.vipLogo.image = nil;
    }else {
        if ([model.author isEqualToString:@"1"]) {
            self.vipLogo.image = [UIImage imageNamed:@"vip_sign"];
        }else {
            self.vipLogo.image = nil;
        }
    }
    self.downloadLogo.hidden = model.isDownload;
    self.nameLabel.text = model.title.length>0?model.title:@"";
    
}

#pragma mark--lazy--
/** 背景图*/
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.layer.cornerRadius = 5;
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}
/** vip标识*/
- (UIImageView *)vipLogo {
    if (!_vipLogo) {
        _vipLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_sign"]];
    }
    return _vipLogo;
}
/** 下载标识*/
- (UIImageView *)downloadLogo {
    if (!_downloadLogo) {
        _downloadLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_make_download"]];
    }
    return _downloadLogo;
}
/** 名称*/
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"名称";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

@end
