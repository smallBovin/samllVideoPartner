//
//  MBFontColorChooseView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBFontColorChooseView.h"

@interface MBFontColorChooseView ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** collection*/
@property (nonatomic, strong) UICollectionView * collectionView;
/** flowLayout*/
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

/** 进度显示器*/
@property (nonatomic, strong) MBProgressHUD * progressHUD;

/** 临时存放分页加载的数组*/
@property (nonatomic, strong) NSMutableArray * temDataArray;
/** 加载第几页*/
@property (nonatomic, assign) int  currentPage;

@end

@implementation MBFontColorChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#232323"];
        [self addSubview:self.collectionView];
        self.currentPage = 1;
    }
    return self;
}

#pragma mark--setter---
- (void)setEditType:(MBWordEditType)editType {
    _editType = editType;
    if (editType == MBWordEditTypeFont) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreFont)];
        footer.ignoredScrollViewContentInsetBottom = SAFE_INDICATOR_BAR;
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"亲，已经到底了！" forState:MJRefreshStateNoMoreData];
        self.collectionView.mj_footer = footer;
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
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    if (self.temDataArray.count<=0) {
        [self.temDataArray addObjectsFromArray:dataArray];
    }
    [self.collectionView reloadData];
}
- (void)setFontTitle:(NSString *)fontTitle {
    _fontTitle = fontTitle;
}


#pragma mark--加载更多字体--
- (void)loadMoreFont {
    self.currentPage++;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    dict[@"type"] = @"3";
    dict[@"page"] = @(self.currentPage);
    [RequestUtil POST:VIDEO_EDITING_MATERIALS_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.mj_footer endRefreshing];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            NSMutableArray *tempArry = [MBWordFontColorModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            for (NSInteger i=0; i<tempArry.count; i++) {
                MBWordFontColorModel *model = tempArry[i];
                if ([model.title isEqualToString:self.fontTitle]) {
                    model.isSelect = YES;
                }else{
                    model.isSelect = NO;
                }
                NSString *fileName = [model.path lastPathComponent];
                NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
                if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                    model.isDownload = YES;
                }else {
                    model.isDownload = NO;
                }
                [tempArry replaceObjectAtIndex:i withObject:model];
            }
            [self.temDataArray addObjectsFromArray:tempArry];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
            self.currentPage--;
        }
        NSNumber *total = (NSNumber *)responseObject[@"datalist"][@"total"];
        if (self.temDataArray.count == [total intValue]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
    MBWordEditCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBWordEditCollectionCell class]) forIndexPath:indexPath];
    cell.type = self.editType;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark--UICollectionViewDelegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MBWordFontColorModel *model = self.dataArray[indexPath.row];
    if ([MBUserManager manager].isUnderReview) {
        if (self.editType == MBWordEditTypeFont) {
            [self firstDownloadFontFileWithModel:model indexPath:indexPath];
        }else {
            [self chooseFontOrColorWithModel:model indexPath:indexPath];
        }
    }else {
        if ([model.author isEqualToString:@"1"] &&![[MBUserManager manager]isVip]) {
            Class class = NSClassFromString(@"MBOpenVipViewController");
            [self.superVC.navigationController pushViewController:[class new] animated:YES];
        }else {
            if (self.editType == MBWordEditTypeFont) {
                [self firstDownloadFontFileWithModel:model indexPath:indexPath];
            }else {
                [self chooseFontOrColorWithModel:model indexPath:indexPath];
            }
        }
    }
}
/** 下载字体*/
- (void)firstDownloadFontFileWithModel:(MBWordFontColorModel *)model indexPath:(NSIndexPath *)indexPath {
    if (model.path.length) {
//        NSString *extension = model.path.pathExtension;
        NSString *fileName = [model.path lastPathComponent];
        NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath]);
                CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
                CGDataProviderRelease(fontDataProvider);
                CTFontManagerRegisterGraphicsFont(fontRef, NULL);
                NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
                model.fontName = fontName;
                [self chooseFontOrColorWithModel:model indexPath:indexPath];
            });
        }else {
            [RequestUtil downloadFontWithRequestUrl:model.path downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                CGFloat pro = 1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
                NSLog(@"下载进度  %f",pro);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.progressHUD) {
                        self.progressHUD = [MBProgressHUD showUploadOrDownloadProgress:pro];
                    }
                    self.progressHUD.progress = pro;
                    self.progressHUD.label.text = @"正在下载";
                    if (pro >= 1.0) {
                        self.progressHUD.label.text = @"下载完成";
                        [self.progressHUD hideAnimated:YES];
                        self.progressHUD = nil;
                    }
                });
            } success:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath) {
                CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)filePath);
                CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
                CGDataProviderRelease(fontDataProvider);
                CTFontManagerRegisterGraphicsFont(fontRef, NULL);
                NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
                model.fontName = fontName;
                [self chooseFontOrColorWithModel:model indexPath:indexPath];
            } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error) {
                NSLog(@"sdfhjsh %@",error.description);
            }];
        }
    }else {
        [MBProgressHUD showOnlyTextMessage:@"字体地址不存在"];
    }
}
/** 使用字体*/
- (void)chooseFontOrColorWithModel:(MBWordFontColorModel *)model indexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWordFontColor:model:)]) {
        [self.delegate selectWordFontColor:self.editType model:model];
    }
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        MBWordFontColorModel *tempModel = self.dataArray[i];
        if (indexPath.row == i) {
            tempModel.isSelect = YES;
        }else{
            tempModel.isSelect = NO;
        }
        NSString *fileName = [model.path lastPathComponent];
        NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            model.isDownload = YES;
        }else {
            model.isDownload = NO;
        }
        [self.dataArray replaceObjectAtIndex:i withObject:tempModel];
    }
    [self.collectionView reloadData];
}


