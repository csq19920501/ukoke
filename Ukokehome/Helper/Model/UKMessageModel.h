//
//  ETMessageModel.h
//  Ukokehome
//
//  Created by ethome on 2018/9/29.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UKMessageModel : NSObject

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString* readed;
@property (nonatomic, copy) NSString *messageInfo;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *messageTypeId;
@property (nonatomic, copy) NSString *otherInfo;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *title;

//未读消息个数
@property (nonatomic, assign) NSInteger messageNum;

@property (nonatomic) BOOL isEdit;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isExtension;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
