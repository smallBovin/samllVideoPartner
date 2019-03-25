//
//  MBWithdrawBaseViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBWithdrawBaseViewController.h"
/** 提现状态cell*/
#import "MBWithdrawTableViewCell.h"
/** 提现model*/
#import "MBWithdrawModel.h"

@interface MBWithdrawBaseViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 提现列表*/
@property (nonatomic, strong) UITableView * tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;
/** 请求第几页*/
@property (nonatomic, assign) int  currentPage;

@end

@implementation MBWithdrawBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setRefreshFunctionToScrollView:self.tableView refreshType:MBRefreshTypeBoth];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefreshing{
    self.currentPage = 1;
    [self loadWithdrawDataWithPage:self.currentPage];
}
- (void)footerRefreshing {
    self.currentPage++;
    [self loadWithdrawDataWithPage:self.currentPage];
}
- (void)loadWithdrawDataWithPage:(int)page {
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
    dict[@"page"] = @(self.currentPage);
    dict[@"status"] = @(self.status);
    [RequestUtil POST:APPLY_LIST_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [self.tableView.mj_header endRefreshing];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_footer resetNoMoreData];
            }
            NSInteger total = [responseObject[@"datalist"][@"total"] integerValue];
            NSMutableArray *tmp = [MBWithdrawModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            [self.dataArray addObjectsFromArray:tmp];
            if (total == self.dataArray.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.currentPage>1) {
            self.currentPage--;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBWithdrawTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MBWithdrawTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark--UITableViewDelegate---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SAFE_INDICATOR_BAR, 0);
}

#pragma mark--lazy--
/** 提现列表*/
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-57) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = kAdapt(69);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MBWithdrawTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MBWithdrawTableViewCell class])];
    }
    return _tableView;
}
/** 加载数组*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
