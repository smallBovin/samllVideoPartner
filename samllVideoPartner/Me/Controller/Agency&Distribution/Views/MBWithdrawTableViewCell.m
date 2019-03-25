//
//  MBWithdrawTableViewCell.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBWithdrawTableViewCell.h"
#import "MBWithdrawModel.h"

@interface MBWithdrawTableViewCell ()

/** 提现金额*/
@property (nonatomic, strong) UILabel * withdrawLabel;
/** 提现日期*/
@property (nonatomic, strong) UILabel * timeLabel;
/** 手续费*/
@property (nonatomic, strong) UILabel * serviceChargeLabel;
/** 提现状态*/
@property (nonatomic, strong) UILabel * statusLabel;
/** 分割线*/
@property (nonatomic, strong) UIView * sepLine;

@end

@implementation MBWithdrawTableViewCell

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
    [self.contentView addSubview:self.withdrawLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.serviceChargeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.sepLine];
    [self.withdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kAdapt(15));
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(14));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.withdrawLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(13));
    }];
    [self.serviceChargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(14));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kAdapt(12));
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.serviceChargeLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(13));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(14));
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark--setter---
- (void)setModel:(MBWithdrawModel *)model {
    _model = model;
    self.withdrawLabel.text = [NSString stringWithFormat:@"-%0.2f",model.price.length>0?[model.price floatValue]:0.00];
    self.timeLabel.text = model.apply_time.length>0?model.apply_time:@"";
    self.serviceChargeLabel.text = [NSString stringWithFormat:@"手续费：%0.2f元,实际到账：%0.2f元",model.poundage.length>0?[model.poundage floatValue]:0.00,model.money.length>0?[model.money floatValue]:0.00];
    self.statusLabel.text = model.status.length>0?model.status:@"";
    if ([model.status isEqualToString:@"待打款"]) {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#F19439"];
    }else if ([model.status isEqualToString:@"已拒绝"]) {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#FF0000"];
    }else if ([model.status isEqualToString:@"已驳回"]) {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#770FB3"];
    }else {
        self.statusLabel.textColor = [UIColor colorWithHexString:@"#1F42DB"];
    }
}


#pragma mark--lazy--
/** 提现金额*/
- (UILabel *)withdrawLabel {
    if (!_withdrawLabel) {
        _withdrawLabel = [[UILabel alloc]init];
        _withdrawLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _withdrawLabel.font = [UIFont systemFontOfSize:18];
        _withdrawLabel.textAlignment = NSTextAlignmentLeft;
        _withdrawLabel.text = @"-2548.00";
        [_withdrawLabel sizeToFit];
    }
    return _withdrawLabel;
}
/** 提现日期*/
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.text = @"2018年10月23日 16:25";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}
/** 提现手续费*/
- (UILabel *)serviceChargeLabel {
    if (!_serviceChargeLabel) {
        _serviceChargeLabel = [[UILabel alloc]init];
        _serviceChargeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _serviceChargeLabel.font = [UIFont systemFontOfSize:11];
        _serviceChargeLabel.textAlignment = NSTextAlignmentLeft;
        _serviceChargeLabel.text = @"手续费：2.50元。实际到账：2545.50元";
    }
    return _serviceChargeLabel;
}
/** 提现状态*/
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc]init];
        _statusLabel.textColor = [UIColor colorWithHexString:@"#F19439"];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.text = @"待打款";
    }
    return _statusLabel;
}
/** 分割线*/
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }
    return _sepLine;
}

@end
