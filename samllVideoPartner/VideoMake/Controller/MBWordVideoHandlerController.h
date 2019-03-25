//
//  MBWordVideoHandlerController.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBWordVideoHandlerController : MBBaseViewController

/** 语音识别的内容*/
@property (nonatomic, copy) NSString * speekingWords;

/** 分段的文字*/
@property (nonatomic, strong) NSMutableArray * wordsArray;
/** 分段的时间*/
@property (nonatomic, strong) NSMutableArray * timeArray;
/** 是否是文件识别*/
@property (nonatomic, assign) BOOL  isFileRecogise;
/** 文件路径*/
@property (nonatomic, copy) NSString * fileAudioPath;
/** 本地视频路径*/
@property (nonatomic, strong) NSURL * localVideoURL;


@end

NS_ASSUME_NONNULL_END
