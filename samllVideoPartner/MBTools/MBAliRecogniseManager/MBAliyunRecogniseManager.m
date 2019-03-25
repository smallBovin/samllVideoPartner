//
//  MBAliyunRecogniseManager.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/30.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBAliyunRecogniseManager.h"

#import "AliyunNlsSdk/NlsVoiceRecorder.h"
#import "AliyunNlsSdk/NlsSpeechTranscriberRequest.h"
#import "AliyunNlsSdk/TranscriberRequestParam.h"
#import "AliyunNlsSdk/AliyunNlsClientAdaptor.h"


#define bufferDataSize 4096.0
@interface MBAliyunRecogniseManager ()<NlsSpeechTranscriberDelegate,NlsVoiceRecorderDelegate>{
    Boolean transcriberStarted;
    NSString *audioFilePath;
    BOOL isFileRecognise;
    NSFileHandle *handle;
    dispatch_queue_t queue;
    NSData *fileAudioData;
}

@property(nonatomic,strong) NlsClientAdaptor *nlsClient;
@property(nonatomic,strong) NlsSpeechTranscriberRequest *transcriberRequest;
@property(nonatomic,strong) NlsVoiceRecorder *voiceRecorder;
@property(nonatomic,strong) TranscriberRequestParam *transRequestParam;




@end

@implementation MBAliyunRecogniseManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        //1. 全局参数初始化操作
        //1.1 初始化识别客户端,将transcriberStarted状态置为false
        _nlsClient = [[NlsClientAdaptor alloc]init];
        transcriberStarted = false;
        
        //1.2 初始化录音recorder工具
        _voiceRecorder = [[NlsVoiceRecorder alloc]init];
        _voiceRecorder.delegate = self;
        
        //1.3 初始化识别参数类
        _transRequestParam = [[TranscriberRequestParam alloc]init];
        
        //1.4 设置log级别
        [_nlsClient setLog:NULL logLevel:LOGINFO];
    }
    return self;
}

- (void)startRecognise {
    if (transcriberStarted) {
        NSLog(@"already started!");
        return;
    }
    //2. 创建请求对象和开始识别
    if(_transcriberRequest!= NULL){
        [_transcriberRequest releaseRequest];
        _transcriberRequest = NULL;
    }
    //2.1 创建请求对象，设置NlsSpeechTranscriberDelegate回调
    _transcriberRequest = [_nlsClient createTranscriberRequest];
    _transcriberRequest.delegate = self;
    
    //2.2 设置TranscriberRequestParam请求参数
    [_transRequestParam setFormat:@"opu"];
    [_transRequestParam setEnableIntermediateResult:true];
    //请使用https://help.aliyun.com/document_detail/72153.html 动态生成token
    // <AccessKeyId> <AccessKeySecret> 请使用您的阿里云账户生成 https://ak-console.aliyun.com/
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:aliyunToken];
    [_transRequestParam setToken:token];
    //请使用阿里云语音服务管控台(https://nls-portal.console.aliyun.com/)生成您的appkey
    [_transRequestParam setAppkey:@"1QGS7GW4UbcIwByX"];
    
    //2.3 传入请求参数
    [_transcriberRequest setTranscriberParams:_transRequestParam];
    
    //2.4 启动录音和识别，将transcriberStarted置为true
    [_voiceRecorder start];
    [_transcriberRequest start];
    transcriberStarted = true;
}

- (void)stopRecognise {
    //3 结束识别 停止录音，停止识别请求
    [_voiceRecorder stop:true];
    [_transcriberRequest stop];
    transcriberStarted= false;
    _transcriberRequest = NULL;
}

- (void)startFileRecogniseWithAudioPath:(NSString *)dataPath {
    if (transcriberStarted) {
        NSLog(@"already started!");
        return;
    }
    audioFilePath = dataPath;
    isFileRecognise = YES;
    //2. 创建请求对象和开始识别
    if(_transcriberRequest!= NULL){
        [_transcriberRequest releaseRequest];
        _transcriberRequest = NULL;
    }
    //2.1 创建请求对象，设置NlsSpeechTranscriberDelegate回调
    _transcriberRequest = [_nlsClient createTranscriberRequest];
    _transcriberRequest.delegate = self;
    
    //2.2 设置TranscriberRequestParam请求参数
    [_transRequestParam setFormat:@"pcm"];
    [_transRequestParam setEnableIntermediateResult:true];
    //请使用https://help.aliyun.com/document_detail/72153.html 动态生成token
    // <AccessKeyId> <AccessKeySecret> 请使用您的阿里云账户生成 https://ak-console.aliyun.com/
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:aliyunToken];
    [_transRequestParam setToken:token];
    //请使用阿里云语音服务管控台(https://nls-portal.console.aliyun.com/)生成您的appkey
    [_transRequestParam setAppkey:@"1QGS7GW4UbcIwByX"];
    
    //2.3 传入请求参数
    [_transcriberRequest setTranscriberParams:_transRequestParam];
    
    //2.4 启动录音和识别，将transcriberStarted置为true
    [_transcriberRequest start];
    transcriberStarted = true;
    [self beginUploadRecorderData];
}


