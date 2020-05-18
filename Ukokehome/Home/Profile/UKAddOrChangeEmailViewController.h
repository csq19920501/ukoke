//
//  UKAddOrChangeEmailViewController.h
//  Ukokehome
//
//  Created by ethome on 2019/3/20.
//  Copyright © 2019 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UKEmailBlock)(NSString *email);

@interface UKAddOrChangeEmailViewController : UIViewController
@property (nonatomic, copy) UKEmailBlock emailBlock;

@end

NS_ASSUME_NONNULL_END
