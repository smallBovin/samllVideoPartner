//
//  MBOpenVipAlertView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBOpenVipAlertView.h"

@interface MBOpenVipAlertView ()

/** 提示消息*/
@property (nonatomic, strong) UILabel * msgLabel;
/** vip描述*/
@property (nonatomic, strong) UILabel * desLabel;
/** 去开通按钮*/
@property (nonatomic, strong) UILabel * openVipLabel;

@end

@implementation MBOpenVipAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerRadius:5 rectCornerType:UIRectCornerAllCorners];
        [self addSubview:self.msgLabel];
        [self addSubview:self.desLabel];
        [self addSubview:self.openVipLabel];
        [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(kAdapt(15));
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.msgLabel.mas_bottom).offset(kAdapt(16));
        }];
        [self.openVipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-kAdapt(13));
        }];
    }
    return self;
}

#pragma mark--action--
- (void)openVipService {
    if (self.openVip) {
        self.openVip();
    }
}

#pragma mark--lazy--
/** 标题*/
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:12];
        _msgLabel.textColor = [UIColor blackColor];
        _msgLabel.numberOfLines = 2;
        _msgLabel.text = @"对不起\n您还不是VIP用户";
        [_msgLabel sizeToFit];
    }
    return _msgLabel;
}
/** 描述*/
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.numberOfLines = 2;
        _desLabel.text = @"开通VIP\n全网素材随心用";
        [_desLabel sizeToFit];
    }
    return _desLabel;
}
/** 微信号*/
- (UILabel *)openVipLabel {
    if (!_openVipLabel) {
        _openVipLabel = [[UILabel alloc]init];
        _openVipLabel.textAlignment = NSTextAlignmentCenter;
        _openVipLabel.font = [UIFont systemFontOfSize:12];
        _openVipLabel.textColor = [UIColor colorWithHexString:@"#FD4539"];
        _openVipLabel.text = @"去开通>>";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_openVipLabel.text];
        [string addAttributes:@{NSUnderlineStyleAttributeName:@1} range:NSMakeRange(0, string.string.length)];
        _openVipLabel.attributedText = string;
        [_openVipLabel addSingleTapGestureTarget:self action:@selector(openVipService)];
        [_openVipLabel sizeToFit];
    }
    return _openVipLabel;
}
@end
