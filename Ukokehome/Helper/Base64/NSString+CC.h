//
//  NSString+CC.h
//  
//
//  Created by Michael Du on 13-4-15.
//  Copyright (c) 2013年 MichaelDu. All rights reserved.
//

#import <Foundation/Foundation.h>

// 非空字符
#define Regex_NotNull       @"/S"

//8~12位密码，必须包括字母和数字
#define Regex_Pwd  @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,12}$"

// 电子邮件
#define Regex_Email         @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

// 用户密码
#define Regex_Password      @"^[A-Za-z0-9]{6,32}$"

// 一般号码段
#define Regex_Phone         @"^(13[0-9]|14[0-9]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$"

// 所有号码（包括座机）
#define Regex_AllPhone      @"((\\d{3,4}-|\\s)?\\d{7,8})$|(1[0-9]{10})"

// 移动号码段（134、135、136、137、138、139、147、150、151、152、157、158、159、182、183、187、188）
#define Regex_CMCCPhone     @"^((\\+86)|(\\+86 )|(86)|(86 ))?1(3[4-9]|47|5[012789]|8[2378])\\d{8}$"

// 联通号码段（130、131、132、155、156、185、186）
#define Regex_CUCCPhone     @"^((\\+86)|(\\+86 )|(86)|(86 ))?1(3[0-2]|5[56]|8[56])\\d{8}$"

// 电信号码段（133、153、180、189）
#define Regex_CTCCPhone     @"^((\\+86)|(\\+86 )|(86)|(86 ))?1(33|53|8[09])\\d{8}$"

// 中文字符
#define Regex_China         @"^[\\u4E00-\\u9FA5]+$"

// 身份证号
#define Regex_IDCard        @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$"

// 真实姓名（含英文）
#define Regex_PersonName    @"^([\\u4e00-\\u9fa5]+|([a-z]+\\s?)+)$"

@interface NSString (CC)

+ (NSString *)newUUID;
//+ (NSString *)mechineID;

- (NSString *)md5Digest;
- (NSString *)sha1Digest;

//- (NSString *)base64Decoded;
//- (NSString *)base64Encoded;

- (BOOL)isMatch:(NSString *)regex;
- (NSDate *)dateWithFormate:(NSString *)formate;

//纯数字
+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isContainsEmoji:(NSString *)string;

+ (BOOL) isEmpty:(NSString *) str;

@end
