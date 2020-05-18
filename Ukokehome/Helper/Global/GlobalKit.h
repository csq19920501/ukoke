//
//  GlobalKit.h
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/27.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalKit : NSObject


@property (nonatomic, copy) NSString *deviceType; //设备类型
@property (nonatomic, copy) NSString *deviceId; //设备mac地址

@property (nonatomic, copy) NSString *token;     //登录token
@property (nonatomic, copy) NSString *passport;     //登录passport

@property (nonatomic, copy) NSString *clientId;     //个推ClientId

@property (nonatomic, assign) NSInteger badgeNumer; //未读消息个数

@property (nonatomic, copy) NSString *userName;     //用户名

@property (nonatomic, copy) NSString *userId;     //用户UserId

@property (nonatomic, copy) NSString *pwd;     //用户密码

@property (nonatomic, copy) NSString *email;     //用户密码

@property (nonatomic, copy) NSString *address;     //用户地址

@property (nonatomic, copy) NSString *birthday;     //用户生日

@property (nonatomic, copy) NSString *gender;     //用户性别

@property (nonatomic, copy) NSString *phoneNumber;     //用户名（手机号）

@property (nonatomic, copy) NSString *devicePush;     //设备推送是否开启

@property (nonatomic, copy) NSString *dnd;     //免打扰是否开启

@property (nonatomic, copy) NSString *emailPush;     //邮件推送开关

@property (nonatomic, copy) NSString *push;     //消息推送开关

@property (nonatomic, copy) NSString *sms;     //短信推送开关

@property (nonatomic, copy) NSString *dndStart;     //免打扰开始时间

@property (nonatomic, copy) NSString *dndEnd;     //免打扰结束时间

@property (nonatomic, copy) NSString *storeMsg;     //是否存储推送消息

@property (nonatomic, copy) NSString *region;     //用户地区

@property (nonatomic, copy) NSString *homeName;     //家庭名称

@property (nonatomic, copy) NSString *loginType;     //登录类型

@property (nonatomic, copy) NSString *wifiSSID;     //配置的WiFi名称

@property (nonatomic, copy) NSString *wifiPwd;     //配置的WiFi密码

@property (nonatomic, assign) BOOL isFirst;        //是否第一次登录
@property (nonatomic, assign) BOOL isSoftAp;       //是否softAp配网
@property (nonatomic, assign) BOOL isInLogin;        //是否在登录界面


+ (instancetype)shareKit;

- (void)clearSession;

@end
