//
//  MBPerformanceHeaderView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBPerformanceHeaderView.h"
#import "MBPerformanceModel.h"

@interface MBPerformanceHeaderView ()

/** 背景图*/
@property (nonatomic, strong) UIImageView * bgImageView;
/** 佣金金额*/
@property (nonatomic, strong) UILabel * commissionLabel;
/** 代理人数*/
@property (nonatomic, strong) UILabel * agencyCountLabel;
/** 可提现金额*/
@property (nonatomic, strong) UILabel * canWithdrawLabel;
/** 提现按钮*/
@property (nonatomic, strong) UIButton * withdrawBtn;

@end

@implementation MBPerformanceHeaderView

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
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.commissionLabel];
    [self.bgImageView addSubview:self.agencyCountLabel];
    [self addSubview:self.canWithdrawLabel];
    [self addSubview:self.withdrawBtn];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kAdapt(160)+STATUS_BAR_HEIGHT);
    }];
    [self.commissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(kAdapt(20));
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-kAdapt(20));
        make.right.equalTo(self.bgImageView.mas_centerX);
    }];
    [self.agencyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-kAdapt(20));
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-kAdapt(20));
        make.left.equalTo(self.bgImageView.mas_centerX);
    }];
    [self.canWithdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom);
        make.left.equalTo(self.mas_left).offset(kAdapt(19));
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.canWithdrawLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-kAdapt(20));
        make.width.mas_equalTo(kAdapt(56));
        make.height.mas_equalTo(kAdapt(25));
    }];
}

#pragma mark--setter--
- (void)setHeaderType:(MBPerformanceType)headerType {
    _headerType = headerType;
    if (headerType == MBPerformanceTypeDistribution) {
        self.agencyCountLabel.font = [self mb_blodSystemFontSize:12];
    }
}
- (void)setModel:(MBPerformanceModel *)model {
    _model = model;
    NSString *total = model.total.length>0?model.total:@"0";
    self.commissionLabel.text = [NSString stringWithFormat:@"佣金金额(元)\n%0.2f",[total floatValue]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.commissionLabel.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = 10;
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.6],NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style} range:[attr.string rangeOfString:@"佣金金额(元)"]];
    self.commissionLabel.attributedText = attr;
    
    if (self.headerType == MBPerformanceTypeAgency) {
        NSString *agencyAddress = [NSString stringWithFormat:@"会员人数(%@%@)",model.agent_province.length>0?model.agent_province:@"",model.agent_city.length>0?model.agent_city:@""];
        NSString *agencyUser = [model.agent_user intValue]>0?model.agent_user:@"0";
        self.agencyCountLabel.text = [NSString stringWithFormat:@"%@\n%d",agencyAddress,[agencyUser intValue]];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:_agencyCountLabel.text];
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc]init];
        style1.alignment = NSTextAlignmentRight;
        style1.lineSpacing = 10;
        [attr1 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.6],NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style1} range:[attr1.string rangeOfString:agencyAddress]];
        _agencyCountLabel.attributedText = attr1;
    }else {
        NSString *disTitle = model.dis_level.length>0?model.dis_level:@"VIP会员分销";
        int dis_total = [model.dis_total intValue]>0?[model.dis_total intValue]:0;
        int dis_out = [model.dis_out intValue]>0?[model.dis_out intValue]:0;
        self.agencyCountLabel.text = [NSString stringWithFormat:@"%@\n代理总名额：%d\n已用名额：%d\n可用名额：%d",disTitle,dis_total,dis_out,(dis_total-dis_out)];
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:_agencyCountLabel.text];
        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc]init];
        style1.alignment = NSTextAlignmentRight;
        style1.lineSpacing = 10;
        [attr1 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.6],NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style1} range:[attr1.string rangeOfString:disTitle]];
        _agencyCountLabel.attributedText = attr1;
    }
    
    self.canWithdrawLabel.text = [NSString stringWithFormat:@"可提现余额(元) %0.2f",[model.balance.length>0?model.balance:@"0" floatValue]];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc]initWithString:_canWithdrawLabel.text];
    [attr2 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#707070"],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[attr2.string rangeOfString:@"可提现余额(元)"]];
    _canWithdrawLabel.attributedText = attr2;
}


