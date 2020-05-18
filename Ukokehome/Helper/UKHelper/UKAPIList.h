//
//  UKAPIList.h
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UKAPIList : NSObject

+(UKAPIList*)getAPIList;

#pragma mark ---- user  ----
@property (nonatomic, copy) NSString *regist;///< 注册

@property (nonatomic, copy) NSString *code;///< 发送注册验证码

@property (nonatomic, copy) NSString *updateCode;///< 修改手机号发送注册验证码

@property (nonatomic, copy) NSString *addPhone;///< 验证验证码

@property (nonatomic, copy) NSString *updatePhone;///< 修改手机号验证验证码

@property (nonatomic, copy) NSString *loginRdm;///< 获取登录随机码

@property (nonatomic, copy) NSString *login;///< 登录

@property (nonatomic, copy) NSString *userInfo;///< 获取用户信息

@property (nonatomic, copy) NSString *userEdit;///< 编辑用户信息

@property (nonatomic, copy) NSString *updateEmail;///< 修改用户邮箱

@property (nonatomic, copy) NSString *pwdFindCode;///< 找回密码验证码

@property (nonatomic, copy) NSString *pwdFindUpdate;///< 找回登录密码

@property (nonatomic, copy) NSString *pwdCode;///< 修改密码验证码

@property (nonatomic, copy) NSString *pwdUpdate;///< 修改登录密码

@property (nonatomic, copy) NSString *userSetting;///< 用户配置

@property (nonatomic, copy) NSString *logout;///< 退出登录

#pragma mark ---- device  ----
@property (nonatomic, copy) NSString *isOnline;///< 设备是否在线

@property (nonatomic, copy) NSString *match;///< 添加设备

@property (nonatomic, copy) NSString *deviceInfo;///< 获取设备信息

@property (nonatomic, copy) NSString *deviceSet;///< 设置设备

@property (nonatomic, copy) NSString *deviceList;///< 设备列表

@property (nonatomic, copy) NSString *deviceUpdate;///< 更新设备信息

@property (nonatomic, copy) NSString *deviceDelete;///< 删除设备

@property (nonatomic, copy) NSString *timingSet;///< 设置空调定时

@property (nonatomic, copy) NSString *timingInfo;///< 获取空调定时

@property (nonatomic, copy) NSString *wfversionGet;///< 获取设备版本

@property (nonatomic, copy) NSString *wfversionUpgrade;///< 升级设备

@property (nonatomic, copy) NSString *waterValue;///< 净水器制水量

#pragma mark ---- share  ----
@property (nonatomic, copy) NSString *shareCreate;///< 分享设备

@property (nonatomic, copy) NSString *shareGet;///< 获取分享设备

#pragma mark ---- messge  ----
@property (nonatomic, copy) NSString *msgList;///< 消息列表

@property (nonatomic, copy) NSString *msgDelete;///< 删除消息

@end
