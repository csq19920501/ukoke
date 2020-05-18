//
//  UKMsgsTableViewCell.h
//  Ukokehome
//
//  Created by ethome on 2018/10/20.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UKMsgsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) UKMessageModel *model;

@end

NS_ASSUME_NONNULL_END