#pragma mark--lazy--
/** collection*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#232323"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MBWordEditCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([MBWordEditCollectionCell class])];
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



#pragma mark--CollectionCell

@interface MBWordEditCollectionCell ()

/** 文字或者颜色*/
@property (nonatomic, strong)UIButton *contentBtn;

/** 字体使用*/
@property (nonatomic, strong) UIImageView *fontImageView;
@property (nonatomic, strong) UIImageView *downloadImageView;

@end

@implementation MBWordEditCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#232323"];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.contentBtn];
        self.contentBtn.frame = self.bounds;
        [self.contentBtn addSubview:self.fontImageView];
        [self.contentBtn addSubview:self.downloadImageView];
    }
    return self;
}
-(void)setType:(MBWordEditType)type{
    _type = type;
}

-(void)setModel:(MBWordFontColorModel *)model{
    _model = model;
    if (self.type == MBWordEditTypeFont) {
        self.fontImageView.hidden = NO;
        self.downloadImageView.hidden = NO;
        //选择字体
//        [self.contentBtn setTitle:model.title forState:UIControlStateNormal];
//        [self.contentBtn setBackgroundColor:[UIColor colorWithHexString:@"ffffff"] state:UIControlStateNormal];
//        self.contentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.contentBtn sd_setImageWithURL:[NSURL URLWithString:model.thumb] forState:UIControlStateNormal];
        if (model.isSelect == YES) {
//            [self.contentBtn setTitleColor:[UIColor colorWithHexString:@"FD4539"] forState:UIControlStateNormal];
            [self.contentBtn setCs_borderColor:[UIColor colorWithHexString:@"FD4539"]];
            [self.contentBtn setCs_borderWidth:1];
        }else{
            [self.contentBtn setCs_borderColor:[UIColor colorWithHexString:@"333333"]];
            [self.contentBtn setCs_borderWidth:1];
//            [self.contentBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        }
        
        if (model.isDownload) {
            self.downloadImageView.hidden = YES;
            self.fontImageView.frame = self.contentBtn.bounds;
        }else {
            self.downloadImageView.hidden = NO;
            self.fontImageView.frame = CGRectMake(0, 0, self.bounds.size.width-kAdapt(30), self.bounds.size.height);
            self.downloadImageView.bounds = CGRectMake(0, 0, kAdapt(20), kAdapt(20));
            self.downloadImageView.center = CGPointMake(self.bounds.size.width-kAdapt(20)/2, self.contentBtn.center.y);
        }
        [self.fontImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageWithColor:[UIColor blackColor]]];
        
    }else{
        //选择颜色
        self.fontImageView.hidden = NO;
        self.downloadImageView.hidden = NO;
        
        [self.contentBtn setBackgroundColor:[UIColor colorWithHexString:model.color] state:UIControlStateNormal];
        [self.contentBtn setBackgroundColor:[UIColor colorWithHexString:model.color] state:UIControlStateHighlighted];
        if (model.isSelect == YES) {
            self.contentBtn.layer.borderWidth = 1.0;
            self.contentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        }else{
            self.contentBtn.layer.borderWidth = 0.0;
            self.contentBtn.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

#pragma mark--lazy
/** 字体或者颜色*/
- (UIButton *)contentBtn {
    if (!_contentBtn) {
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentBtn.userInteractionEnabled = NO;
        _contentBtn.layer.cornerRadius = 2.0;
        _contentBtn.clipsToBounds = YES;
    }
    return _contentBtn;
}
/** 子图图片*/
- (UIImageView *)fontImageView {
    if (!_fontImageView) {
        _fontImageView = [[UIImageView alloc]init];
        _fontImageView.userInteractionEnabled = YES;
        _fontImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _fontImageView;
}
/** 子图图片*/
- (UIImageView *)downloadImageView {
    if (!_downloadImageView) {
        _downloadImageView = [[UIImageView alloc]init];
        _downloadImageView.image = [UIImage imageNamed:@"font_download"];
        _downloadImageView.userInteractionEnabled = YES;
        _downloadImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _downloadImageView;
}
@end
