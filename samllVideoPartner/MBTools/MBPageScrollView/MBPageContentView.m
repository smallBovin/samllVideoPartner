//
//  MBPageContentView.m
//  MBTodayNews
//
//  Created by Bovin on 2017/12/13.
//  Copyright © 2017年 Bovin. All rights reserved.
//

#import "MBPageContentView.h"
#import "MBSegmentScrollView.h"


static NSString *const cellID = @"mb_contentCell";

@interface MBPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    NSInteger _oldIndex;
    NSInteger _currentIndex;
    CGFloat   _oldOffSetX;
}
// 用于处理重用和内容的显示
@property (strong, nonatomic) UICollectionView *collectionView;
/** 避免循环引用*/
@property (weak, nonatomic) MBSegmentScrollView *segmentView;
// 父类 用于处理添加子控制器  使用weak避免循环引用
@property (weak, nonatomic) UIViewController *parentViewController;


@end

@implementation MBPageContentView

- (instancetype)initWithFrame:(CGRect)frame segmentView:(MBSegmentScrollView *)segmentView childVCs:(NSArray *)childVCs parentViewController:(UIViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {

        self.childVcs = childVCs;
        self.segmentView = segmentView;
        self.parentViewController = parentViewController;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        [self commonInit];
        
    }
    return self;
}
- (void)commonInit {
    for (UIViewController *childVc in self.childVcs) {
        if ([childVc isKindOfClass:[UINavigationController class]]) {
            NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
            
        }
        
        if (self.parentViewController) {
            [self.parentViewController addChildViewController:childVc];
        }
    }
}
//设置内容偏移量的回调-------------
- (void)setSelectItemIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:index];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat temp = offSetX / self.bounds.size.width;
    CGFloat progress = temp - floorf(temp);;
    if (offSetX - _oldOffSetX >= 0) {
        if (progress == 0.0 || offSetX <= 1.0) {
            return;
        }
        _oldIndex = (offSetX/self.bounds.size.width);
        _currentIndex = _oldIndex + 1;
        if (_currentIndex >= self.childVcs.count) {
            _currentIndex = self.childVcs.count -1;
            return;
        }
    } else {
        _currentIndex = (offSetX / self.bounds.size.width);
        if (offSetX <= 0) {
            return;
        }
        _oldIndex = _currentIndex + 1;
        if (_oldIndex >= self.childVcs.count) {
            _oldIndex = self.childVcs.count - 1;
            return;
        }
        progress = 1.0 - progress;
    }
    
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];
    
}

/**为了解决在滚动或接着点击title更换的时候因为index不同步而增加了下边的两个代理方法的判断
 */

/** 滚动减速完成时再更新title的位置 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    [self contentViewEndMoveToIndex:currentIndex];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffSetX = scrollView.contentOffset.x;
}
#pragma mark - private helper
- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if(self.segmentView) {
        [self.segmentView adjustUIWithProgress:progress lastIndex:fromIndex currentIndex:toIndex];
    }
}

- (void)contentViewEndMoveToIndex:(NSInteger)currentIndex {
    if(self.segmentView) {
        [self.segmentView setTitleOffSetToCurrentIndex:currentIndex];
        [self.segmentView adjustUIWithProgress:1.0 lastIndex:currentIndex currentIndex:currentIndex];
    }
}

#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.childVcs.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    // 移除subviews 避免重用内容显示错误
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 这里建立子控制器和父控制器的关系  -> 当然在这之前已经将对应的子控制器添加到了父控制器了, 只不过还没有建立完成
    UIViewController *vc = (UIViewController *)self.childVcs[indexPath.section];
    vc.view.frame = self.bounds;
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self.parentViewController];
    
    return cell;
}

#pragma mark--懒加载-----------

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
//        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}
@end
