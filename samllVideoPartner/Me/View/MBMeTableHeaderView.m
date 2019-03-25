//
//  MBMeTableHeaderView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBMeTableHeaderView.h"

@interface MBMeTableHeaderView ()
/** head container*/
@property (nonatomic, strong) UIView * headContainerView;
/** 用户昵称*/
@property (nonatomic, strong) UILabel * nickLabel;
/** 用户账号id*/
@property (nonatomic, strong) UILabel * userIdLabel;
/** 头像*/
@property (nonatomic, strong) UIButton * headIconBtn;
/** vip Container*/
@property (nonatomic, strong) UIView * vipContainerView;
/** vip背景图*/
@property (nonatomic, strong) UIImageView * vipBGImageView;
/** vip logo*/
@property (nonatomic, strong) UIImageView * vipLogo;
/** vip 特权*/
@property (nonatomic, strong) UILabel * vipLabel;
/** 开通VIP按钮*/
@property (nonatomic, strong) UILabel * openVipLabel;
/** 向右的箭头*/
@property (nonatomic, strong) UIImageView * rightArrow;
/** vip 描述*/
@property (nonatomic, strong) UILabel * vipDescLabel;

@end

@implementation MBMeTableHeaderView

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
    [self addSubview:self.headContainerView];
    [self.headContainerView addSubview:self.nickLabel];
    [self.headContainerView addSubview:self.userIdLabel];
    [self.headContainerView addSubview:self.headIconBtn];
    [self addSubview:self.vipContainerView];
    [self.vipContainerView addSubview:self.vipBGImageView];
    [self.vipBGImageView addSubview:self.vipLogo];
    [self.vipBGImageView addSubview:self.vipLabel];
    [self.vipBGImageView addSubview:self.rightArrow];;
    [self.vipBGImageView addSubview:self.openVipLabel];
    [self.vipBGImageView addSubview:self.vipDescLabel];
    [self.headContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kAdapt(120));
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headContainerView.mas_left).offset(kAdapt(21));
        make.top.equalTo(self.headContainerView.mas_top).offset(kAdapt(32));
        make.right.equalTo(self.headIconBtn.mas_left).offset(-kAdapt(20));
    }];
    [self.headIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(25));
        make.right.equalTo(self.mas_right).offset(-kAdapt(21));
        make.width.height.mas_equalTo(kAdapt(70));
    }];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickLabel.mas_left);
        make.bottom.equalTo(self.headIconBtn.mas_bottom);
    }];
    [self.vipContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.headContainerView.mas_bottom);
    }];
    [self.vipBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipContainerView.mas_left).offset(kAdapt(20));
        make.right.equalTo(self.vipContainerView.mas_right).offset(-kAdapt(20));
        make.top.equalTo(self.vipContainerView.mas_top).offset(kAdapt(17));
        make.height.mas_equalTo(kAdapt(114));
    }];
    [self.vipLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipBGImageView.mas_left).offset(kAdapt(13));
        make.top.equalTo(self.vipBGImageView.mas_top).offset(kAdapt(12));
    }];
    [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipLogo.mas_right);
        make.centerY.equalTo(self.vipLogo.mas_centerY);
    }];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipBGImageView.mas_right).offset(-kAdapt(12));
        make.centerY.equalTo(self.vipLogo.mas_centerY);
        make.width.mas_equalTo(kAdapt(7));
        make.height.mas_equalTo(kAdapt(13));
    }];
    [self.openVipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vipLogo.mas_centerY);
        make.right.equalTo(self.rightArrow.mas_left).offset(-kAdapt(5));
    }];
    [self.vipDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipBGImageView.mas_left).offset(kAdapt(11));
        make.top.equalTo(self.vipLabel.mas_bottom).offset(kAdapt(14));
        make.right.equalTo(self.vipBGImageView.mas_right).offset(-kAdapt(13));
    }];
}

#pragma mark--setter--
- (void)setUserInfo:(MBUserInfo *)userInfo {
    if ([MBUserManager manager].isLogin) {
        self.nickLabel.text = userInfo.nickname.length>0?userInfo.nickname:@"";
        self.userIdLabel.text = [NSString stringWithFormat:@"ID:%@",userInfo.code.length>0?userInfo.code:@""];
        
        NSString *headUrl = [userInfo.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.headIconBtn sd_setImageWithURL:[NSURL URLWithString:headUrl] forState:UIControlStateNormal];
        if ([MBUserManager manager].isVip) {
             self.openVipLabel.text = [NSDate YMDStringFromSecondsSince1970:[[MBUserManager manager].userInfo.over_time longLongValue]];
        }else {
            self.openVipLabel.text = @"去开通";
        }
    }else {
        self.nickLabel.text = @"未登录";
        self.userIdLabel.text = @"微信授权登录";
        [self.headIconBtn setImage:[UIImage imageNamed:@"default_headImage"] forState:UIControlStateNormal];
        self.openVipLabel.text = @"去开通";
    }
}

