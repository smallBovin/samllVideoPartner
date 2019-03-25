//
//  MBBaseWebviewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBBaseWebviewController.h"
#import <WebKit/WebKit.h>

@interface MBBaseWebviewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
/** 网页加载容器*/
@property (nonatomic, strong)WKWebView  * webView;

@property (nonatomic, strong) WKUserContentController *contentController;
/** 加载进度*/
@property (nonatomic, strong) UIProgressView * loadingProgressView;
/** 加载的URL*/
@property (nonatomic, copy) NSURL * URL;

/** 关闭按钮*/
@property (nonatomic, strong) UIBarButtonItem * closeBarItem;

@end

@implementation MBBaseWebviewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
}
- (void)setWebViewTitle:(NSString *)webViewTitle {
    _webViewTitle = webViewTitle;
    self.navigationItem.title = webViewTitle;
}

#pragma mark--public Method
- (void)loadUrl:(NSURL *)URL {
    if([URL.absoluteString isEqualToString:self.URL.absoluteString] && _webView) {
        return;
    }
    
    self.URL = URL;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)loadHTMLString:(NSString *)htmlString withTitle:(NSString *)title {
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.navigationItem.title = title;
}

- (void)reloadData {
    if (self.webView.hidden) {
        self.webView.hidden = NO;
    }
    [self.webView reload];
}

- (void)showLeftBackBarItem {
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarItem];
        self.fd_interactivePopDisabled = YES;
    }else {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem];
        self.fd_interactivePopDisabled = NO;
    }
}

- (void)close {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark--overwrite  back Method--
- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark--WKNavigationDelegate---
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    self.webView.hidden = NO;
    self.loadingProgressView.hidden = NO;
    if ([webView.URL.scheme isEqual:@"about"]) {
        self.webView.hidden = YES;
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItem.title = webView.title;
//    [_webView evaluateJavaScript:@"window.JsProxy.login();" completionHandler:^(id _Nullable data, NSError * _Nullable error) {
//        NSLog(@"%@", data);
//    }];
    [self showLeftBackBarItem];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView != _webView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if([challenge previousFailureCount] ==0){
            NSURLCredential*credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else{
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,nil);
        }
    }
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    _webView.hidden = YES;
}
#pragma mark UIDelegate
/** 消息弹框*/
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}
/** 确认弹框*/
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}
/** 有输入框的弹框拦截*/
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}
#pragma mark WKScriptMessageHandler js拦截 调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
    NSLog(@"方法名:%@", message.name);
    NSLog(@"参数:%@", message.body);
    
    if([message.name isEqualToString:@""]){
        // do something
    }
}
#pragma mark--加载进度的监听-----
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.loadingProgressView.progress = [change[@"new"] floatValue];
        if (self.loadingProgressView.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.loadingProgressView.hidden = YES;
            });
        }
    }
}


#pragma mark--lazy---
/** 网页加载容器*/
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc]init];
        configuration.allowsInlineMediaPlayback = YES;
        
        NSString *userInfoString = @"";
        NSString *jsString = [NSString stringWithFormat:@"\
                              window.JsProxy = { \
                              login:login \
                              };\
                              function login() { \
                              return '%@'; \
                              };", userInfoString];
        //javascript 注入
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:jsString
                                                                injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                             forMainFrameOnly:YES];
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        [userContentController addUserScript:noneSelectScript];
        configuration.userContentController = userContentController;
        self.contentController = userContentController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [self.view addSubview:_webView];
    }
    return _webView;
}
- (UIProgressView* )loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 2)];
        _loadingProgressView.progressTintColor = [UIColor colorWithHexString:@"#FA3C3C"];
        _loadingProgressView.trackTintColor = [UIColor clearColor];
        [self.view addSubview:_loadingProgressView];
    }
    return _loadingProgressView;
}

/** 关闭导航按钮*/
- (UIBarButtonItem *)closeBarItem {
    if (!_closeBarItem) {
        _closeBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav-close"] style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    }
    return _closeBarItem;
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView stopLoading];
    _webView = nil;
}
@end
