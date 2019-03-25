//
//  MBSearchMusicViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/2/14.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBSearchMusicViewController.h"
#import "MBMusicTableViewCell.h"
/** 数据逻辑处理类*/
#import "MBMusicStoreViewModel.h"
/** 贴图，背景图，音乐列表通用model*/
#import "MBMapsModel.h"

@interface MBSearchMusicViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

/** 搜索框*/
@property (nonatomic, strong) UIView * searchBarView;
/** 输入框*/
@property (nonatomic, strong) UITextField * searchTF;
/** 音乐搜索列表*/
@property (nonatomic, strong) UITableView * musicTableView;
/** 加载第几页数据*/
@property (nonatomic, assign) int  currentPage;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;
/** viewModel*/
@property (nonatomic, strong) MBMusicStoreViewModel * musicViewModel;

@end

@implementation MBSearchMusicViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    self.title = @"音乐库";
    [self setupSubviews];
    
    self.musicViewModel = [[MBMusicStoreViewModel alloc]init];
    [[MBMusicStoreViewModel shareInstance]registerViewModelToController:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}

- (void)setupSubviews {
    
    [self.view addSubview:self.searchBarView];
    [self.searchBarView addSubview:self.searchTF];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame), SCREEN_WIDTH, 10)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:sepLine];
    [self.view addSubview:self.musicTableView];
    [self setRefreshFunctionToScrollView:self.musicTableView refreshType:MBRefreshTypeOnlyFooter];
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
    dict[@"title"] = self.searchTF.text.length>0?self.searchTF.text:@"";
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


#pragma mark--UITextFieldDelegate---
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.currentPage = 1;
    [self requestMusicDataWithPage:self.currentPage];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTF resignFirstResponder];
    return YES;
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


#pragma mark--lazy------
/** 搜索按钮*/
- (UIView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 60)];
        _searchBarView.backgroundColor = [UIColor whiteColor];
    }
    return _searchBarView;
}
/** 输入框*/
- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc]initWithFrame:CGRectMake(kAdapt(23), 10, kAdapt(330), 40)];
        _searchTF.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
        _searchTF.textColor = [UIColor blackColor];
        _searchTF.textAlignment = NSTextAlignmentLeft;
        _searchTF.tintColor = [UIColor colorWithHexString:@"#FF0000"];
        _searchTF.placeholder = @"请输入音乐名称";
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAdapt(30), 40-kAdapt(10))];
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
        searchIcon.center = CGPointMake(leftView.center.x+kAdapt(5), leftView.center.y);
        [leftView addSubview:searchIcon];
        _searchTF.leftView = leftView;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.layer.cornerRadius = 20;
        _searchTF.layer.masksToBounds = YES;
    }
    return _searchTF;
}
/** 音乐列表*/
- (UITableView *)musicTableView {
    if (!_musicTableView) {
        _musicTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBarView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.searchBarView.frame)-10) style:UITableViewStylePlain];
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
