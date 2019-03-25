//
//  MBCommissionTableViewCell.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/7.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBCommissionTableViewCell.h"
/** 佣金model*/
#import "MBCommossionModel.h"

@interface MBCommissionTableViewCell ()

/** 头像*/
@property (nonatomic, strong) UIImageView * headImageView;
/** 昵称*/
@property (nonatomic, strong) UILabel * nickLabel;
/** 用户ID*/
@property (nonatomic, strong) UILabel * userIdLabel;
/** 佣金*/
@property (nonatomic, strong) UILabel * commissionLabel;
/** 注册日期*/
@property (nonatomic, strong) UILabel * registerTimeLabel;
/** 分割线*/
@property (nonatomic, strong) UIView * sepLine;

@end

@implementation MBCommissionTableViewCell

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
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nickLabel];
    [self.contentView addSubview:self.commissionLabel];
    [self.contentView addSubview:self.userIdLabel];
    [self.contentView addSubview:self.registerTimeLabel];
    [self.contentView addSubview:self.sepLine];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(14));
        make.width.height.mas_equalTo(kAdapt(44));
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(kAdapt(10));
        make.top.equalTo(self.headImageView.mas_top).offset(kAdapt(2));
    }];
    [self.commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nickLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(15));
    }];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(kAdapt(10));
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(-kAdapt(2));
    }];
    [self.registerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userIdLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(15));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(14));
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(10));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark--setter---
- (void)setModel:(MBCommossionModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.from_avatar] placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
    self.nickLabel.text = model.from_nickname.length>0?model.from_nickname:@"";
    self.commissionLabel.text = [NSString stringWithFormat:@"佣金(元)：%0.2f",model.price.length>0?[model.price floatValue]:0.00];
    self.userIdLabel.text = model.from_id.length>0?model.from_id:@"";
    self.registerTimeLabel.text = model.createtime.length>0?model.createtime:@"";
}

#pragma mark--lazy--
/** 头像*/
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.backgroundColor = [UIColor blackColor];
        _headImageView.layer.cornerRadius = kAdapt(22);
    }
    return _headImageView;
}
/** 用户昵称*/
- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc]init];
        _nickLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _nickLabel.font = [UIFont systemFontOfSize:14];
        _nickLabel.textAlignment = NSTextAlignmentLeft;
        _nickLabel.text = @"没得你";
        [_nickLabel sizeToFit];
    }
    return _nickLabel;
}
/** 用户ID*/
- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc]init];
        _userIdLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _userIdLabel.font = [UIFont systemFontOfSize:11];
        _userIdLabel.textAlignment = NSTextAlignmentLeft;
        _userIdLabel.text = @"ID:123928";
        [_userIdLabel sizeToFit];
    }
    return _userIdLabel;
}
/** 佣金*/
- (UILabel *)commissionLabel {
    if (!_commissionLabel) {
        _commissionLabel = [[UILabel alloc]init];
        _commissionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _commissionLabel.font = [UIFont systemFontOfSize:14];
        _commissionLabel.textAlignment = NSTextAlignmentRight;
        _commissionLabel.text = @"佣金(元)：9.00";
        [_commissionLabel sizeToFit];
    }
    return _commissionLabel;
}
/** 注册时间*/
- (UILabel *)registerTimeLabel {
    if (!_registerTimeLabel) {
        _registerTimeLabel = [[UILabel alloc]init];
        _registerTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _registerTimeLabel.font = [UIFont systemFontOfSize:11];
        _registerTimeLabel.textAlignment = NSTextAlignmentRight;
        _registerTimeLabel.text = @"2018年10月23日 16:25";
        [_registerTimeLabel sizeToFit];
    }
    return _registerTimeLabel;
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
