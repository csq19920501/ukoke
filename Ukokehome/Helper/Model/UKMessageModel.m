//
//  ETMessageModel.m
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKMessageModel.h"

@implementation UKMessageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"description"] || [key isEqualToString:@"messageInfo"]) {
        
        self.messageInfo = value;
    }else if ([key isEqualToString:@"messageId"]){
        
        self.id = value;
    }else if ([key isEqualToString:@"date"]){
        
        self.createDate = value;
    }else if ([key isEqualToString:@"messageTitle"]){
        
        self.title = value;
    }
}

@end
