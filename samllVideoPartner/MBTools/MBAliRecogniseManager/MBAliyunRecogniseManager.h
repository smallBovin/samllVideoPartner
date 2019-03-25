//
//  MBAliyunRecogniseManager.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/30.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MBAliyunRecogniseManagerDelegate <NSObject>

@optional

- (void)oneRecogniseBeginWithResult:(NSString *)result;

- (void)oneRecogniseEndWithResult:(NSString *)result;

- (void)recogniseFailed;
- (void)recogniseDidBegin;

- (void)recogniseDidEnd;



@end


@interface MBAliyunRecogniseManager : NSObject


/** 代理*/
@property (nonatomic, weak) id<MBAliyunRecogniseManagerDelegate> delegate;



- (void)startRecognise;

- (void)startFileRecogniseWithAudioPath:(NSString *)dataPath;

- (void)stopRecognise;


@end

NS_ASSUME_NONNULL_END
