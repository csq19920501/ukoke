//
//  UKDeviceModel.h
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKDeviceModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *actualDeviceTypeId;
@property (nonatomic, copy) NSString *defaultDeviceTypeId;

#pragma mark ---- AC  ----
@property (nonatomic, copy) NSString *targetTemp;
@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *property1;
@property (nonatomic, copy) NSString *property2;
@property (nonatomic, copy) NSString *property3;
@property (nonatomic, copy) NSString *property4;
@property (nonatomic, copy) NSString *property5;
@property (nonatomic, copy) NSString *property6;
@property (nonatomic, copy) NSString *property7;
@property (nonatomic, copy) NSString *property8;
@property (nonatomic, copy) NSString *property9;
@property (nonatomic, copy) NSString *property10;

@property (nonatomic, copy) NSString *fanSpeed;
//是否单冷
@property (nonatomic, copy) NSString *acType;

-(void)cherkProperty2SafeArea;
@end

NS_ASSUME_NONNULL_END
