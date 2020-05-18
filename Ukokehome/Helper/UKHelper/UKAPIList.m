//
//  UKAPIList.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKAPIList.h"

@implementation UKAPIList

+(UKAPIList*)getAPIList
{
    
    static UKAPIList *apiList = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        apiList = [[UKAPIList alloc] init];
    });
    
    return apiList;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setUpAPI];
    }
    return self;
}

-(void)setUpAPI
{
    
#pragma mark ---- user  ----

    _regist = [NSString stringWithFormat:@"%@/user/regist",SERVER];
    
    _code = [NSString stringWithFormat:@"%@/user/mobilephone/code",SERVER];

    _updateCode = [NSString stringWithFormat:@"%@/user/update/mobilephone/code",SERVER];
    
    _addPhone = [NSString stringWithFormat:@"%@/user/mobilephone/add",SERVER];
    
    _updatePhone = [NSString stringWithFormat:@"%@/user/mobilephone/update",SERVER];
    
    _updateEmail = [NSString stringWithFormat:@"%@/user/email/update",SERVER];

    _loginRdm = [NSString stringWithFormat:@"%@/user/login/rdm",SERVER];

    _login = [NSString stringWithFormat:@"%@/user/login",SERVER];
    
    _userInfo = [NSString stringWithFormat:@"%@/user/info",SERVER];

    _userEdit = [NSString stringWithFormat:@"%@/user/edit",SERVER];

    _pwdFindCode = [NSString stringWithFormat:@"%@/user/find/pwd/code",SERVER];

    _pwdFindUpdate = [NSString stringWithFormat:@"%@/user/find/pwd/update",SERVER];
    
    _pwdCode = [NSString stringWithFormat:@"%@/user/pwd/code",SERVER];
    
    _pwdUpdate = [NSString stringWithFormat:@"%@/user/pwd/update",SERVER];
    
    _userSetting = [NSString stringWithFormat:@"%@/user/setting",SERVER];
    
    _logout = [NSString stringWithFormat:@"%@/user/logout",SERVER];

#pragma mark ---- device  ----

    _isOnline = [NSString stringWithFormat:@"%@/itfc/device/isonline",SERVER];

    _match       = [NSString stringWithFormat:@"%@/device/match",SERVER];
    
    _deviceSet      = [NSString stringWithFormat:@"%@/device/set",SERVER];

    _deviceInfo       = [NSString stringWithFormat:@"%@/device/info",SERVER];

    _deviceList       = [NSString stringWithFormat:@"%@/device/list",SERVER];

    _deviceUpdate       = [NSString stringWithFormat:@"%@/device/update",SERVER];

    _deviceDelete       = [NSString stringWithFormat:@"%@/device/delete",SERVER];
    
    _timingSet       = [NSString stringWithFormat:@"%@/device/aircon/timing/set",SERVER];

    _timingInfo      = [NSString stringWithFormat:@"%@/device/aircon/timing/info",SERVER];
    
    _wfversionGet = [NSString stringWithFormat:@"%@/wfversion/get",SERVER];
    
    _wfversionUpgrade = [NSString stringWithFormat:@"%@/wfversion/upgrade",SERVER];
    
    _waterValue = [NSString stringWithFormat:@"%@/device/water/value",SERVER];
    
#pragma mark ---- share  ----
    _shareCreate       = [NSString stringWithFormat:@"%@/share/create",SERVER];

    _shareGet       = [NSString stringWithFormat:@"%@/share/get",SERVER];

#pragma mark ---- message  ----

    _msgList       = [NSString stringWithFormat:@"%@/msg/list",SERVER];
    
    _msgDelete       = [NSString stringWithFormat:@"%@/msg/delete",SERVER];

}

@end
