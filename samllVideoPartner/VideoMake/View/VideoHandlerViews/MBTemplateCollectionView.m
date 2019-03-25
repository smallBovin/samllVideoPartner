//
//  MBTemplateCollectionView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBTemplateCollectionView.h"
/** 风格模板model*/
#import "MBStyleTemplateModel.h"
/** 贴图，背景图，音乐列表通用model*/
#import "MBMapsModel.h"
/**横向分页加载*/
#import "SideRefresh.h"
#import "UICollectionView+SideRefresh.h"

@interface MBTemplateCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 关闭按钮*/
@property (nonatomic, strong) UIButton * closeBtn;
/** 完成*/
@property (nonatomic, strong) UIButton * finishBtn;
/** collection*/
@property (nonatomic, strong) UICollectionView * collectionView;
/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

/** 临时存放分页加载的数组*/
@property (nonatomic, strong) NSMutableArray * temDataArray;
/** 加载第几页*/
@property (nonatomic, assign) int  currentPage;

@end

@implementation MBTemplateCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerRadius:kAdapt(20) rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
        [self setupSubviewsAndConstraints];
        self.currentPage = 1;
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.closeBtn];
    [self addSubview:self.finishBtn];
    [self addSubview:self.collectionView];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kAdapt(15));
        make.top.equalTo(self.mas_top).offset(kAdapt(13));
        make.width.height.mas_equalTo(kAdapt(16));
    }];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(13));
        make.right.equalTo(self.mas_right).offset(-kAdapt(14));
        make.width.mas_equalTo(kAdapt(19));
        make.height.mas_equalTo(kAdapt(15));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(kAdapt(50));
        make.height.mas_equalTo(kAdapt(82)); //先写死，设置区的inset调整cell
    }];
    
}

#pragma mark--setter---
- (void)setType:(MBTemplateType)type {
    _type = type;
    if (type == MBTemplateTypeMaps) {
        SideRefreshFooter *refreshFooter = [SideRefreshFooter refreshWithLoadAction:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentPage++;
                [self loadMoreTemplateDataWithPage:self.currentPage];
            });
        }];
        refreshFooter.hideIndicator = YES;//隐藏加载动画
        self.collectionView.sideRefreshFooter = refreshFooter;
    }
}
- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    self.layout.itemSize = itemSize;
}
- (void)setSpaceMargin:(CGFloat)spaceMargin {
    _spaceMargin = spaceMargin;
    self.layout.minimumLineSpacing = spaceMargin;
}
- (void)setEdgeInset:(UIEdgeInsets)edgeInset {
    _edgeInset = edgeInset;
    self.layout.sectionInset = edgeInset;
}
- (void)setCellCornerRadius:(CGFloat)cellCornerRadius {
    _cellCornerRadius = cellCornerRadius;
}
- (void)setCellShadowColor:(UIColor *)cellShadowColor {
    _cellShadowColor = cellShadowColor;
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    if (self.temDataArray.count<=0) {
        [self.temDataArray addObjectsFromArray:dataArray];
    }
    [self.collectionView reloadData];
}

#pragma mark--加载更多数据---
- (void)loadMoreTemplateDataWithPage:(int)page {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"type"] = @(2);
    dict[@"page"] = @(page);
    
    [RequestUtil POST:VIDEO_EDITING_MATERIALS_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.sideRefreshFooter endLoading];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            NSMutableArray *tmp = [MBMapsModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            [self.temDataArray addObjectsFromArray:tmp];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
            self.currentPage--;
        }
        NSNumber *total = (NSNumber *)responseObject[@"datalist"][@"total"];
        if (self.temDataArray.count == [total intValue]) {
            [self.collectionView showEmptyFooter];
        }
        self.dataArray = self.temDataArray;
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.currentPage--;
    }];}

