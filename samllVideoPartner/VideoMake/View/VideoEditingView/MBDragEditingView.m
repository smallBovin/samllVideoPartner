//
//  MBDragEditingView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBDragEditingView.h"

@implementation MBDragEditingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return [self pointInsideSelf:point];
}

- (BOOL)pointInsideSelf:(CGPoint)point {
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, UIEdgeInsetsMake(0, -20, 0, -20));
    return CGRectContainsPoint(hitFrame, point);
}
@end
