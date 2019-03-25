//
//  MBMyTeamViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBMyTeamViewController.h"
/** 一二三级界面*/
#import "MBFirstRankViewController.h"
#import "MBSecondRankViewController.h"
#import "MBThirdRankViewController.h"



@interface MBMyTeamViewController ()

/** 三级分类容器*/
@property (nonatomic, strong) MBSegmentScrollView *segmentView;
/** 每级团队列表容器*/
@property (nonatomic, strong) MBPageContentView *contentView;
/** 存放各团队列表VC的数组*/
@property (nonatomic, strong) NSArray *vcArray;
/** 存放每级团队名称数组*/
@property (nonatomic, strong) NSArray *nameArray;
/** 是否是第一次出现*/
@property (nonatomic, assign) BOOL  isFirstAppear;

@end

@implementation MBMyTeamViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的团队";
    [self setupSubviews];
    self.isFirstAppear = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
    if (self.isFirstAppear) {
        [self.segmentView setSelectedIndex:0 animated:YES];
        self.isFirstAppear = NO;
    }
}

- (void)setupSubviews {

    self.vcArray = @[[MBFirstRankViewController new],[MBSecondRankViewController new],[MBThirdRankViewController new]];
    self.nameArray = @[@"一级",@"二级",@"三级"];
    [self.view addSubview:self.segmentView];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), SCREEN_WIDTH, 10)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [self.view addSubview:sepLine];
    [self.view addSubview:self.contentView];
}


#pragma mark--lazy--
/** 三级类目容器*/
- (MBSegmentScrollView *)segmentView {
    if (!_segmentView) {
        MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
        style.showLine = YES;
        style.titleMargin = (SCREEN_WIDTH-99)/3;
        style.edgeMargin = 0;
        style.scrollLineWidth = 70;
        style.scrollLineHeight = 3;
        style.titleFont = [UIFont systemFontOfSize:17];
        style.scrollLineColor = [UIColor colorWithHexString:@"#FD4539"];
        style.scrollLineBottomMargin = 0;
        style.normalTitleColor = [UIColor colorWithHexString:@"#333333"];
        style.selectedTitleColor = [UIColor colorWithHexString:@"#FD4539"];
        __weak typeof(self)weakSelf = self;
        _segmentView = [[MBSegmentScrollView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 47) segmentStyle:style titles:self.nameArray titleDidClick:^(UILabel *titleLabel, NSInteger index) {
            [weakSelf.contentView setSelectItemIndex:index];
        }];
        _segmentView.backgroundColor = [UIColor whiteColor];
    }
    return _segmentView;
}
/** 音乐列表容器*/
- (MBPageContentView *)contentView {
    if (!_contentView) {
        _contentView = [[MBPageContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-57) segmentView:self.segmentView childVCs:self.vcArray parentViewController:self];
    }
    return _contentView;
}

@end
