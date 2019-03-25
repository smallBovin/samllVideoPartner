//
//  MBURLSessionManager.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBURLSessionManager.h"
#import "MBAppEnviromentConfig.h"

@interface MBURLSessionManager  ()

/** 请求任务的存储类*/
@property (nonatomic, strong) NSMutableDictionary * sessionDic;


@end

@implementation MBURLSessionManager

+ (instancetype)shareManager {
    static MBURLSessionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MBURLSessionManager alloc]init];
    });
    return _manager;
}

- (AFHTTPSessionManager *)createSessionManagerWithUrlString:(NSString *)urlString {
    NSString *sessionKey = [[NSString stringWithFormat:@"%@%@",[[MBAppEnviromentConfig shareConfig]currentServiceHostUrl],urlString] MD5String];
    AFHTTPSessionManager *tmpSession = [self.sessionDic objectForKey:sessionKey];
    if (nil != tmpSession) {
        return tmpSession;
    }

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存50M
    NSURLCache *cache = [[NSURLCache alloc]initWithMemoryCapacity:10*1024*1024 diskCapacity:50*1024*1024 diskPath:nil];
    [config setURLCache:cache];
    AFHTTPSessionManager *_session = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[[MBAppEnviromentConfig shareConfig]currentServiceHostUrl]] sessionConfiguration:config];
    _session.requestSerializer = [AFJSONRequestSerializer serializer];
    [_session.requestSerializer setTimeoutInterval:60];
    _session.responseSerializer = [AFJSONResponseSerializer serializer];
    _session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"application/octet-stream",@"text/plain",@"application/x-www-form-urlencoded", nil];
    
    [self.sessionDic setObject:_session forKey:sessionKey];
    return _session;
}

#pragma mark--public Methods---
- (BOOL)requestTaskIsExist {
    return YES;
}

- (void)addToRequestManagerTool {
    
}

- (void)deleteFromRequestManagerTool {
    
}
#pragma mark--lazy---
/** 请求存放池*/
- (NSMutableDictionary *)sessionDic {
    if (!_sessionDic) {
        _sessionDic = [NSMutableDictionary dictionary];
    }
    return _sessionDic;
}

@end