#pragma mark--MBTemplateCollectionViewDelegate--
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MBTemplateCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBTemplateCollectionCell class]) forIndexPath:indexPath];
    cell.cornerRadius = self.cellCornerRadius;
    cell.shadowColor = self.cellShadowColor;
    if (self.type == MBTemplateTypeStyle) {
        if (self.dataArray.count) {
            cell.styleModel = self.dataArray[indexPath.row];
        }
    }else {
        if (self.dataArray.count) {
            cell.mapModel = self.dataArray[indexPath.row];
        }
    }
    return cell;
}
#pragma mark--UICollectionViewDelegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //如果是vip跳转到VIP界面
    BOOL isVipTemplate = NO;
    if (self.type == MBTemplateTypeStyle) {
        MBStyleTemplateModel *model = self.dataArray[indexPath.row];
        if ([model.author isEqualToString:@"1"]) {
            isVipTemplate = YES;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseTemplateWithType:isVipTemplate:stickerImage:templateModel:)]) {
            [self.delegate chooseTemplateWithType:self.type isVipTemplate:isVipTemplate stickerImage:nil templateModel:model];
        }
    }else {
        MBMapsModel *model = self.dataArray[indexPath.row];
        if ([model.author isEqualToString:@"1"]) {
            isVipTemplate = YES;
        }
        MBTemplateCollectionCell *cell = (MBTemplateCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseTemplateWithType:isVipTemplate:stickerImage:templateModel:)]) {
            [self.delegate chooseTemplateWithType:self.type isVipTemplate:isVipTemplate stickerImage:cell.showImage templateModel:nil];
        }
    }
    
}






#pragma mark--lazy--
/** 关闭按钮*/
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_closeBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(closeChooseTemplateViewWithType:)]) {
                [weakSelf.delegate closeChooseTemplateViewWithType:weakSelf.type];
            }
        }];
    }
    return _closeBtn;
}
/** 完成按钮*/
- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_finishBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(finishChooseTemplateWithType:)]) {
                [weakSelf.delegate finishChooseTemplateWithType:weakSelf.type];
            }
        }];
    }
    return _finishBtn;
}
/** collection*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MBTemplateCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([MBTemplateCollectionCell class])];
    }
    return _collectionView;
}
/** 临时存放*/
- (NSMutableArray *)temDataArray {
    if (!_temDataArray) {
        _temDataArray = [NSMutableArray array];
    }
    return _temDataArray;
}
- (void)dealloc {
    NSLog(@"%@==== 释放了",[self description]);
}
@end


@interface MBTemplateCollectionCell ()

/** 图片*/
@property (nonatomic, strong) UIImageView * templateImgView;
/** vip*/
@property (nonatomic, strong) UIImageView * vipLogo;

@end

@implementation MBTemplateCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.templateImgView];
        [self.templateImgView addSubview:self.vipLogo];
        [self.vipLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.templateImgView.mas_right).offset(-kAdapt(5));
            make.top.equalTo(self.templateImgView.mas_top).offset(kAdapt(10));
        }];
    }
    return self;
}

#pragma mark--setter--
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setupCellShadowPath];
}
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self setupCellShadowPath];
}

- (void)setMapModel:(MBMapsModel *)mapModel {
    _mapModel = mapModel;
    [self.templateImgView sd_setImageWithURL:[NSURL URLWithString:mapModel.thumb] placeholderImage:[UIImage imageWithColor:[UIColor clearColor]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.showImage = image;
    }];
    if ([[MBUserManager manager]isUnderReview]) {
        self.vipLogo.hidden = YES;
    }else {
        if ([mapModel.author isEqualToString:@"1"]) {
            self.vipLogo.hidden = NO;
        }else {
            self.vipLogo.hidden = YES;
        }
    }
}
- (void)setStyleModel:(MBStyleTemplateModel *)styleModel {
    _styleModel = styleModel;
    [self.templateImgView sd_setImageWithURL:[NSURL URLWithString:styleModel.bg_pic] placeholderImage:[UIImage imageWithColor:[UIColor clearColor]]];
    if ([[MBUserManager manager]isUnderReview]) {
        self.vipLogo.hidden = YES;
    }else {
        if ([styleModel.author isEqualToString:@"1"]) {
            self.vipLogo.hidden = NO;
        }else {
            self.vipLogo.hidden = YES;
        }
    }
}
#pragma mark--Private Method--
- (void)setupCellShadowPath {
    [self.contentView setCornerRadius:self.cornerRadius rectCornerType:UIRectCornerAllCorners];
    
//    [self setLayerShadow:self.shadowColor offset:CGSizeMake(0, 0) radius:8];
}

#pragma mark--lazy---
/** 模板图片*/
- (UIImageView *)templateImgView {
    if (!_templateImgView) {
        _templateImgView = [[UIImageView alloc]initWithFrame:self.bounds];
        _templateImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _templateImgView;
}
/** vip*/
- (UIImageView *)vipLogo {
    if (!_vipLogo) {
        _vipLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vip_sign"]];
    }
    return _vipLogo;
}
@end
