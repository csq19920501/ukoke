//
//  UKUpDetailViewController.h
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKUpDetailViewController : UIViewController

@property (nonatomic, strong) UKDeviceModel *model;

@property (nonatomic, copy) NSString *updateDetail;
@end

NS_ASSUME_NONNULL_END
