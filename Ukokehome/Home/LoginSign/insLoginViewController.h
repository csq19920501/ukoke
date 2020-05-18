//
//  insLoginViewController.h
//  Ukokehome
//
//  Created by ethome on 2019/9/4.
//  Copyright © 2019 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^InsLoginBlack)(NSString* _Nullable name,NSString * _Nullable Id);
NS_ASSUME_NONNULL_BEGIN

@interface insLoginViewController : UIViewController
@property(nonatomic,copy)InsLoginBlack _Nullable insLoginBlack;
@end

NS_ASSUME_NONNULL_END
