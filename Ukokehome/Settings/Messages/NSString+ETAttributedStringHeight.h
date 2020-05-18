//
//  NSString+ETAttributedStringHeight.h
//  Ethome
//
//  Created by YoloMao on 15/12/24.
//  Copyright © 2015年 Whalefin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ETAttributedStringHeight)

- (NSString *)getSuitableHeightWithString:(NSString *)string WithWidth:(CGFloat)width;

@end
