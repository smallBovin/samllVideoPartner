//
//  MBRecorderManager.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/24.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MBRecorderManagerDelegate <NSObject>

@optional

- (void)recorderIsBegin;

- (void)recorderIsFailedWithMsg:(NSString *)msg;

@end

@interface MBRecorderManager : NSObject



SINGLETON_INTERFACE(Manager)

/** 代理*/
@property (nonatomic, weak) id<MBRecorderManagerDelegate> delegate;

/** 是否正在录音*/
@property (nonatomic, assign) BOOL  isRecording;

/** 开始录音*/
- (void)startRecordWithFileName:(NSString *)fileName;
/** 停止录音*/
- (void)stopRecord;
/** 删除录音*/
- (void)deleteCurrentRecord;

- (float)levels;

//音频文件存放路径
- (NSString *)tmpAudioSaveName;

@end

NS_ASSUME_NONNULL_END
