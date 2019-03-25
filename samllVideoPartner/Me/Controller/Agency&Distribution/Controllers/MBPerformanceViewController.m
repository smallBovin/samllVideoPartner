//
//  MBPerformanceViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBPerformanceViewController.h"
/** 功能cell（暂时共用我的中cell，有需求自行更改）*/
#import "MBMeTableViewCell.h"
/** 区头*/
#import "MBPerformanceHeaderView.h"
/** 申请提现*/
#import "MBApplyWithdrawViewController.h"
/** 我的团队*/
#import "MBMyTeamViewController.h"
/** 佣金明细*/
#import "MBCommissionViewController.h"
/** 提现明细*/
#import "MBWithdrawViewController.h"
/** 用户的余额model*/
#import "MBPerformanceModel.h"

@interface MBPerformanceViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 表*/
@property (nonatomic, strong) UITableView * tableView;
/** 分类数组*/
@property (nonatomic, strong) NSArray * dataArray;
/** 表头*/
@property (nonatomic, strong) MBPerformanceHeaderView * headerView;
/** 界面的数据*/
@property (nonatomic, strong) MBPerformanceModel * performamceModel;

@end

@implementation MBPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (MBPerformanceTypeDistribution == self.type) { //分销中心
        self.title = @"分销中心";
        self.dataArray = @[@{@"icon":@"my_team",@"title":@"我的团队"},@{@"icon":@"commission_detail",@"title":@"佣金明细"},@{@"icon":@"withdraw_detail",@"title":@"提现明细"}];
    }else {     //代理中心
        self.title = @"代理中心";
        self.dataArray = @[@{@"icon":@"commission_detail",@"title":@"佣金明细"},@{@"icon":@"withdraw_detail",@"title":@"提现明细"}];
    }
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleClear];
    /** 请求数据*/
    [self loadAgencyOrDistributionData];
}

- (void)loadAgencyOrDistributionData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    if (self.type == MBPerformanceTypeDistribution) {
        dict[@"type"] = @(1);
    }else {
        dict[@"type"] = @(2);
    }
    [RequestUtil POST:AGENCY_CENTER_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            self.performamceModel = [MBPerformanceModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.headerView.model = self.performamceModel;
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MBMeTableViewCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.dict = dic;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIImageView alloc]initWithImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
}

#pragma mark--UITableViewDelegate---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    [self handlerActionWithCellIndexPath:indexPath];
}
- (void)handlerActionWithCellIndexPath:(NSIndexPath *)indexPath  {
    switch (indexPath.row) {
        case 0:
            if (MBPerformanceTypeDistribution == self.type) {
                [self checkMyTeamInformation];
            }else {
                [self commisstionDetailInformation:self.type];
            }
            break;
        case 1:
            if (MBPerformanceTypeDistribution == self.type) {
                [self commisstionDetailInformation:self.type];
            }else {
                [self withdrawDetailInformation:self.type];
            }
            break;
        case 2:
            if (MBPerformanceTypeDistribution == self.type) {
                [self withdrawDetailInformation:self.type];
            }
            break;
            
        default:
            break;
    }
}
/** 我的团队*/
- (void)checkMyTeamInformation {
    MBMyTeamViewController *teamVC = [MBMyTeamViewController new];
    [self.navigationController pushViewController:teamVC animated:YES];
}
/** 佣金明细*/
- (void)commisstionDetailInformation:(MBPerformanceType)type {
    MBCommissionViewController *commissionVC = [MBCommissionViewController new];
    commissionVC.type = type;
    [self.navigationController pushViewController:commissionVC animated:YES];
}
/** 提现明细*/
- (void)withdrawDetailInformation:(MBPerformanceType)type {
    MBWithdrawViewController *withdrawVC = [MBWithdrawViewController new];
    withdrawVC.type = type;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

#pragma mark--lazy---
/** 列表*/
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = kAdapt(55);
        _tableView.sectionHeaderHeight = kAdapt(10);
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MBMeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MBMeTableViewCell class])];
    }
    return _tableView;
}
/** 表头*/
- (MBPerformanceHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MBPerformanceHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_BAR_HEIGHT+kAdapt(220))];
        _headerView.headerType = self.type;
        __weak typeof(self) weakSelf = self;
        _headerView.withdrawAction = ^{
            if (weakSelf.type == MBPerformanceTypeDistribution) {
                if ([self.performamceModel.balance floatValue]< [[MBUserManager manager].configInfo.dis_requirement floatValue]) {
                    [MBProgressHUD showOnlyTextMessage:[NSString stringWithFormat:@"可提现金额超过%@,才能提现",[MBUserManager manager].configInfo.dis_requirement]];
                    return;
                }
            }else {
                if ([self.performamceModel.balance floatValue]< [[MBUserManager manager].configInfo.agent_requirement floatValue]) {
                    [MBProgressHUD showOnlyTextMessage:[NSString stringWithFormat:@"可提现金额超过%@,才能提现",[MBUserManager manager].configInfo.agent_requirement]];                    return;
                }
            }
            MBApplyWithdrawViewController *applyVC = [MBApplyWithdrawViewController new];
            applyVC.type = weakSelf.type;
            applyVC.canWithdrawMoney = weakSelf.performamceModel.balance;
            [weakSelf.navigationController pushViewController:applyVC animated:YES];
        };
    }
    return _headerView;
}
@end
