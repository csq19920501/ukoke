//
//  GlobalKit.m
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/27.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import "GlobalKit.h"

@implementation GlobalKit

+ (instancetype)shareKit
{
    static GlobalKit *kit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kit = [GlobalKit new];
    });
    return kit;
}

- (instancetype)init{
    self = [super init];
    if (self)
    {
        
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
        
        _clientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClientId"];

        _passport = [[NSUserDefaults standardUserDefaults] objectForKey:@"Passport"];
        
        _badgeNumer = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BadgeNumber"] integerValue];
        
        _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];

        _userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];

        _pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pwd"];

        _email = [[NSUserDefaults standardUserDefaults] objectForKey:@"Email"];

        _address = [[NSUserDefaults standardUserDefaults] objectForKey:@"Address"];

        _birthday = [[NSUserDefaults standardUserDefaults] objectForKey:@"Birthday"];

        _gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"Gender"];
        
        _phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
        
        _devicePush = [[NSUserDefaults standardUserDefaults] objectForKey:@"DevicePush"];
        
        _dnd = [[NSUserDefaults standardUserDefaults] objectForKey:@"Dnd"];

        _emailPush = [[NSUserDefaults standardUserDefaults] objectForKey:@"EmailPush"];
        
        _sms = [[NSUserDefaults standardUserDefaults] objectForKey:@"Sms"];

        _push = [[NSUserDefaults standardUserDefaults] objectForKey:@"Push"];

        _dndStart = [[NSUserDefaults standardUserDefaults] objectForKey:@"DndStart"];

        _dndEnd = [[NSUserDefaults standardUserDefaults] objectForKey:@"DndEnd"];
        
        _storeMsg = [[NSUserDefaults standardUserDefaults] objectForKey:@"StoreMsg"];
        
        _region = [[NSUserDefaults standardUserDefaults] objectForKey:@"Region"];
        
        _homeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeName"];
        
        _loginType = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginType"];

        _isFirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IsFirst"] boolValue];

    }
    return self;
}

- (void)setToken:(NSString *)token{
    
    _token = token;
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPassport:(NSString *)passport{
    
    _passport = passport;
    
    [[NSUserDefaults standardUserDefaults] setObject:passport forKey:@"Passport"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setClientId:(NSString *)clientId{
    
    _clientId = clientId;
    
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:@"ClientId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBadgeNumer:(NSInteger)badgeNumer{
    
    _badgeNumer = badgeNumer;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(badgeNumer) forKey:@"BadgeNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUserName:(NSString *)userName{
    
    _userName = userName;
    
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString *)userId{
    
    _userId = userId;
    
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPwd:(NSString *)pwd{
    
    _pwd = pwd;
    
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"Pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setEmail:(NSString *)email{
    
    _email = email;
    
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"Email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAddress:(NSString *)address{
    
    _address = address;
    
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"Address"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBirthday:(NSString *)birthday{
    
    _birthday = birthday;
    
    [[NSUserDefaults standardUserDefaults] setObject:birthday forKey:@"Birthday"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setGender:(NSString *)gender{
    
    _gender = gender;
    
    [[NSUserDefaults standardUserDefaults] setObject:gender forKey:@"Gender"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPhoneNumber:(NSString *)phoneNumber{
    
    _phoneNumber = phoneNumber;
    
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDevicePush:(NSString *)devicePush{
    
    _devicePush = devicePush;
    
    [[NSUserDefaults standardUserDefaults] setObject:devicePush forKey:@"DevicePush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDnd:(NSString *)dnd{
    
    _dnd = dnd;
    
    [[NSUserDefaults standardUserDefaults] setObject:dnd forKey:@"Dnd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setEmailPush:(NSString *)emailPush{
    
    _emailPush = emailPush;
    
    [[NSUserDefaults standardUserDefaults] setObject:emailPush forKey:@"EmailPush"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSms:(NSString *)sms{
    
    _sms = sms;
    
    [[NSUserDefaults standardUserDefaults] setObject:sms forKey:@"Sms"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPush:(NSString *)push{
    
    _push = push;
    
    [[NSUserDefaults standardUserDefaults] setObject:push forKey:@"Push"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setDndStart:(NSString *)dndStart{
    
    _dndStart = dndStart;
    
    [[NSUserDefaults standardUserDefaults] setObject:dndStart forKey:@"DndStart"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setDndEnd:(NSString *)dndEnd{
    
    _dndEnd = dndEnd;
    
    [[NSUserDefaults standardUserDefaults] setObject:dndEnd forKey:@"DndEnd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setStoreMsg:(NSString *)storeMsg{
    
    _storeMsg = storeMsg;
    
    [[NSUserDefaults standardUserDefaults] setObject:storeMsg forKey:@"StoreMsg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRegion:(NSString *)region{
    
    _region = region;
    
    [[NSUserDefaults standardUserDefaults] setObject:region forKey:@"Region"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setHomeName:(NSString *)homeName{
    
    _homeName = homeName;
    
    [[NSUserDefaults standardUserDefaults] setObject:homeName forKey:@"HomeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setLoginType:(NSString *)loginType{
    
    _loginType = loginType;
    
    [[NSUserDefaults standardUserDefaults] setObject:loginType forKey:@"LoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsFirst:(BOOL)isFirst{
    
    _isFirst = isFirst;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(isFirst) forKey:@"IsFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearSession
{
    self.token = nil;
    
    self.passport = nil;
    
    self.userName = nil;

    self.userId = nil;
    
    self.email = nil;
    
    self.phoneNumber = nil;
    
    self.address = nil;
    
    self.birthday = nil;
    
    self.gender = nil;
    
    self.pwd = nil;
    
    self.emailPush = nil;
    
    self.sms = nil;
    
    self.push = nil;
    
    self.dndStart = nil;
    
    self.dndEnd = nil;
    
    self.devicePush = nil;
    
    self.dnd = nil;
    
    self.region = nil;
    
    self.storeMsg = nil;
    
    self.homeName = nil;
    
    self.loginType = nil;
}

@end
