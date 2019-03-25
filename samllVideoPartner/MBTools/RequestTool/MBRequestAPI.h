//
//  MBRequestAPI.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/20.
//  Copyright © 2018年 bovin. All rights reserved.
//

/** ====整个应用的接口控制（表要信息展示）====*/
/** 应用配置接口*/
#define APPLICATION_CONFIG_API  @"/index.php/index/Login/get_config"


/** =========== 用户信息接口========*/
/** 微信授权登录接口*/
#define WECHAT_LOGIN_API     @"/index.php/index/Login/index"
/** 发送验证码*/
#define SEND_VERIFY_CODE_API @"/index.php/index/Login/send_xinxi"
/** 绑定手机号*/
#define BINDING_MOBILE_API   @"/index.php/index/Login/check_phone"
/** 获取用户信息*/
#define USER_INFO_API        @"/index.php/index/UserAction/get_info"
/** 设置推荐人*/
#define SET_REFERRER_API     @"/index.php/index/UserAction/set_referee"
/** 用户反馈*/
#define USER_FEEDBACK_API    @"/index.php/index/UserAction/feedback"
/** 代理中心/分销中心*/
#define AGENCY_CENTER_API    @"/index.php/index/UserInfo/distribution"
/** 代理/分销佣金明细*/
#define COMMISSION_LIST_API  @"/index.php/index/UserInfo/commission_list"
/** 代理/分销提现明细*/
#define APPLY_LIST_API       @"/index.php/index/UserInfo/apply_list"
/** 我的团队*/
#define MY_TEAM_API          @"/index.php/index/UserInfo/team"
/** 提现申请*/
#define WITHDRAW_APPLY_TABLE_API    @"/index.php/index/UserInfo/apply_table"
/** 提交提现申请*/
#define SUBMIT_WITHDRAW_APLLY_API   @"/index.php/index/UserInfo/apply_submit"
/** 购买vip*/
#define VIP_PAY_API                 @"/index.php/index/UserAction/create_order"

/**========视频制作中素材接口=====*/
/** 视频编辑素材(背景图，字体，贴图，音乐)*/
#define VIDEO_EDITING_MATERIALS_API @"/index.php/index/UserAction/get_file"
/** 获取颜色信息*/
#define EDITTING_COLOR_API          @"/index.php/index/UserAction/get_color"
/** 获取风格信息*/
#define EDITTING_STYLE_API          @"/index.php/index/UserAction/get_style"
/** 音乐分类*/
#define MUSIC_TYPE_API              @"/index.php/index/UserAction/music_classify"
/** 语音识别*/
#define RECOGINIZE_TOKEN_API        @"/index.php/index/Clound/cloud"
/** 阿里云文件识别*/
#define AliCLOUD_FILE_RECOGNISE_API @"/index.php/index/Fileclound/upload"

/** =======用户的使用协议等链接===*/
#define kHostURL                [[MBAppEnviromentConfig shareConfig]currentServiceHostUrl]
/** 视频教学与发现*/
#define TEACHING_OR_FIND        [NSString stringWithFormat:@"%@/video/index.html",kHostURL]
//@"https://xshb.zhanxiantech.com/video/index.html"
/** 平台协议*/
#define PLATFORM_PROTOCOL       [NSString stringWithFormat:@"%@/video/help.html",kHostURL]
//@"https://xshb.zhanxiantech.com/video/help.html"
/** 用户协议*/
#define USER_PROTOCOL           [NSString stringWithFormat:@"%@/video/userAgreement.html",kHostURL]
//@"https://xshb.zhanxiantech.com/video/userAgreement.html"
/** 用户隐私政策*/
#define USER_PRIVACY_PROTOCOL   [NSString stringWithFormat:@"%@/video/Privacy.html",kHostURL]
//@"https://xshb.zhanxiantech.com/video/Privacy.html"
/** 分享的注册界面*/
#define SHARE_REGISTER_URL      [NSString stringWithFormat:@"%@/video/share.html",kHostURL]
//@"https://xshb.zhanxiantech.com/video/share.html"
/** 美恰客服*/
#define MEIQI_SERVICE_URL       [NSString stringWithFormat:@"%@/video/contact.html",kHostURL]
//@"https://xshb.zhanxiantech.com/video/contact.html"
//@"https://xshb.zhanxiantech.com/video/liaotian.html"
