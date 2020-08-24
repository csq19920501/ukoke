//
//  UITextField+HYBPlaceHolder.m
//  Ukokehome
//
//  Created by ethome on 2020/5/18.
//  Copyright © 2020 ethome. All rights reserved.
//

#import "UITextField+HYBPlaceHolder.h"




@implementation UITextField (HYBPlaceHolder)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        {
            SEL oriSEL = @selector(initWithCoder:);
            Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
            
            SEL cusSEL = @selector(ZB_initWithCoder:);
            Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
            
            BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
            if (addSucc) {
                class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
            }else {
                method_exchangeImplementations(oriMethod, cusMethod);
            }
        }
      
    });
    
}
- (instancetype)ZB_initWithCoder:(NSCoder *)coder
{
    id obj = [self ZB_initWithCoder:coder];
    if (obj) {
//         [self setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        NSLog(@"self.placeholder = %@",self.placeholder);
        if(!self.placeholder){
            self.placeholder = @" ";
        }
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
        [self setAttributedPlaceholder:attribute];
    }
    return  obj;
}
@end
