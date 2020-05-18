//
//  UKDeviceModel.m
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKDeviceModel.h"

@implementation UKDeviceModel

-(void)cherkProperty2SafeArea{
//    空调读取到的问题可能存在一个异常值（很大），我们要保护一下
//    摄氏度保护范围：
//    -50~60摄氏度
//    华摄氏度保护范围：
//    -58~140
//    超过上限取上限值，超过下限取下限值

    if ([self.property4 isEqualToString:@"1"]) {
        if (self.property2.floatValue < -50.0) {
            self.property2 = @"-50";
        }else if (self.property2.floatValue > 60.0){
            self.property2 = @"60";
        }
    }else  {
        if (self.property2.floatValue < -58.0) {
            self.property2 = @"-58";
        }else if (self.property2.floatValue > 140.0){
            self.property2 = @"140";
        }
    }
}

@end
