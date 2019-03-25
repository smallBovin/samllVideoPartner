//
//  MBRecorderManager.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/24.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBRecorderManager.h"

#define ALPHA 0.05f                 // 音频振幅调解相对值 (越小振幅就越高)

@interface MBRecorderManager ()

/** 录音接收器*/
@property (nonatomic, strong) AVAudioRecorder * audioRecorder;
/** 录音文件名称*/
@property (nonatomic, copy) NSString * audioName;


@end

@implementation MBRecorderManager

SINGLETON_IMPLEMENT(Manager)

- (BOOL)initlizationRecorder {
    // 0. 设置录音会话
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    // 1. 确定录音存放的位置
    NSURL *url = [NSURL fileURLWithPath:[[MBRecorderManager audioFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",self.audioName]]];
    NSLog(@"开始录音时的存放位置=====%@",url);
    // 2. 设置录音参数
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    // 设置编码格式
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    // 采样率
    [recordSettings setValue :[NSNumber numberWithFloat:16000.0] forKey: AVSampleRateKey];
    // 通道数
    [recordSettings setValue :[NSNumber numberWithInt:1] forKey: AVNumberOfChannelsKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
    [recordSettings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];

    // 3. 创建录音对象
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    _audioRecorder.meteringEnabled = YES;
    if (error) {
        NSLog(@"%@",error);
        return NO;
    }
    return YES;
}

- (BOOL)isRecording {
    return self.audioRecorder.isRecording;
}

- (void)startRecordWithFileName:(NSString *)fileName {
    
    self.audioName = fileName;
    if (![self initlizationRecorder]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recorderIsFailedWithMsg:)]) {
            [self.delegate recorderIsFailedWithMsg:@"录音器初始化失败"];
        }
        return;
    }
    [self microPhonePermissions:^(BOOL isGranted) {
        if (isGranted) {
            [self prepareToBeginRecord];
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showPermissionsAlert];
            });
        }
    }];
}

// 判断麦克风权限
- (void)microPhonePermissions:(void (^)(BOOL isGranted))block  {
    __block BOOL ret = NO;
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [avSession requestRecordPermission:^(BOOL available) {
            if (available) ret = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) block(ret);
            });
        }];
    }
}

- (void)prepareToBeginRecord {
    
    if (![self.audioRecorder prepareToRecord]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recorderIsFailedWithMsg:)]) {
            [self.delegate recorderIsFailedWithMsg:@"录音器初始化失败"];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(recorderIsBegin)]) {
        [self.delegate recorderIsBegin];
    }
    [self.audioRecorder record];

}

- (void)showPermissionsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法录音" message:@"请前往“设置-隐私-麦克风”中允许访问麦克风。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        });
    }];
    [alert addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


- (void)stopRecord {
    [self.audioRecorder stop];
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

- (void)deleteCurrentRecord {
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
    }
    [self.audioRecorder deleteRecording];
}

- (float)levels {
    [self.audioRecorder updateMeters];
    double aveChannel = pow(10, (ALPHA * [self.audioRecorder averagePowerForChannel:0]));
    aveChannel = aveChannel*ALPHA+(1-ALPHA)*aveChannel;
    NSLog(@"peakPower   :%lf   from :%lf",[self.audioRecorder peakPowerForChannel:0],aveChannel);
    return aveChannel;
}


#pragma mark--音频文件的保存路径---
+ (NSString *)audioFolderPath {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioPath = [cachePath stringByAppendingPathComponent:@"MBAudio"];
    BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:audioPath];
    if (!isExist) {
        [[NSFileManager defaultManager]createDirectoryAtPath:audioPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return audioPath;
}
/** 临时的音频文件保存路径*/
- (NSString *)tmpAudioSaveName {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *audioPath = [cachePath stringByAppendingPathComponent:@"MBAudio"];
    return [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",self.audioName]];
}

@end