- (void)beginUploadRecorderData {
    fileAudioData = [NSData dataWithContentsOfFile:audioFilePath];
    NSInteger totalCount = fileAudioData.length/bufferDataSize;
    queue = dispatch_queue_create("fileRocognise", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<totalCount; i++) {
            if (!self->handle) {
                self->handle = [NSFileHandle fileHandleForReadingAtPath:self->audioFilePath];
            }
            [self->handle seekToFileOffset:bufferDataSize*i];
            NSData *data =[self->handle readDataOfLength:bufferDataSize];
            [self->_transcriberRequest sendAudio:data length:(short)data.length];
            [NSThread sleepForTimeInterval:0.04];
        }
        [self stopRecognise];
    });
}

/**
 *4. NlsSpeechTranscriberDelegate接口回调方法
 */
//4.1 识别回调，本次请求失败
- (void)OnTaskFailed:(NlsDelegateEvent)event statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    transcriberStarted= false;
    [_voiceRecorder stop:true];
    if (self.delegate && [self.delegate respondsToSelector:@selector(recogniseFailed)]) {
        [self.delegate recogniseFailed];
    }
    NSLog(@"OnTaskFailed, statusCode is: %@ error message ：%@",statusCode,eMsg);
}

//4.2 识别回调，服务端连接关闭
- (void)OnChannelClosed:(NlsDelegateEvent)event statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    transcriberStarted= false;
    NSLog(@"OnChannelClosed, statusCode is: %@",statusCode);
}

//4.3 实时音频流识别开始
- (void)OnTranscriptionStarted:(NlsDelegateEvent)event statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    NSLog(@"%@",eMsg);

    if (self.delegate && [self.delegate respondsToSelector:@selector(recogniseDidBegin)]) {
        [self.delegate recogniseDidBegin];
    }
}

//4.4 识别回调，一句话的开始
- (void)OnSentenceBegin:(NlsDelegateEvent)event result:(NSString*)result statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        if (self.delegate && [self.delegate respondsToSelector:@selector(oneRecogniseEndWithResult:)]) {
            [self.delegate oneRecogniseBeginWithResult:result];
        }
        NSLog(@"%@", result);
    });
}

//4.5 识别回调，一句话的结束
- (void)OnSentenceEnd:(NlsDelegateEvent)event result:(NSString*)result statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        if (self.delegate && [self.delegate respondsToSelector:@selector(oneRecogniseEndWithResult:)]) {
            [self.delegate oneRecogniseEndWithResult:result];
        }
        NSLog(@"%@", result);
    });
}

//4.5 识别回调，一句话识别的中间结果
- (void)OnTranscriptionResultChanged:(NlsDelegateEvent)event result:(NSString *)result statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        // UI更新代码
        NSLog(@"%@", result);
    });
   
}

//4.6 识别回调，实时音频流识别完全结束
- (void)OnTranscriptionCompleted:(NlsDelegateEvent)event statusCode:(NSString *)statusCode errorMessage:(NSString *)eMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(recogniseDidEnd)]) {
            [self.delegate recogniseDidEnd];
        }
    });
}


/**
 *5. 录音相关回调
 */
- (void)recorderDidStart {
    NSLog(@"Did start recorder!");
}

- (void)recorderDidStop {
    NSLog(@"Did stop recorder!");
}

- (void)voiceDidFail:(NSError *)error {
    NSLog(@"Did recorder error!");
}

//5.1 录音数据回调
- (void)voiceRecorded:(NSData *)frame {
    if (_transcriberRequest != nil && transcriberStarted) {
        //录音线程回调的数据传给识别服务
        [_transcriberRequest sendAudio:frame length:(short)frame.length];
        NSLog(@"当期回调的数据 %d",(int)frame.length);
    }
}

- (void)voiceVolume:(NSInteger)volume {
    // onVoiceVolume if you need.
}


@end
