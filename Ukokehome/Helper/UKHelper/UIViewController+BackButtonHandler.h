//
//  UIViewController+BackButtonHandler.h
//  Ethome
//
//  Created by YoloMao on 15/10/30.
//  Copyright © 2015年 Whalefin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 http://stackoverflow.com/posts/comments/34452906
 */

@protocol BackButtonHandlerProtocol

@optional

// Override this method in UIViewController derived class to handle 'Back' button click

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
