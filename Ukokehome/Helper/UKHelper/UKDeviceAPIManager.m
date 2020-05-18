//
//  UKDeviceAPIManager.m
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKDeviceAPIManager.h"

@implementation UKDeviceAPIManager


+ (void)getDeviceWithModel:(UKDeviceModel *)model success:(void (^)(UKDeviceModel *model)) success failure:(void(^)(NSString *error)) failure{
    
    NSString *url = [UKAPIList getAPIList].deviceInfo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"did":model.id}];
    
    [ETAFNetworking postLMK_AFNHttpSrt:url parameters:params success:^(id responseObject) {
        
        
        NSMutableDictionary *resultDic = [responseObject mutableCopy];
        
        if (resultDic.allKeys > 0) {
            success([self getDeviceModelByResultDic:resultDic withModel:model]);
        }else{
            
            success(nil);
        }
        
    } failure:^(id error) {
        
        failure(error);
        
    }WithHud:YES AndTitle:nil];
}


+ (void)setDeviceWithKey:(NSString *) key andValue:(NSString *) value withModel:(UKDeviceModel *)model success:(void (^)(UKDeviceModel *model)) success failure:(void(^)(NSString *error)) failure{
    
    NSString *url = [UKAPIList getAPIList].deviceSet;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{key:value}];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:@{@"did":model.id,@"deviceDetails":params.mj_JSONString}];
    
    [ETAFNetworking postLMK_AFNHttpSrt:url parameters:dic success:^(id responseObject) {
        
        NSMutableDictionary *resultDic = [responseObject mutableCopy];
            
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD showAlertWithText:@"Set Success"];
            
        });
        if (resultDic.allKeys > 0) {
                        
            success([self getDeviceModelByResultDic:resultDic withModel:model]);
            
        }else{
            
            success(nil);
        }
        
    } failure:^(id error) {
        
        failure(error);
        
    }WithHud:YES AndTitle:nil];
}

+ (UKDeviceModel *)getDeviceModelByResultDic:(NSDictionary *)resultDic withModel:(UKDeviceModel *) model{
    
    UKDeviceModel *deviceModel = model;
    
    NSMutableDictionary *oldDic = deviceModel.mj_keyValues;
    
    for (NSString *key in resultDic) {
        
        if (![key isEqualToString:@"id"]) {
            
            [oldDic setValue:resultDic[key] forKey:key];
            
        }
        
    }
    
    deviceModel = [UKDeviceModel mj_objectWithKeyValues:oldDic];
    
    return deviceModel;
}

@end
