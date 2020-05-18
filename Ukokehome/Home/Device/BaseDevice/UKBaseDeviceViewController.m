//
//  UKBaseDeviceViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKBaseDeviceViewController.h"
#import "UKDeviceSettingViewController.h"

@interface UKBaseDeviceViewController ()


@end

@implementation UKBaseDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_isFromHome) {
        
        [UKDeviceAPIManager getDeviceWithModel:self.model success:^(UKDeviceModel * _Nonnull model) {
            
            self.model = model;
            
            [self initViewByModel];
            
            
        } failure:^(NSString * _Nonnull error) {
            
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceAction:) name:ETUPDATEDEVIECENOT object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    _isFromHome = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ETUPDATEDEVIECENOT object:nil];
    
}

- (void)gotoSetting{
        
    UKDeviceSettingViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UKDeviceSettingViewController"];
    
    controller.model = self.model;

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setDeviceKey:(NSString *)key andValue:(NSString *) value{
    
    if ([self.model.actualDeviceTypeId isAirConditioner]) {
        
        if (![key isEqualToString:@"status"] && ![key isEqualToString:@"property4"] && ![self.model.status isEqualToString:@"on"]) {
            
            [HUD showAlertWithText:@"Please open the device"];
            
            return;
        }
    }

    [UKDeviceAPIManager setDeviceWithKey:key andValue:value withModel:self.model success:^(UKDeviceModel * _Nonnull model) {
        
        self.model = model;
        
        if ([key isEqualToString:@"targetTemp"]) {
            self.isPaning = NO;
        }
        
        [self initViewByModel];
        
    } failure:^(NSString * _Nonnull error) {
        
        if ([key isEqualToString:@"targetTemp"]) {
            self.isPaning = NO;
        }
        
        [self initViewWhileSetFail];
    }];
}

- (void)updateDeviceAction:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    
    NSDictionary *result = dic[@"result"];
    
    if ([self.model.deviceId containsString:result[@"deviceId"]]) {
        
        for (NSString *key in result) {
            
            if ([self getVariableWithClass:[UKDeviceModel class] varName:key]) {
                
                [self.model setValue:result[key] forKey:key];

            }
            
        }
        
        [self initViewByModel];
        
    }
    
}

- (BOOL)getVariableWithClass:(Class) myClass varName:(NSString *)name{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

- (void)initViewByModel{
    
}

- (void)initViewWhileSetFail{
    
    
}

@end
