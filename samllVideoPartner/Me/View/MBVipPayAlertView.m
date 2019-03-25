//
//  MBVipPayAlertView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBVipPayAlertView.h"

@interface MBVipPayAlertView ()

/** 背景图*/
@property (nonatomic, strong) UIImageView * bgImageView;
/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 订单金额*/
@property (nonatomic, strong) UILabel * orderPriceLabel;
/** 确认按钮*/
@property (nonatomic, strong) UIButton * commitBtn;

/** 微信支付平台*/
@property (nonatomic, strong) UIView * wechatPayView;
/** 微信指示图片*/
@property (nonatomic, strong) UIImageView * wechatIndicator;
/** 支付宝平台*/
@property (nonatomic, strong) UIView * alipayView;
/** 支付宝指示图片*/
@property (nonatomic, strong) UIImageView * alipayIndicator;

/** 选择的支付类型*/
@property (nonatomic, assign) MBPayType  payType;

@end

@implementation MBVipPayAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.payType = MBPayTypeWecahtPay;
        [self setCornerRadius:10 rectCornerType:UIRectCornerAllCorners];
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.orderPriceLabel];
    [self.bgImageView addSubview:self.wechatPayView];
    [self.wechatPayView addSubview:self.wechatIndicator];
//    [self.bgImageView addSubview:self.alipayView];
//    [self.alipayView addSubview:self.alipayIndicator];
    [self.bgImageView addSubview:self.commitBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(kAdapt(17));
    }];
    [self.orderPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kAdapt(10));
    }];
    [self.wechatPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderPriceLabel.mas_bottom).offset(30);
        make.left.equalTo(self.mas_left).offset(kAdapt(21));
        make.right.equalTo(self.mas_right).offset(-kAdapt(21));
        make.height.mas_equalTo(40);
    }];
    [self.wechatIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wechatPayView.mas_centerY);
        make.right.equalTo(self.wechatPayView.mas_right);
    }];
//    [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.wechatPayView.mas_bottom);
//        make.left.equalTo(self.mas_left).offset(kAdapt(21));
//        make.right.equalTo(self.mas_right).offset(-kAdapt(21));
//        make.height.mas_equalTo(40);
//    }];
//    [self.alipayIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.alipayView.mas_centerY);
//        make.right.equalTo(self.alipayView.mas_right);
//    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-kAdapt(25));
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(kAdapt(40));
        make.width.mas_equalTo(kAdapt(230));
    }];
}

#pragma mark--action--
/** 选择支付方式*/
- (void)choosePayType:(UITapGestureRecognizer *)tap {
    if ([tap.view isEqual:self.wechatPayView]) {
        self.wechatIndicator.image = [UIImage imageNamed:@"pay_select"];
        self.alipayIndicator.image = [UIImage imageNamed:@"pay_normal"];
        self.payType = MBPayTypeWecahtPay;
    }else {
        self.wechatIndicator.image = [UIImage imageNamed:@"pay_normal"];
        self.alipayIndicator.image = [UIImage imageNamed:@"pay_select"];
        self.payType = MBPayTypeAlipay;
    }
}
/**去付款*/
- (void)goToPay {
    if (self.payBlock) {
        self.payBlock(self.payType);
    }
}

#pragma mark--lazy--
/** 背景图*/
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_alert_bg"]];
        _bgImageView.frame = self.bounds;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
/** 标题*/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLabel.text = @"支付订单";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
/** 订单金额*/
- (UILabel *)orderPriceLabel {
    if (!_orderPriceLabel) {
        _orderPriceLabel = [[UILabel alloc]init];
        _orderPriceLabel.textAlignment = NSTextAlignmentCenter;
        _orderPriceLabel.font = [UIFont systemFontOfSize:24];
        _orderPriceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _orderPriceLabel.text = [NSString stringWithFormat:@"%0.2f元",[[MBUserManager manager].configInfo.vip_price floatValue]];
        [_orderPriceLabel sizeToFit];
    }
    return _orderPriceLabel;
}
/** 微信支付*/
- (UIView *)wechatPayView {
    if (!_wechatPayView) {
        _wechatPayView = [[UIView alloc]init];
        _wechatPayView.backgroundColor = [UIColor clearColor];
        [_wechatPayView addSingleTapGestureTarget:self action:@selector(choosePayType:)];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wechat_pay"]];
        [_wechatPayView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_wechatPayView.mas_centerY);
            make.left.equalTo(self->_wechatPayView.mas_left);
        }];
        UILabel *payLabel = [[UILabel alloc]init];
        payLabel.textColor = [UIColor blackColor];
        payLabel.text = @"微信支付";
        payLabel.font = [UIFont systemFontOfSize:14];
        [_wechatPayView addSubview:payLabel];
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_wechatPayView.mas_centerY);
            make.left.equalTo(icon.mas_right).offset(10);
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        [_wechatPayView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_wechatPayView);
            make.height.mas_equalTo(1);
        }];
    }
    return _wechatPayView;
}
/** 微信支付指示图片*/
- (UIImageView *)wechatIndicator {
    if (!_wechatIndicator) {
        _wechatIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_select"]];
    }
    return _wechatIndicator;
}
/** 阿里支付平台*/
- (UIView *)alipayView {
    if (!_alipayView) {
        _alipayView = [[UIView alloc]init];
        _alipayView.backgroundColor = [UIColor clearColor];
        [_alipayView addSingleTapGestureTarget:self action:@selector(choosePayType:)];
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"alipay"]];
        [_alipayView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_alipayView.mas_centerY);
            make.left.equalTo(self->_alipayView.mas_left);
        }];
        UILabel *payLabel = [[UILabel alloc]init];
        payLabel.textColor = [UIColor blackColor];
        payLabel.text = @"支付宝支付";
        payLabel.font = [UIFont systemFontOfSize:14];
        [_alipayView addSubview:payLabel];
        [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_alipayView.mas_centerY);
            make.left.equalTo(icon.mas_right).offset(10);
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        [_alipayView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_alipayView);
            make.height.mas_equalTo(1);
        }];
    }
    return _alipayView;
}
/** 支付宝指示*/
- (UIImageView *)alipayIndicator {
    if (!_alipayIndicator) {
        _alipayIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pay_normal"]];
    }
    return _alipayIndicator;
}
/** 付款按钮*/
- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setBackgroundImage:[UIImage imageNamed:@"shadow_bg"] forState:UIControlStateNormal];
        [_commitBtn setTitle:@"去付款" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commitBtn addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

@end
