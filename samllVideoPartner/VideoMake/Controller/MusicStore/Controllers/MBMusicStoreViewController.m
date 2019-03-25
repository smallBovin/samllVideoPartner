//
//  MBMusicStoreViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicStoreViewController.h"
/** 音乐vc基类*/
#import "MBMusicBaseViewController.h"
/** 音乐类型 model */
#import "MBMusicTypeModel.h"
/** 音乐处理类*/
#import "MBMusicStoreViewModel.h"
/** 音乐搜索界面*/
#import "MBSearchMusicViewController.h"

@interface MBMusicStoreViewController ()
/** 音乐分类容器*/
@property (nonatomic, strong) MBSegmentScrollView *segmentView;
/** 音乐列表容器*/
@property (nonatomic, strong) MBPageContentView *contentView;
/** 存放各类音乐VC的数组*/
@property (nonatomic, strong) NSMutableArray *vcArray;
/** 存放音乐类目名称数组*/
@property (nonatomic, strong) NSMutableArray *nameArray;
/** 搜索框*/
@property (nonatomic, strong) UIButton * searchBtn;

/** 是否是第一次出现*/
@property (nonatomic, assign) BOOL  isFirstAppear;

@end

@implementation MBMusicStoreViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"音乐库";
    self.isFirstAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
    if (self.isFirstAppear) {
        if (self.musicTypeArray && self.musicTypeArray.count>0) {
            [self.segmentView setSelectedIndex:0 animated:YES];
        }
        self.isFirstAppear = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MBMusicStoreViewModel shareInstance]hideMusicAuditionView];
}

- (void)setMusicTypeArray:(NSMutableArray<MBMusicTypeModel *> *)musicTypeArray {
    _musicTypeArray = musicTypeArray;
    if (musicTypeArray.count) {
        for (MBMusicTypeModel *model in musicTypeArray) {
            [self.nameArray addObject:model.name];
            MBMusicBaseViewController *musicVC = [MBMusicBaseViewController new];
            musicVC.musicStyle = [model.cid intValue];
            [self.vcArray addObject:musicVC];
        }
    }
    [self setupSubviews];
}

- (void)setupSubviews {

    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.segmentView];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), SCREEN_WIDTH, 10)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:sepLine];
    [self.view addSubview:self.contentView];
}

#pragma mark--action---
/** 点击搜索按钮跳转到搜索页*/
- (void)goToSearchController {
    MBSearchMusicViewController *searchVC = [MBSearchMusicViewController new];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark--lazy------
/** 搜索按钮*/
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(kAdapt(23), NAVIGATION_BAR_HEIGHT+8, kAdapt(330), 40);
        _searchBtn.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
        [_searchBtn setTitle:@"请输入音乐名称" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _searchBtn.textAlignment = MBButtonAlignmentCenter;
        _searchBtn.type = MBButtonTypeLeftImageRightTitle;
        _searchBtn.spaceMargin = 10;
        _searchBtn.layer.cornerRadius = 20;
        _searchBtn.layer.masksToBounds = YES;
        [_searchBtn addTarget:self action:@selector(goToSearchController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}
/** 音乐类目容器*/
- (MBSegmentScrollView *)segmentView {
    
    if (!_segmentView) {
        MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
        style.showLine = YES;
        style.edgeMargin = 10;
        style.scrollLineWidth = 40;
        style.scrollLineHeight = 3;
        style.titleFont = [UIFont systemFontOfSize:15];
        style.scrollLineColor = [UIColor colorWithHexString:@"#FD4539"];
        style.scrollLineBottomMargin = 0;
        style.normalTitleColor = [UIColor colorWithHexString:@"#333333"];
        style.selectedTitleColor = [UIColor colorWithHexString:@"#FD4539"];
        __weak typeof(self)weakSelf = self;
        _segmentView = [[MBSegmentScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBtn.frame)+10, SCREEN_WIDTH, 40) segmentStyle:style titles:self.nameArray titleDidClick:^(UILabel *titleLabel, NSInteger index) {
            [weakSelf.contentView setSelectItemIndex:index];
        }];
        _segmentView.backgroundColor = [UIColor whiteColor];
    }
    return _segmentView;
}/** 音乐列表容器*/
- (MBPageContentView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[MBPageContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-108) segmentView:self.segmentView childVCs:self.vcArray parentViewController:self];
    }
    return _contentView;
}
/** 音乐类型数组*/
- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
/** vc数组*/
- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [NSMutableArray array];
    }
    return _vcArray;
}
@end
