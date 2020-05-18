//
//  UKEditProfileViewController.h
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UKEditProfileViewController : UIViewController

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) BOOL isEdit;

@end

NS_ASSUME_NONNULL_END
