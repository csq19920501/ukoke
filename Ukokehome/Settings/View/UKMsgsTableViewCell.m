//
//  UKMsgsTableViewCell.m
//  Ukokehome
//
//  Created by ethome on 2018/10/20.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKMsgsTableViewCell.h"

@implementation UKMsgsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UKMessageModel *)model{
    
    _titleLabel.text = model.title;
    
    _messageLabel.text = model.messageInfo;
    
    _timeLabel.text = [UKHelper timeByDateString:model.createDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
