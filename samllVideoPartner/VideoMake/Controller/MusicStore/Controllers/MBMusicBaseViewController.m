//
//  MBMusicBaseViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicBaseViewController.h"
#import "MBMusicTableViewCell.h"
/** 数据逻辑处理类*/
#import "MBMusicStoreViewModel.h"
/** 贴图，背景图，音乐列表通用model*/
#import "MBMapsModel.h"

@interface MBMusicBaseViewController ()<UITableViewDataSource,UITableViewDelegate>

/** 音乐列表*/
@property (nonatomic, strong) UITableView * musicTableView;
/** viewModel*/
@property (nonatomic, strong) MBMusicStoreViewModel * musicViewModel;
/** 加载第几页数据*/
@property (nonatomic, assign) int  currentPage;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MBMusicBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.musicTableView];
    [self setRefreshFunctionToScrollView:self.musicTableView refreshType:MBRefreshTypeBoth];
    self.musicViewModel = [[MBMusicStoreViewModel alloc]init];
    [[MBMusicStoreViewModel shareInstance]registerViewModelToController:self];;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[MBMusicStoreViewModel shareInstance]currentVisiableTableView:self.musicTableView];
    [self.musicTableView.mj_header beginRefreshing];
}

- (void)headerRefreshing {
    self.currentPage = 1;
    [self requestMusicDataWithPage:self.currentPage];
}

- (void)footerRefreshing {
    self.currentPage++;
    [self requestMusicDataWithPage:self.currentPage];
}

- (void)requestMusicDataWithPage:(int)page {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"type"] = @(4);
    dict[@"cid"] = @(self.musicStyle);
    dict[@"page"] = @(page);
    
    [RequestUtil POST:VIDEO_EDITING_MATERIALS_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [self.musicTableView.mj_header endRefreshing];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
                [self.musicTableView.mj_footer resetNoMoreData];
            }
            NSInteger total = [responseObject[@"datalist"][@"total"] integerValue];
            NSMutableArray *tmp = [MBMapsModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            [self.dataArray addObjectsFromArray:tmp];
            if (total == self.dataArray.count) {
                [self.musicTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.musicTableView.mj_footer endRefreshing];
            }
            [self.musicTableView reloadData];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.currentPage>1) {
            self.currentPage--;
        }
    }];
}


#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MBMusicTableViewCell class]) forIndexPath:indexPath];
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
    MBMapsModel *model = self.dataArray[indexPath.row];
    if ([MBUserManager manager].isUnderReview) {
        [[MBMusicStoreViewModel shareInstance]downloadMusicTableView:tableView withModel:model];
    }else {
        if ([model.author isEqualToString:@"1"] &&![[MBUserManager manager]isVip]) {
            Class class = NSClassFromString(@"MBOpenVipViewController");
            [self.navigationController pushViewController:[class new] animated:YES];
        }else {
            [[MBMusicStoreViewModel shareInstance]downloadMusicTableView:tableView withModel:model];
        }
    }
}

#pragma mark--lazy--
/** 音乐列表*/
- (UITableView *)musicTableView {
    if (!_musicTableView) {
        _musicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-108) style:UITableViewStylePlain];
        _musicTableView.dataSource = self;
        _musicTableView.delegate = self;
        _musicTableView.estimatedRowHeight = 0;
        _musicTableView.estimatedSectionFooterHeight = 0;
        _musicTableView.estimatedSectionHeaderHeight = 0;
        _musicTableView.rowHeight = 60;
        _musicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_musicTableView registerClass:[MBMusicTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MBMusicTableViewCell class])];
    }
    return _musicTableView;
}
/** 数据源*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
