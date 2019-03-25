//
//  MBMusicTableViewCell.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicTableViewCell.h"
#import "MBMapsModel.h"

@interface MBMusicTableViewCell ()

/** 音乐海报图*/
@property (nonatomic, strong) UIImageView * posterImageView;
/** 音乐名称*/
@property (nonatomic, strong) UILabel * nameLabel;
/** 作者名称*/
@property (nonatomic, strong) UILabel * singerLabel;
/** vipLogo*/
@property (nonatomic, strong) UIImageView * vipOrFreeLogo;
/** 分割线*/
@property (nonatomic, strong) UIView * sepLine;


@end

@implementation MBMusicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.posterImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.singerLabel];
    [self.contentView addSubview:self.vipOrFreeLogo];
    [self.contentView addSubview:self.sepLine];
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.height.mas_equalTo(39);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.posterImageView.mas_right).offset(11);
        make.top.equalTo(self.posterImageView.mas_top).offset(4);
//        make.right.lessThanOrEqualTo(self.vipOrFreeLogo.mas_left).offset(-10);
    }];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self.posterImageView.mas_right).offset(11);
        make.bottom.equalTo(self.posterImageView.mas_bottom).offset(-4);
    }];
    [self.vipOrFreeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-22);
        make.width.mas_equalTo(kAdapt(15));
    }];
    [self.vipOrFreeLogo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setModel:(MBMapsModel *)model {
    _model = model;
    [self.posterImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"music_default_icon"]];
    if ([[MBUserManager manager]isUnderReview]) {
        self.vipOrFreeLogo.image = nil;
    }else {
        if ([model.author isEqualToString:@"1"]) {
            self.vipOrFreeLogo.image = [UIImage imageNamed:@"vip_sign"];
        }else {
            self.vipOrFreeLogo.image = nil;
        }
    }
    self.nameLabel.text = model.title.length>0?model.title:@"";
    self.singerLabel.text = model.singer.length>0?model.singer:@"";
}

#pragma mark--lazy---
/** 海报图*/
- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc]init];
        _posterImageView.image = [UIImage imageNamed:@"music_default_icon"];
        _posterImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _posterImageView;
}
/** vip标识*/
- (UIImageView *)vipOrFreeLogo {
    if (!_vipOrFreeLogo) {
        _vipOrFreeLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_sign"]];
    }
    return _vipOrFreeLogo;
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
/** 分割线*/
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    }
    return _sepLine;
}
@end