#pragma mark--action--
/** 提现*/
- (void)withdrawMyCommission {
    if (self.withdrawAction) {
        self.withdrawAction();
    }
}

- (UIFont *)mb_blodSystemFontSize:(CGFloat)size {
    CGFloat fontSize;
    if (SCREEN_WIDTH < 375.0) {
        fontSize = (size-2);
    }else if (SCREEN_WIDTH == 375.0){
        fontSize = size;
    }else{
        fontSize = (size+1);
    }
    return [UIFont boldSystemFontOfSize:fontSize];
}

#pragma mark--lazy--
/** 背景图*/
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_agency_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bgImageView;
}
/** 佣金总额*/
- (UILabel *)commissionLabel {
    if (!_commissionLabel) {
        _commissionLabel = [[UILabel alloc]init];
        _commissionLabel.textColor = [UIColor whiteColor];
        _commissionLabel.font = [self mb_blodSystemFontSize:33];
        _commissionLabel.textAlignment = NSTextAlignmentLeft;
        _commissionLabel.numberOfLines = 0;
        _commissionLabel.text = @"佣金金额(元)\n0.00";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_commissionLabel.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.alignment = NSTextAlignmentLeft;
        style.lineSpacing = 10;
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.6],NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style} range:[attr.string rangeOfString:@"佣金金额(元)"]];
        _commissionLabel.attributedText = attr;
    }
    return _commissionLabel;
}
/** 代理人数*/
- (UILabel *)agencyCountLabel {
    if (!_agencyCountLabel) {
        _agencyCountLabel = [[UILabel alloc]init];
        _agencyCountLabel.textColor = [UIColor whiteColor];
        _agencyCountLabel.font = [self mb_blodSystemFontSize:33];
        _agencyCountLabel.textAlignment = NSTextAlignmentRight;
        _agencyCountLabel.numberOfLines = 0;
        _agencyCountLabel.text = @"会员人数(浙江杭州)\n0";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_agencyCountLabel.text];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        style.alignment = NSTextAlignmentRight;
        style.lineSpacing = 10;
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.6],NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style} range:[attr.string rangeOfString:@"会员人数(浙江杭州)"]];
        _agencyCountLabel.attributedText = attr;
    }
    return _agencyCountLabel;
}
/** 可提现金额*/
- (UILabel *)canWithdrawLabel {
    if (!_canWithdrawLabel) {
        _canWithdrawLabel = [[UILabel alloc]init];
        _canWithdrawLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _canWithdrawLabel.font = [self mb_blodSystemFontSize:20];
        _canWithdrawLabel.textAlignment = NSTextAlignmentLeft;
        _canWithdrawLabel.text = @"可提现余额(元) 0.00";
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_canWithdrawLabel.text];
        [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#707070"],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[attr.string rangeOfString:@"可提现余额(元)"]];
        _canWithdrawLabel.attributedText = attr;
    }
    return _canWithdrawLabel;
}
/** 提现*/
- (UIButton *)withdrawBtn {
    if (!_withdrawBtn) {
        _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:[UIColor colorWithHexString:@"#FB4939"] forState:UIControlStateNormal];
        _withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _withdrawBtn.layer.cornerRadius = kAdapt(13);
        _withdrawBtn.layer.masksToBounds = YES;
        _withdrawBtn.cs_borderColor = [UIColor colorWithHexString:@"#FB4939"];
        _withdrawBtn.cs_borderWidth = 1;
        [_withdrawBtn addTarget:self action:@selector(withdrawMyCommission) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawBtn;
}
@end
