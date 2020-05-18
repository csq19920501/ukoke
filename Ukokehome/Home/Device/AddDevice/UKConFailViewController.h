//
//  UKConFailViewController.h
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTypeBlock)(BOOL isSoftAp);
NS_ASSUME_NONNULL_BEGIN

@interface UKConFailViewController : UIViewController

@property (nonatomic, copy) ReturnTypeBlock returnTypeBlock;

@end

NS_ASSUME_NONNULL_END
