//
//  MBWechatLoginView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBWechatLoginView.h"

@interface MBWechatLoginView ()
/** 关闭按钮*/
@property (nonatomic, strong) UIButton * closeBtn;
/** 提示标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 登录按钮*/
@property (nonatomic, strong) UIButton * loginBtn;
/** 用户协议*/
@property (nonatomic, strong) UILabel * protocolLabel;


@end

@implementation MBWechatLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.loginBtn];
    [self addSubview:self.protocolLabel];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(9));
        make.right.equalTo(self.mas_right).offset(-kAdapt(12));
        make.width.height.mas_equalTo(kAdapt(15));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(20));
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kAdapt(40));
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(kAdapt(240));
        make.height.mas_equalTo(kAdapt(44));
    }];
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(kAdapt(20));
        make.centerX.equalTo(self);
    }];
}

#pragma mark--action用户点击协议----
- (void)clickUserProtocol:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    CGPoint point = [tap locationInView:self.protocolLabel];
    CGRect protocolRect = [label boundingRectForCharacterRange:[self.protocolLabel.text rangeOfString:@"《小视伙伴协议》"]];
    CGRect privacyRect = [label boundingRectForCharacterRange:[self.protocolLabel.text rangeOfString:@"《隐私政策》"]];
    if (CGRectContainsPoint(protocolRect, point)) {
        if (self.protocolAction) {
            self.protocolAction();
        }
    }else if (CGRectContainsPoint(privacyRect, point)) {
        if (self.privacyAction) {
            self.privacyAction();
        }
    }
}

#pragma mark--lazy---
/** 关闭按钮*/
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"mian_closeBtn"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_closeBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.closeAction) {
                weakSelf.closeAction();
            }
        }];
    }
    return _closeBtn;
}
/** 提示标题*/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"欢迎来到小视伙伴";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
/** 登录按钮*/
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#00CC1C"]];
        [_loginBtn setTitle:@"微信授权登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _loginBtn.layer.cornerRadius = 5;
        __weak typeof(self) weakSelf = self;
        [_loginBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.loginAction) {
                weakSelf.loginAction();
            }
        }];
    }
    return _loginBtn;
}
/** 用户协议*/
- (UILabel *)protocolLabel {
    if (!_protocolLabel) {
        _protocolLabel = [[UILabel alloc]init];
        _protocolLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _protocolLabel.textAlignment = NSTextAlignmentLeft;
        _protocolLabel.font = [UIFont systemFontOfSize:12];
        _protocolLabel.text = @"登录即同意《小视伙伴协议》《隐私政策》";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_protocolLabel.text];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FA3C3C"]} range:[attr.string rangeOfString:@"《小视伙伴协议》"]];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FA3C3C"]} range:[attr.string rangeOfString:@"《隐私政策》"]];
        _protocolLabel.preferredMaxLayoutWidth = kAdapt(290);
        _protocolLabel.attributedText = attr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserProtocol:)];
        _protocolLabel.userInteractionEnabled = YES;
        [_protocolLabel addGestureRecognizer:tap];
    }
    return _protocolLabel;
}
@end
