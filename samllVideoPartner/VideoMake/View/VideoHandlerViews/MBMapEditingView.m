//
//  MBMapEditingView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/18.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBMapEditingView.h"

@interface MBMapEditingView ()


/** 放置贴图*/
@property (nonatomic, strong) UIImageView * mapImageView;

@end

@implementation MBMapEditingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mapImageView];
        self.mapImageView.frame = CGRectMake(5, 5, self.cs_width-10, self.cs_height-10);
    }
    return self;
}

#pragma mark--setter--
- (void)setMapImage:(UIImage *)mapImage {
    _mapImage = mapImage;
    self.mapImageView.image = mapImage;
}

#pragma mark--lazy-----
/** 贴图*/
- (UIImageView *)mapImageView {
    if (!_mapImageView) {
        _mapImageView = [[UIImageView alloc]init];
        _mapImageView.layer.masksToBounds = YES;
        _mapImageView.contentMode = UIViewContentModeScaleAspectFit;
        _mapImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _mapImageView.layer.allowsEdgeAntialiasing = YES;
        _mapImageView.userInteractionEnabled = YES;
    }
    return _mapImageView;
}
@end
