//
//  MBThemeBaseViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBThemeBaseViewController.h"
/** 背景图cell*/
#import "MBBackgroundCollectionCell.h"
/** 贴图，背景图，音乐列表通用model*/
#import "MBMapsModel.h"

@interface MBThemeBaseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/** 背景图CollectionView*/
@property (nonatomic, strong) UICollectionView * collectionView;
/** 加载第几页数据*/
@property (nonatomic, assign) int  currentPage;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataArray;

/** 进度显示器*/
@property (nonatomic, strong) MBProgressHUD * progressHUD;

/** 选中的item*/
@property (nonatomic, strong) NSIndexPath * selectIndexPath;

@end

@implementation MBThemeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setRefreshFunctionToScrollView:self.collectionView refreshType:MBRefreshTypeBoth];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}
#pragma mark--请求数据----
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
    dict[@"type"] = @(1);
    dict[@"page"] = @(page);
    
    [RequestUtil POST:VIDEO_EDITING_MATERIALS_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [self.collectionView.mj_header endRefreshing];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
                [self.collectionView.mj_footer resetNoMoreData];
            }
            NSInteger total = [responseObject[@"datalist"][@"total"] integerValue];
            NSMutableArray *tmp = [MBMapsModel mj_objectArrayWithKeyValuesArray:responseObject[@"datalist"][@"data"]];
            [self.dataArray addObjectsFromArray:tmp];
            if (total == self.dataArray.count) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.collectionView.mj_footer endRefreshing];
            }
            for (MBMapsModel *model in self.dataArray) {
                NSString *extension = model.path.pathExtension;
                NSString *fileName = [NSString stringWithFormat:@"%@.%@",[model.path MD5String],extension];
                NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
                if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                    model.isDownload = YES;
                }else {
                    model.isDownload = NO;
                }
            }
            [self.collectionView reloadData];
        }else {
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.currentPage>1) {
            self.currentPage--;
        }
    }];
}

#pragma mark--下载高清背景图---
- (void)downloadHighQualityBackgroundImageWithUrl:(NSString *)url {
    if ([[MBUserManager manager]isUnderReview]) {
        [self allowDownloadBackgroundImage:url];
    }else {
        if (![[MBUserManager manager]isVip]) { //前往开通VIP
            Class class = NSClassFromString(@"MBOpenVipViewController");
            [self.superVC.navigationController pushViewController:[class new] animated:YES];
        }else {
            [self allowDownloadBackgroundImage:url];
        }
    }
}
/** 允许下载背景图*/
- (void)allowDownloadBackgroundImage:(NSString *)url {
    
    
    if (url.length) {
        NSString *extension = url.pathExtension;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[url MD5String],extension];
        NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                UIImage *image= [UIImage imageWithData:data];
                self.selectImage = image;
                NSLog(@"sdfhjsh %@  iamge  %@",filePath,image);
            });
        }else {
            [RequestUtil downloadFileWithRequestUrl:url downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                CGFloat pro = 1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
                NSLog(@"下载进度  %f",pro);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.progressHUD) {
                        self.progressHUD = [MBProgressHUD showUploadOrDownloadProgress:0];
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
                NSData *data = [NSData dataWithContentsOfURL:filePath];
                UIImage *image= [UIImage imageWithData:data];
                NSLog(@"sdfhjsh %@  iamge  %@",filePath,image);
                for (MBMapsModel *model in self.dataArray) {
                    if ([model.path isEqualToString:url]) {
                        NSString *extension = model.path.pathExtension;
                        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[model.path MD5String],extension];
                        NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
                        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                            model.isDownload = YES;
                        }else {
                            model.isDownload = NO;
                        }
                        break;
                    }
                }
                self.selectImage = image;
                [self.collectionView reloadData];
            } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error) {
                NSLog(@"sdfhjsh %@",error.description);
            }];
        }
        
    }else {
        [MBProgressHUD showOnlyTextMessage:@"图片地址不存在"];
    }
}


#pragma mark--MBTemplateCollectionViewDelegate--
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MBBackgroundCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBBackgroundCollectionCell class]) forIndexPath:indexPath];
    if (self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    if (indexPath == self.selectIndexPath) {
        cell.layer.borderColor = [UIColor colorWithHexString:@"#FD4539"].CGColor;
        cell.layer.borderWidth = 1;
    }else {
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        cell.layer.borderWidth = 1;
    }
    return cell;
}
#pragma mark--UICollectionViewDelegate--
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBMapsModel *model = self.dataArray[indexPath.item];
    if ([MBUserManager manager].isUnderReview) {
        [self downloadSelectedBGImageWithIndexPath:indexPath];
    }else {
        if ([model.author isEqualToString:@"1"] &&![[MBUserManager manager]isVip]) {
            Class class = NSClassFromString(@"MBOpenVipViewController");
            [self.navigationController pushViewController:[class new] animated:YES];
        }else {
            [self downloadSelectedBGImageWithIndexPath:indexPath];
        }
    }
}

- (void)downloadSelectedBGImageWithIndexPath:(NSIndexPath *)indexPath {
    MBBackgroundCollectionCell *cell = (MBBackgroundCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    MBBackgroundCollectionCell *selectCell = (MBBackgroundCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.selectIndexPath];
    if (self.selectIndexPath != indexPath) {
        cell.layer.borderColor = [UIColor colorWithHexString:@"#FD4539"].CGColor;
        cell.layer.borderWidth = 1;
        selectCell.layer.borderColor = [UIColor clearColor].CGColor;
        selectCell.layer.borderWidth = 1;
    }
    self.selectIndexPath = indexPath;
    //下载高清大图
    MBMapsModel *model = self.dataArray[indexPath.item];
    [self downloadHighQualityBackgroundImageWithUrl:model.path];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, SAFE_INDICATOR_BAR, 0);
}
#pragma mark--lazy---
/** collection*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset = UIEdgeInsetsMake(kAdapt(24), kAdapt(14), kAdapt(24), kAdapt(14));
        layout.itemSize = CGSizeMake(kAdapt(100), kAdapt(190));
        layout.minimumLineSpacing = kAdapt(24);
        layout.minimumInteritemSpacing = kAdapt(5);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-10) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[MBBackgroundCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([MBBackgroundCollectionCell class])];
    }
    return _collectionView;
}
/** 数据源*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
