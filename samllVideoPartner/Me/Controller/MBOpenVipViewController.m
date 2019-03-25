//
//  MBOpenVipViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBOpenVipViewController.h"

/** 支付弹框*/
#import "MBVipPayAlertView.h"

@interface MBOpenVipViewController ()

/** vip*/
@property (nonatomic, strong) UIImageView * vipImageView;
/** vip会员*/
@property (nonatomic, strong) UILabel * vipLabel;
/** 到期时间*/
@property (nonatomic, strong) UILabel * expirateLabel;
/** 会员价格*/
@property (nonatomic, strong) UILabel * vipPriceLabel;
/** vip 服务介绍*/
@property (nonatomic, strong) UIView * containerView;
/** 开通vip按钮*/
@property (nonatomic, strong) UIButton * openVipBtn;
/** vip 特权数组*/
@property (nonatomic, strong) NSArray * vipRightArray;

@end

static NSString *const MBVIPRightIcon = @"MBVIPRight_Icon";
static NSString *const MBVIPRightName = @"MBVIPRight_Name";

@implementation MBOpenVipViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"VIP会员";
    self.vipRightArray = @[@{MBVIPRightIcon:@"vip_bg_image",MBVIPRightName:@"海量背景，任你选择"},@{MBVIPRightIcon:@"vip_tags",MBVIPRightName:@"多种贴图，彰显个性"},@{MBVIPRightIcon:@"vip_music",MBVIPRightName:@"全网音乐，随心剪辑"},@{MBVIPRightIcon:@"vip_fonts",MBVIPRightName:@"字体变化，其乐无穷"}];
    [self setupSubviews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatPayResponseHander:) name:MBWechatPayResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipayResponseHandler:) name:MBAlipayResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoAndVipInfoRefreshComplete) name:kUserInfoUpdateCompleteNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
    if ([[MBUserManager manager]isVip]) {
        [self.openVipBtn setTitle:@"立即续费" forState:UIControlStateNormal];
    }else {
        [self.openVipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
    }
}

- (void)setupSubviews {
    [self.view addSubview:self.vipImageView];
    [self.vipImageView addSubview:self.vipLabel];
//    [self.vipImageView addSubview:self.expirateLabel];
    [self.vipImageView addSubview:self.vipPriceLabel];
    [self.view addSubview:self.containerView];
    [self.view addSubview:self.openVipBtn];
    [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(NAVIGATION_BAR_HEIGHT+kAdapt(30));
        make.width.mas_equalTo(kAdapt(284));
        make.height.mas_equalTo(kAdapt(175));
    }];
    [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipImageView.mas_left).offset(kAdapt(27));
        make.top.equalTo(self.vipImageView.mas_top).offset(kAdapt(15));
    }];
//    [self.expirateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.vipLabel.mas_left);
//        make.top.equalTo(self.vipLabel.mas_bottom).offset(kAdapt(7));
//    }];
    [self.vipPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipImageView.mas_right).offset(-kAdapt(23));
        make.bottom.equalTo(self.vipImageView.mas_bottom).offset(-kAdapt(40));
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.vipImageView.mas_bottom).offset(kAdapt(40));
        make.height.mas_equalTo(kAdapt(220));
    }];
    [self.openVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.left.equalTo(self.view.mas_left).offset(kAdapt(40));
        make.right.equalTo(self.view.mas_right).offset(-kAdapt(40));
        make.height.mas_equalTo(kAdapt(47));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kAdapt(20)-SAFE_INDICATOR_BAR);
    }];
}

#pragma mark--开通成功回调--
- (void)wechatPayResponseHander:(NSNotification *)noti {
    NSString *code = (NSString *)noti.object;
    if ([code isEqualToString:@"0"]) { //支付成功
        [MBProgressHUD showSuccessAlertWithIcon:@"success_pay" message:@"支付成功"];
        //更新用户信息
        [[MBUserManager manager]loadOrUpdateUserInfo];
        
    }else if ([code isEqualToString:@"-2"]) {
        [MBProgressHUD showOnlyTextMessage:@"取消支付"];
    }else {
        [MBProgressHUD showOnlyTextMessage:@"支付出错"];
    }
}