#pragma mark--action---
- (void)loginAction {
    if ([[MBUserManager manager]isLogin]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(wecahtAuthlogin)]) {
        [self.delegate wecahtAuthlogin];
    }
}
- (void)changeUserHeadIcon:(UIButton *)headBtn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeUserHeadImage:)]) {
        [self.delegate changeUserHeadImage:headBtn];
    }
}
- (void)openVip {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goToOpenVip)]) {
        [self.delegate goToOpenVip];
    }
}

#pragma mark--lazy--
/** head container*/
- (UIView *)headContainerView {
    if (!_headContainerView) {
        _headContainerView = [[UIView alloc]init];
        _headContainerView.backgroundColor = [UIColor whiteColor];
        [_headContainerView addSingleTapGestureTarget:self action:@selector(loginAction)];
    }
    return _headContainerView;
}
/** 用户昵称*/
- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _nickLabel.font = [UIFont systemFontOfSize:28];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.text = @"未登录";
        [_nickLabel sizeToFit];
    }
    return _nickLabel;
}
/** 用户id*/
- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc]init];
        _userIdLabel.textColor = [UIColor colorWithHexString:@"#515151"];
        _userIdLabel.font = [UIFont systemFontOfSize:14];
        _userIdLabel.textAlignment = NSTextAlignmentLeft;
        _userIdLabel.text = @"微信授权登录";
        [_userIdLabel sizeToFit];
    }
    return _userIdLabel;
}
/** 用户头像*/
- (UIButton *)headIconBtn {
    if (!_headIconBtn) {
        _headIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headIconBtn setImage:[UIImage imageNamed:@"default_headImage"] forState:UIControlStateNormal];
        _headIconBtn.layer.cornerRadius = kAdapt(35);
        _headIconBtn.layer.masksToBounds = YES;
        [_headIconBtn addTarget:self action:@selector(changeUserHeadIcon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headIconBtn;
}
/** VIP 容器*/
- (UIView *)vipContainerView {
    if (!_vipContainerView) {
        _vipContainerView = [[UIView alloc]init];
        _vipContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _vipContainerView;
}
/** vip 背景图*/
- (UIImageView *)vipBGImageView {
    if (!_vipBGImageView) {
        _vipBGImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_center_vip"]];
        _vipBGImageView.contentMode = UIViewContentModeScaleToFill;
        _vipBGImageView.userInteractionEnabled = YES;
    }
    return _vipBGImageView;
}
/** vip logo*/
- (UIImageView *)vipLogo {
    if (!_vipLogo) {
        _vipLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_vip_logo"]];
    }
    return _vipLogo;
}
/** vip 会员*/
- (UILabel *)vipLabel {
    if (!_vipLabel) {
        _vipLabel = [[UILabel alloc]init];
        _vipLabel.textColor = [UIColor colorWithHexString:@"#FFFEFE"];
        _vipLabel.font = [UIFont systemFontOfSize:16];
        _vipLabel.textAlignment = NSTextAlignmentLeft;
        _vipLabel.text = @"VIP会员特权";
        [_vipLabel sizeToFit];
    }
    return _vipLabel;
}
/** 开通vip*/
- (UILabel *)openVipLabel {
    if (!_openVipLabel) {
        _openVipLabel = [[UILabel alloc]init];
        _openVipLabel.textColor = [UIColor colorWithHexString:@"#FFFEFE"];
        _openVipLabel.font = [UIFont systemFontOfSize:14];
        _openVipLabel.textAlignment = NSTextAlignmentLeft;
        [_openVipLabel sizeToFit];
        [_openVipLabel addSingleTapGestureTarget:self action:@selector(openVip)];
    }
    return _openVipLabel;
}
/** 向右的箭头*/
- (UIImageView *)rightArrow {
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_rightArrow"]];
        [_rightArrow addSingleTapGestureTarget:self action:@selector(openVip)];
    }
    return _rightArrow;
}
/** vip 描述*/
- (UILabel *)vipDescLabel {
    if (!_vipDescLabel) {
        _vipDescLabel = [[UILabel alloc]init];
        _vipDescLabel.textColor = [UIColor colorWithHexString:@"#FAFDFF"];
        _vipDescLabel.font = [UIFont systemFontOfSize:14];
        _vipDescLabel.textAlignment = NSTextAlignmentLeft;
        _vipDescLabel.text = @"玩转视频，更多花样，展现个性的你";
        [_vipDescLabel sizeToFit];
    }
    return _vipDescLabel;
}
@end
