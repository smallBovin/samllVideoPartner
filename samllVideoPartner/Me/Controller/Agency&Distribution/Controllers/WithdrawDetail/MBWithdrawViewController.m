//
//  MBWithdrawViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/4.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBWithdrawViewController.h"
/** 提现状态界面*/
#import "MBWithdrawAllViewController.h"
#import "MBWithdrawWaitPayController.h"
#import "MBWithdrawDeniedViewController.h"
#import "MBWithdrawRejectedViewController.h"
#import "MBWithdrawFinishedViewController.h"

@interface MBWithdrawViewController ()

/** 提现状态容器*/
@property (nonatomic, strong) MBSegmentScrollView *segmentView;
/** 提现列表容器*/
@property (nonatomic, strong) MBPageContentView *contentView;
/** 存放提现列表VC的数组*/
@property (nonatomic, strong) NSArray *vcArray;
/** 存放提现状态数组*/
@property (nonatomic, strong) NSArray *nameArray;
/** 是否是第一次出现*/
@property (nonatomic, assign) BOOL  isFirstAppear;

@end

@implementation MBWithdrawViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    self.title = @"提现明细";
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
    MBWithdrawAllViewController *allVC = [MBWithdrawAllViewController new];
    allVC.type = self.type;
    MBWithdrawWaitPayController *waitPayVC= [MBWithdrawWaitPayController new];
    waitPayVC.type = self.type;
    MBWithdrawDeniedViewController *deniedVC = [MBWithdrawDeniedViewController new];
    deniedVC.type = self.type;
    MBWithdrawRejectedViewController *rejectVC = [MBWithdrawRejectedViewController new];
    rejectVC.type = self.type;
    MBWithdrawFinishedViewController *finishVC = [MBWithdrawFinishedViewController new];
    finishVC.type = self.type;

    self.vcArray = @[allVC,waitPayVC,deniedVC,rejectVC,finishVC];
    self.nameArray = @[@"全部",@"待打款",@"已拒绝",@"已驳回",@"已完成"];
    [self.view addSubview:self.segmentView];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), SCREEN_WIDTH, 10)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [self.view addSubview:sepLine];
    [self.view addSubview:self.contentView];
}

#pragma mark--lazy--
/** 提现状态容器*/
- (MBSegmentScrollView *)segmentView {
    if (!_segmentView) {
        MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
        style.showLine = YES;
        style.titleMargin = 30;
        style.edgeMargin = 2;
        style.scrollLineWidth = 60;
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
/** 提现列表容器*/
- (MBPageContentView *)contentView {
    if (!_contentView) {
        _contentView = [[MBPageContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-57) segmentView:self.segmentView childVCs:self.vcArray parentViewController:self];
    }
    return _contentView;
}
@end