- (void)alipayResponseHandler:(NSNotification *)noti {
    NSDictionary *dic = (NSDictionary *)noti.object;
    if ([dic[@"resultStatus"] isEqualToString:@"9000"]) {
        [MBProgressHUD showSuccessAlertWithIcon:@"success_pay" message:@"支付成功"];
        //更新用户信息
        [[MBUserManager manager]loadOrUpdateUserInfo];
    }else {
        [MBProgressHUD showOnlyTextMessage:@"支付失败"];
    }
}

#pragma mark--用户开通VIP后信息刷新完成回调--
- (void)userInfoAndVipInfoRefreshComplete {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark--开通VIP--
- (void)openVip {
    MBVipPayAlertView *payView = [[MBVipPayAlertView alloc]initWithFrame:CGRectMake(0, 0, 270, 288)];
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:payView preferredStyle:TYAlertControllerStyleAlert];
    __weak typeof(alert) weakAlert = alert;
    payView.payBlock = ^(MBPayType payType) {
        [weakAlert dismissViewControllerAnimated:YES];
        if (payType == MBPayTypeWecahtPay) {
            [[MBWechatApiManager shareManager]openVipWithWechatPay];
        }else {
            [[MBWechatApiManager shareManager]openVipWithAlipay];
        }
    };
    alert.backgoundTapDismissEnable = YES;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark--lazy---
/** vip*/
- (UIImageView *)vipImageView {
    if (!_vipImageView) {
        _vipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_vip_bgimg"]];
    }
    return _vipImageView;
}
/** vip label*/
- (UILabel *)vipLabel {
    if (!_vipLabel) {
        _vipLabel = [[UILabel alloc]init];
        _vipLabel.textAlignment = NSTextAlignmentLeft;
        _vipLabel.font = [UIFont systemFontOfSize:16];
        _vipLabel.textColor = [UIColor whiteColor];
        _vipLabel.text = @"VIP会员";
        [_vipLabel sizeToFit];
    }
    return _vipLabel;
}
/** 会员到期时间*/
- (UILabel *)expirateLabel {
    if (!_expirateLabel) {
        _expirateLabel = [[UILabel alloc]init];
        _expirateLabel.textAlignment = NSTextAlignmentLeft;
        _expirateLabel.font = [UIFont systemFontOfSize:11];
        _expirateLabel.textColor = [UIColor whiteColor];
        _expirateLabel.text = @"到期时间: 2019-10-10";
        [_expirateLabel sizeToFit];
    }
    return _expirateLabel;
}
/** 会员价格*/
- (UILabel *)vipPriceLabel {
    if (!_vipPriceLabel) {
        _vipPriceLabel = [[UILabel alloc]init];
        _vipPriceLabel.textAlignment = NSTextAlignmentRight;
        _vipPriceLabel.font = [UIFont systemFontOfSize:20];
        _vipPriceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _vipPriceLabel.text = [NSString stringWithFormat:@"%0.2f元/年",[[MBUserManager manager].configInfo.vip_price floatValue]];
        [_vipPriceLabel sizeToFit];
    }
    return _vipPriceLabel;
}
/** vip 特权介绍*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]init];
        CGFloat width = SCREEN_WIDTH/2;
        CGFloat height = kAdapt(90);
        CGFloat margin = kAdapt(30);
        for (int i = 0; i<self.vipRightArray.count; i++) {
            NSDictionary *dic = self.vipRightArray[i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width*(i%2), (height+margin)*(i/2), width, height);
            [button setImage:[UIImage imageNamed:[dic objectForKey:MBVIPRightIcon]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[dic objectForKey:MBVIPRightIcon]] forState:UIControlStateHighlighted];
            [button setTitle:[dic objectForKey:MBVIPRightName] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.spaceMargin = 10;
            button.type = MBButtonTypeTopImageBottomTitle;
            [_containerView addSubview:button];
        }
    }
    return _containerView;
}
/** 开通按钮*/
- (UIButton *)openVipBtn {
    if (!_openVipBtn) {
        _openVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openVipBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#FA3C3C"]] forState:UIControlStateNormal];
        if ([[MBUserManager manager]isVip]) {
            [_openVipBtn setTitle:@"立即续费" forState:UIControlStateNormal];
        }else {
            [_openVipBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        }
        [_openVipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _openVipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _openVipBtn.layer.cornerRadius = 8;
        _openVipBtn.layer.masksToBounds = YES;
        [_openVipBtn addTarget:self action:@selector(openVip) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openVipBtn;
}

#pragma mark--dealloc---
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MBWechatPayResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MBAlipayResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kUserInfoUpdateCompleteNotification object:nil];
}
@end
