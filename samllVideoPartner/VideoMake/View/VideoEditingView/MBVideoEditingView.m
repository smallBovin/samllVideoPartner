//
//  MBVideoEditingView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBVideoEditingView.h"
/** 拖拽view*/
#import "MBDragEditingView.h"

@interface MBVideoEditingView ()
/** 选择的视频时长*/
@property (nonatomic, strong) UILabel * selectDurationLabel;
/** container*/
@property (nonatomic, strong) UIView * containerView;
/** 视频帧展示的view*/
@property (nonatomic, strong) UIView * videoFrameView;
/** 左侧拖拽view*/
@property (nonatomic, strong) MBDragEditingView * leftDragView;
/** 右侧拖拽view*/
@property (nonatomic, strong) MBDragEditingView * rightDragView;
/** 顶部编辑框*/
@property (nonatomic, strong) UIView * topBorder;
/** 底部编辑框*/
@property (nonatomic, strong) UIView * bottomBorder;
/** 播放帧的位置*/
@property (nonatomic, strong) UIView * playLine;
/** 开始时间*/
@property (nonatomic, strong) UILabel * beginTimeLabel;
/** 结束时间*/
@property (nonatomic, strong) UILabel * endTimeLabel;
/** 下一步/完成*/
@property (nonatomic, strong) UIButton * nextStepBtn;


/** 记录*/
@property (nonatomic, assign) BOOL      isDraggingRight;
@property (nonatomic, assign) BOOL      isDraggingLeft;
@property (nonatomic, assign) CGFloat   startPointX;
@property (nonatomic, assign) CGFloat   endPointX;


/** 对应时长的系数*/
@property (nonatomic, assign) CGFloat  ratio;
/**编辑框内视频开始时间秒*/
@property (nonatomic, assign) CGFloat   startTime;
/**编辑框内视频结束时间秒*/
@property (nonatomic, assign) CGFloat   endTime;

@end

@implementation MBVideoEditingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviewsAndConstraints];
        
        self.startPointX = 0.0;
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.selectDurationLabel];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.videoFrameView];
    [self.containerView addSubview:self.playLine];
    [self.containerView addSubview:self.leftDragView];
    [self.containerView addSubview:self.topBorder];
    [self.containerView addSubview:self.rightDragView];
    [self.containerView addSubview:self.bottomBorder];
    [self addSubview:self.beginTimeLabel];
    [self addSubview:self.endTimeLabel];
    [self addSubview:self.nextStepBtn];
}

- (void)setImageArray:(NSMutableArray<UIImage *> *)imageArray {
    _imageArray = imageArray;
    if (imageArray.count>0) {
        CGFloat image_W = self.videoFrameView.cs_width/imageArray.count;
        CGFloat image_H = self.videoFrameView.cs_height;
        for (int i = 0; i<imageArray.count; i++) {
            UIImageView *img = [[UIImageView alloc]initWithImage:imageArray[i]];
            img.userInteractionEnabled = YES;
            img.frame = CGRectMake(image_W*i, 0, image_W, image_H);
            [self.videoFrameView addSubview:img];
        }
    }
}
- (void)setAsset:(AVAsset *)asset {
    _asset = asset;
    float duration = CMTimeGetSeconds(asset.duration);
    self.ratio = duration/CGRectGetWidth(self.videoFrameView.frame);
    self.startPointX = CGRectGetMinX(self.leftDragView.frame);
    self.endPointX = CGRectGetMaxX(self.rightDragView.frame)-self.startPointX;
    self.startTime = 0.0;
    self.endTime = duration;
    if (self.endTime>=10.0) {
        self.endTimeLabel.text = [NSString stringWithFormat:@"00:%.1f",self.endTime];
    }else {
        self.endTimeLabel.text = [NSString stringWithFormat:@"00:0%.1f",self.endTime];
    }
    
    CGFloat selectTime = self.endTime-self.startTime;
    if (selectTime>=10.0) {
        self.selectDurationLabel.text = [NSString stringWithFormat:@"已选择00:%0.1fs",selectTime];
    }else {
        self.selectDurationLabel.text = [NSString stringWithFormat:@"已选择00:0%0.1fs",selectTime];
    }}


- (void)layoutSubviews {
    [super layoutSubviews];
    _beginTimeLabel.center = CGPointMake(self.leftDragView.center.x, CGRectGetMaxY(self.containerView.frame)+kAdapt(15));
    _beginTimeLabel.bounds = CGRectMake(0, 0, kAdapt(50), kAdapt(20));
    _endTimeLabel.center = CGPointMake(self.rightDragView.center.x, CGRectGetMaxY(self.containerView.frame)+kAdapt(15));
    _endTimeLabel.bounds = CGRectMake(0, 0, kAdapt(50), kAdapt(20));
}

