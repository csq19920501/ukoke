//
//  UKHomeCollectionViewCell.h
//  Ukokehome
//
//  Created by ethome on 2018/9/26.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKHomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deviceImgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *offlineImgView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgView;

@property (nonatomic, strong) UKDeviceModel *model;
@end

NS_ASSUME_NONNULL_END
