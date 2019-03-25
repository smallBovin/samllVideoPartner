//
//  MBBackgroundThemeController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBackgroundThemeController.h"
/** 各类背景图的基类*/
#import "MBThemeBaseViewController.h"

@interface MBBackgroundThemeController ()

/** 背景分类容器*/
@property (nonatomic, strong) MBSegmentScrollView *segmentView;
/** 背景列表容器*/
@property (nonatomic, strong) MBPageContentView *contentView;
/** 存放各类背景VC的数组*/
@property (nonatomic, strong) NSArray *vcArray;
/** 存放背景类目名称数组*/
@property (nonatomic, strong) NSArray *nameArray;
/** 搜索框*/
@property (nonatomic, strong) UIButton * searchBtn;


/** */
@property (nonatomic, strong) MBThemeBaseViewController *backgroundVC;

@end

@implementation MBBackgroundThemeController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"背景库";
    [self setupSubviews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)setupSubviews {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(makeSureToUseSelectBackground)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    self.backgroundVC = [MBThemeBaseViewController new];
    
    self.vcArray = @[self.backgroundVC];
    self.nameArray = @[@"卡通"];
    
//    [self.view addSubview:self.segmentView];
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 10)];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    [self.view addSubview:sepLine];
    [self.view addSubview:self.contentView];
}

#pragma mark--确认使用背景图---
- (void)makeSureToUseSelectBackground {
    
    if (self.bgCompleteAction) {
        self.bgCompleteAction(self.backgroundVC.selectImage);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--lazy------
/** 音乐类目容器*/
- (MBSegmentScrollView *)segmentView {
    
    if (!_segmentView) {
        MBSegmentStyle *style = [[MBSegmentStyle alloc]init];
        style.showLine = YES;
        style.titleMargin = 34;
        style.edgeMargin = 0;
        style.scrollLineWidth = 40;
        style.scrollLineHeight = 3;
        style.titleFont = [UIFont systemFontOfSize:17];
        style.scrollLineColor = [UIColor colorWithHexString:@"#FD4539"];
        style.scrollLineBottomMargin = 0;
        style.normalTitleColor = [UIColor colorWithHexString:@"#333333"];
        style.selectedTitleColor = [UIColor colorWithHexString:@"#FD4539"];
        __weak typeof(self)weakSelf = self;
        _segmentView = [[MBSegmentScrollView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, SCREEN_WIDTH, 40) segmentStyle:style titles:self.nameArray titleDidClick:^(UILabel *titleLabel, NSInteger index) {
            [weakSelf.contentView setSelectItemIndex:index];
        }];
        _segmentView.backgroundColor = [UIColor whiteColor];
    }
    return _segmentView;
}/** 音乐列表容器*/
- (MBPageContentView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[MBPageContentView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+10, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-10) segmentView:self.segmentView childVCs:self.vcArray parentViewController:self];
    }
    return _contentView;
}
@end
