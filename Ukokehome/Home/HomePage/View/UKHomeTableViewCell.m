//
//  UKHomeTableViewCell.m
//  Ukokehome
//
//  Created by ethome on 2018/9/26.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKHomeTableViewCell.h"

@implementation UKHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setModel:(UKDeviceModel *)model{
    
    _deviceNameLabel.text = model.deviceName;
    
    NSString *tempType = [model.property4 isEqualToString:@"1"]?@"℃":@"°F";
    
    [model cherkProperty2SafeArea];
    
    _tempLabel.text = [NSString stringWithFormat:@"%@%@",model.property2,tempType];
    
    if ([model.status isEqualToString:@"offline"]) {
        
        _offlineImgView.hidden = NO;
        
        _statusSwitch.on = NO;

        _backgroundImgView.image = [UIImage imageNamed:@"Background9"];
        
    } else {
        
        _offlineImgView.hidden = YES;
        
        _backgroundImgView.image = [UIImage imageNamed:@"Background6"];
        
        if ([model.status isEqualToString:@"on"]) {
            
            _statusSwitch.on = YES;
            
        } else {
            
            _statusSwitch.on = NO;

        }
        
    }
    
    if ([model.actualDeviceTypeId isAirConditioner]) {
        
        _tempLabel.hidden = NO;
        
        _statusSwitch.hidden = NO;
    }else{
        
        _tempLabel.hidden = YES;
        
        _statusSwitch.hidden = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
