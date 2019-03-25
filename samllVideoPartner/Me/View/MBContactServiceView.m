//
//  MBContactServiceView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBContactServiceView.h"

@interface MBContactServiceView ()

/** 标题*/
@property (nonatomic, strong) UILabel * titleLabel;
/** 详细描述*/
@property (nonatomic, strong) UILabel * desLabel;
/** 客服微信*/
@property (nonatomic, strong) UILabel * wechatLabel;
/** 二维码*/
@property (nonatomic, strong) UIImageView * rcCodeImg;
/** 客服电话*/
@property (nonatomic, strong) UILabel * servicePhoneLabel;

@end

@implementation MBContactServiceView

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
    [self addSubview:self.titleLabel];
    [self addSubview:self.desLabel];
    [self addSubview:self.wechatLabel];
    [self addSubview:self.rcCodeImg];
    [self addSubview:self.servicePhoneLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(14));
        make.left.equalTo(self.mas_left).offset(kAdapt(30));
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kAdapt(10));
    }];
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.desLabel.mas_bottom).offset(kAdapt(30));
    }];
    [self.rcCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.wechatLabel.mas_bottom).offset(kAdapt(15));
        make.width.height.mas_equalTo(kAdapt(140));
    }];
    [self.servicePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-kAdapt(15));
    }];
    
}

- (void)contactService:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    CGPoint point = [tap locationInView:self.servicePhoneLabel];
    CGRect phoneRect = [label boundingRectForCharacterRange:[self.servicePhoneLabel.text rangeOfString:[MBUserManager manager].configInfo.phone]];
   
    if (CGRectContainsPoint(phoneRect, point)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[MBUserManager manager].configInfo.phone]];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        });
    }
}


#pragma mark--lazy--
/** 标题*/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = @"联系客服";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
/** 描述*/
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _desLabel.text = @"请直接拨打客服电话或者添加客服微信咨询";
        [_desLabel sizeToFit];
    }
    return _desLabel;
}
/** 微信号*/
- (UILabel *)wechatLabel {
    if (!_wechatLabel) {
        _wechatLabel = [[UILabel alloc]init];
        _wechatLabel.textAlignment = NSTextAlignmentCenter;
        _wechatLabel.font = [UIFont systemFontOfSize:14];
        _wechatLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        NSString *wechat = [MBUserManager manager].configInfo.wx.length>0?[MBUserManager manager].configInfo.wx:@"";
        _wechatLabel.text = [NSString stringWithFormat:@"客服微信:%@",wechat];
        [_wechatLabel sizeToFit];
    }
    return _wechatLabel;
}
/** 二维码*/
- (UIImageView *)rcCodeImg {
    if (!_rcCodeImg) {
        _rcCodeImg = [[UIImageView alloc]init];
        NSString *url = [MBUserManager manager].configInfo.qrcode.length>0?[MBUserManager manager].configInfo.qrcode:@"";
        if (![url containsString:@"http"]) {
            url = [NSString stringWithFormat:@"%@%@",[MBUserManager manager].configInfo.img_prefix,url];
        }
        NSString *qrCodeUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_rcCodeImg sd_setImageWithURL:[NSURL URLWithString:qrCodeUrl] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    }
    return _rcCodeImg;
}
/** 客服手机*/
- (UILabel *)servicePhoneLabel {
    if (!_servicePhoneLabel) {
        _servicePhoneLabel = [[UILabel alloc]init];
        _servicePhoneLabel.textAlignment = NSTextAlignmentCenter;
        _servicePhoneLabel.font = [UIFont systemFontOfSize:14];
        _servicePhoneLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _servicePhoneLabel.text = [NSString stringWithFormat:@"客服电话:%@",[MBUserManager manager].configInfo.phone];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_servicePhoneLabel.text];
        NSString *mobile = [MBUserManager manager].configInfo.phone.length>0?[MBUserManager manager].configInfo.phone:@"";
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FA3C3C"],NSUnderlineStyleAttributeName:@1} range:[string.string rangeOfString:mobile]];
        _servicePhoneLabel.attributedText = string;
        [_servicePhoneLabel addSingleTapGestureTarget:self action:@selector(contactService:)];
        [_servicePhoneLabel sizeToFit];
    }
    return _servicePhoneLabel;
}
@end