#pragma mark--action---
/** 完成编辑*/
- (void)editedFinished {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveAndUploadfinishEditedVideo)]) {
        [self.delegate saveAndUploadfinishEditedVideo];
    }
}
- (void)panEditingVideo:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.containerView];
    CMTime seekFrameTime =kCMTimeZero;
    BOOL flag = NO;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.playLine.hidden = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDragToCropVideo)]) {
                [self.delegate beginDragToCropVideo];
            }
            if (self.endTime>3.0 && self.endTime-self.startTime<3.0) {
                self.startTime = self.endTime-3.0;
            }
            self.isDraggingLeft = NO;
            self.isDraggingRight = NO;
            BOOL isLeft = [self.leftDragView pointInsideSelf:[pan locationInView:self.leftDragView]];
            BOOL isRight = [self.rightDragView pointInsideSelf:[pan locationInView:self.rightDragView]];
            if (isLeft) {
                self.isDraggingLeft = YES;
                self.isDraggingRight = NO;
            }
            if (isRight) {
                self.isDraggingRight = YES;
                self.isDraggingLeft = NO;
            }
            break;
        case UIGestureRecognizerStateChanged:
            
            if (self.isDraggingLeft) {
                CGFloat deltaX = point.x - self.startPointX;
                CGPoint center = self.leftDragView.center;
                center.x += deltaX;
                //视频最短3秒
                flag = self.endTime - self.startTime >=3.0?YES:NO;
                if (center.x>=kAdapt(25) && flag) {
                    self.startTime += deltaX*self.ratio;
                    if (self.startTime<=0.0) {
                        self.startTime = 0.0;
                    }
                    if (self.endTime-self.startTime<3) {
                        self.startTime = self.endTime -3.0;
                        [MBProgressHUD showOnlyTextMessage:@"最少剪辑3秒"];
                        return;
                    }
                    self.startPointX+=deltaX;
                    self.leftDragView.center = center;
                    self.topBorder.frame = CGRectMake(CGRectGetMaxX(self.leftDragView.frame), CGRectGetMinY(self.leftDragView.frame), CGRectGetWidth(self.topBorder.frame)-deltaX, kAdapt(3));
                    self.bottomBorder.frame = CGRectMake(CGRectGetMaxX(self.leftDragView.frame), CGRectGetMaxY(self.videoFrameView.frame), CGRectGetWidth(self.bottomBorder.frame)-deltaX, kAdapt(3));
                    self.beginTimeLabel.center = CGPointMake(self.leftDragView.center.x, CGRectGetMaxY(self.containerView.frame)+kAdapt(15));
                    self.playLine.frame = CGRectMake(self.startPointX, CGRectGetMinY(self.videoFrameView.frame), kAdapt(3), kAdapt(70));
                    
                    if (self.startTime>=10.0) {
                        self.beginTimeLabel.text = [NSString stringWithFormat:@"00:%.1f",self.startTime];
                    }else {
                        self.beginTimeLabel.text = [NSString stringWithFormat:@"00:0%.1f",self.startTime];
                    }
                }
                seekFrameTime = CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale);
            }
            if (self.isDraggingRight){
                CGFloat deltaX = point.x - self.endPointX;
                CGPoint center = self.rightDragView.center;
                center.x += deltaX;
                //视频最短3秒
                flag = self.endTime - self.startTime >=3.0?YES:NO;
                if (center.x<=CGRectGetMaxX(self.videoFrameView.frame)+kAdapt(5) && flag) {
                    self.endTime += deltaX*self.ratio;
                    if (self.endTime>self.asset.duration.value/self.asset.duration.timescale) {
                        self.endTime = self.asset.duration.value/self.asset.duration.timescale;
                    }
                    if (self.endTime-self.startTime<3.0) {
                        self.endTime = self.startTime+3.0;
                        [MBProgressHUD showOnlyTextMessage:@"最少剪辑3秒"];
                        return;
                    }
                    self.endPointX+=deltaX;
                    self.rightDragView.center = center;
                    self.topBorder.frame = CGRectMake(CGRectGetMaxX(self.leftDragView.frame), CGRectGetMinY(self.leftDragView.frame), CGRectGetWidth(self.topBorder.frame)+deltaX, kAdapt(3));
                    self.bottomBorder.frame = CGRectMake(CGRectGetMaxX(self.leftDragView.frame), CGRectGetMaxY(self.videoFrameView.frame), CGRectGetWidth(self.bottomBorder.frame)+deltaX, kAdapt(3));
                    self.endTimeLabel.center = CGPointMake(self.rightDragView.center.x, CGRectGetMaxY(self.containerView.frame)+kAdapt(15));
                    
                    if (self.endTime>=10.0) {
                        self.endTimeLabel.text = [NSString stringWithFormat:@"00:%.1f",self.endTime];
                    }else {
                        self.endTimeLabel.text = [NSString stringWithFormat:@"00:0%.1f",self.endTime];
                    }
                }
                seekFrameTime = CMTimeMakeWithSeconds(self.endTime, self.asset.duration.timescale);
                
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragingToChangeCurrentPlayerVideoFrameWithStartTime:flag:)]) {
                [self.delegate dragingToChangeCurrentPlayerVideoFrameWithStartTime:seekFrameTime flag:flag];
            }
            break;
        case UIGestureRecognizerStateEnded:
            self.playLine.hidden = NO;
            CGFloat selectTime = self.endTime-self.startTime;
            if (selectTime>=10.0) {
                self.selectDurationLabel.text = [NSString stringWithFormat:@"已选择00:%0.1fs",selectTime];
            }else {
                self.selectDurationLabel.text = [NSString stringWithFormat:@"已选择00:0%0.1fs",selectTime];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(dragedWithCropVideoStartTime:endTime:)]) {
                [self.delegate dragedWithCropVideoStartTime:CMTimeMakeWithSeconds(self.startTime, self.asset.duration.timescale) endTime:CMTimeMakeWithSeconds(self.endTime, self.asset.duration.timescale)];
            }
            break;
        default:
            break;
    }
}

