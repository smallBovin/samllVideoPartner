//
//  MBMeTableViewCell.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBMeTableViewCell.h"

@interface MBMeTableViewCell ()
/** icon*/
@property (nonatomic, strong) UIImageView * iconImageView;
/** 类型*/
@property (nonatomic, strong) UILabel * typeLabel;
/** 描述*/
@property (nonatomic, strong) UILabel * desLabel;
/** 向右的箭头*/
@property (nonatomic, strong) UIImageView * rightArrow;
/** 分割线*/
@property (nonatomic, strong) UIView * sepLine;

@end

@implementation MBMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.rightArrow];
    [self.contentView addSubview:self.sepLine];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(20));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(kAdapt(12));
    }];
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kAdapt(20));
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightArrow.mas_left).offset(-kAdapt(6));
    }];
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(kAdapt(22));
        make.height.mas_equalTo(1);
    }];
}

#pragma mark--setter---
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.typeLabel.text = [dict objectForKey:@"title"];
    self.iconImageView.image = [UIImage imageNamed:[dict objectForKey:@"icon"]];
}
- (void)setDescString:(NSString *)descString {
    _descString = descString;
    if (descString.length) {
        self.desLabel.text = descString;
    }
}

#pragma mark--lazy--
/** cion图片*/
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
/** 类型*/
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc]init];
        _typeLabel.textColor = [UIColor colorWithHexString:@"#232323"];
        _typeLabel.font = [UIFont systemFontOfSize:16];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [_typeLabel sizeToFit];
    }
    return _typeLabel;
}
/** 描述*/
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc]init];
        _desLabel.textColor = [UIColor colorWithHexString:@"#232323"];
        _desLabel.font = [UIFont systemFontOfSize:13];
        _desLabel.textAlignment = NSTextAlignmentRight;
        [_desLabel sizeToFit];
    }
    return _desLabel;
}
/** 向右的箭头*/
- (UIImageView *)rightArrow {
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_right_arrow"]];
    }
    return _rightArrow;
}
/** 分割线*/
- (UIView *)sepLine {
    if (!_sepLine) {
        _sepLine = [[UIView alloc]init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    }
    return _sepLine;
}
@end
