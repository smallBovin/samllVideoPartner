//
//  MBTeamBaseViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBTeamBaseViewController.h"
/** 团队cell*/
#import "MBTeamTableViewCell.h"
/** 团队model*/
#import "MBTeamModel.h"

@interface MBTeamBaseViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 团队列表*/
@property (nonatomic, strong) UITableView * tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;
/** 请求第几页*/
@property (nonatomic, assign) int  currentPage;


@end

@implementation MBTeamBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [self.view addSubview:self.tableView];
    [self setRefreshFunctionToScrollView:self.tableView refreshType:MBRefreshTypeBoth];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefreshing{
    self.currentPage = 1;
    [self loadMyTeamDataWithPage:self.currentPage];
}
- (void)footerRefreshing {
    self.currentPage++;
    [self loadMyTeamDataWithPage:self.currentPage];
}
- (void)loadMyTeamDataWithPage:(int)page {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    if (self.rankType == MBTeamRankFirst) {
        dict[@"level"] = @(1);
    }else if (self.rankType == MBTeamRankSecond) {
        dict[@"level"] = @(2);
    }else {
        dict[@"level"] = @(3);
    }
    [RequestUtil POST:MY_TEAM_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [self.tableView.mj_header endRefreshing];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView.mj_footer resetNoMoreData];
            }
            if ([responseObject[@"datalist"] isKindOfClass:[NSNull class]]) {
                return ;
            }
            NSInteger total = [responseObject[@"datalist"][@"total"] integerValue];
            NSMutableArray *tmp = [MBTeamModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
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
    MBTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MBTeamTableViewCell class]) forIndexPath:indexPath];
    if (self.dataArray.count>0) {
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
/** iPhone X系列底部安全区优化*/
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SAFE_INDICATOR_BAR, 0);
}

#pragma mark--lazy--
/** 团队列表*/
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
        [_tableView registerClass:[MBTeamTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MBTeamTableViewCell class])];
    }
    return _tableView;
}
/** 数据源*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