#pragma mark--lazy---
/** 选择的时长*/
- (UILabel *)selectDurationLabel {
    if (!_selectDurationLabel) {
        _selectDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAdapt(30), kAdapt(26), SCREEN_WIDTH-kAdapt(60), 20)];
        _selectDurationLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _selectDurationLabel.text = @"已选择00:12s";
        _selectDurationLabel.font = [UIFont systemFontOfSize:12];
        _selectDurationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _selectDurationLabel;
}
/** 处理容器*/
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectDurationLabel.frame)+kAdapt(12), SCREEN_WIDTH, kAdapt(76))];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEditingVideo:)];
        [_containerView addGestureRecognizer:panGesture];
    }
    return _containerView;
}
/** 视频帧的视图*/
- (UIView *)videoFrameView {
    if (!_videoFrameView) {
        _videoFrameView = [[UIView alloc]initWithFrame:CGRectMake(kAdapt(30), kAdapt(3), SCREEN_WIDTH-kAdapt(60), kAdapt(70))];
    }
    return _videoFrameView;
}
/** 左侧拖拽框*/
- (MBDragEditingView *)leftDragView {
    if (!_leftDragView) {
        _leftDragView = [[MBDragEditingView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.videoFrameView.frame)-kAdapt(10), CGRectGetMinY(self.videoFrameView.frame)-kAdapt(3), kAdapt(10), kAdapt(76))];
        _leftDragView.image = [UIImage imageNamed:@"lift_drag"];
    }
    return _leftDragView;
}
/** 右侧拖拽框*/
- (MBDragEditingView *)rightDragView {
    if (!_rightDragView) {
        _rightDragView = [[MBDragEditingView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.videoFrameView.frame), CGRectGetMinY(self.videoFrameView.frame)-kAdapt(3), kAdapt(10), kAdapt(76))];
        _rightDragView.image = [UIImage imageNamed:@"right_drag"];
    }
    return _rightDragView;
}
/** 顶部的编辑框*/
- (UIView *)topBorder {
    if (!_topBorder) {
        _topBorder = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftDragView.frame), CGRectGetMinY(self.leftDragView.frame), CGRectGetWidth(self.videoFrameView.frame), kAdapt(3))];
        _topBorder.backgroundColor = [UIColor colorWithHexString:@"#FD4539"];
    }
    return _topBorder;
}
/** 底部的编辑框*/
- (UIView *)bottomBorder {
    if (!_bottomBorder) {
        _bottomBorder = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftDragView.frame), CGRectGetMaxY(self.videoFrameView.frame), CGRectGetWidth(self.videoFrameView.frame), kAdapt(3))];
        _bottomBorder.backgroundColor = [UIColor colorWithHexString:@"#FD4539"];
    }
    return _bottomBorder;
}
/** 播放帧的位置*/
- (UIView *)playLine {
    if (!_playLine) {
        _playLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.videoFrameView.frame), CGRectGetMinY(self.videoFrameView.frame), kAdapt(3), kAdapt(70))];
        _playLine.backgroundColor = [UIColor colorWithHexString:@"#FD4539"];
    }
    return _playLine;
}
/** 开始时间*/
- (UILabel *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc]init];
        _beginTimeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _beginTimeLabel.text = @"00:00";
        _beginTimeLabel.font = [UIFont systemFontOfSize:12];
        _beginTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _beginTimeLabel;
}
/** 结束时间*/
- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc]init];
        _endTimeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _endTimeLabel.font = [UIFont systemFontOfSize:12];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
        _endTimeLabel.text = @"00:15";
    }
    return _endTimeLabel;
}
/** 下一步*/
- (UIButton *)nextStepBtn {
    if (!_nextStepBtn) {
        _nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextStepBtn.frame = CGRectMake(SCREEN_WIDTH-kAdapt(96), CGRectGetHeight(self.frame)-kAdapt(40), kAdapt(73), kAdapt(25));
        [_nextStepBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextStepBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _nextStepBtn.layer.cornerRadius = kAdapt(5);
        _nextStepBtn.layer.masksToBounds = YES;
        [_nextStepBtn addTarget:self action:@selector(editedFinished) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepBtn;
}

@end
