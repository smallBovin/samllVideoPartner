//  LanSongVideoReverse.h
//
//  Created by sno on 04/12/2017.
//  Copyright © 2017 chrissung. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import "LanSongLog.h"


@interface LSOVideoReverse : NSObject {
    
}
-(id)initWithURL:(NSURL *)url;

/**
 执行倒序
 调用后,会异步执行.
 */
- (void)start;

@property(nonatomic, copy) void(^progressBlock)(CGFloat percent);


/**
 编码完成回调, 完成后返回生成的视频路径;
 工作在其他线程,
 如要工作在主线程,请使用:
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 */
@property(nonatomic, copy) void(^completionBlock)(NSString *dstPath);
@end


