//
//  UKDndTimeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/19.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKDndTimeViewController.h"

@interface UKDndTimeViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *onDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *offDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeShowLabel;
@property (nonatomic, copy) NSString *onDateStr;
@property (nonatomic, copy) NSString *offDateStr;

@end

@implementation UKDndTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];

    // Do any additional setup after loading the view.
}

- (void)initView{
    
    [_onDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    [_offDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    _onDatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    _offDatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    [_onDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    [_offDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    formatter.dateFormat = @"HH:mm";
    NSDate *onDate = [formatter dateFromString:[GlobalKit shareKit].dndStart];
    NSDate *offDate = [formatter dateFromString:[GlobalKit shareKit].dndEnd];
    
    self.onDatePicker.date = onDate;
    
    self.offDatePicker.date = offDate;
    
    [self initShowTimeLabelWithStartDate:onDate endDate:offDate];
}

- (void)initShowTimeLabelWithStartDate:(NSDate *)onDate endDate:(NSDate *)offDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    formatter.dateFormat = @"hh:mm a";
    NSString *startDateStr = [formatter  stringFromDate:onDate];
    NSString *endDateStr = [formatter  stringFromDate:offDate];
    
    _onDateStr = startDateStr;
    _offDateStr = endDateStr;
    self.timeShowLabel.text = [NSString stringWithFormat:@"%@ - %@",_onDateStr, _offDateStr];

}

- (IBAction)saveAction:(id)sender {
    
    _onDateStr = [_onDateStr stringByReplacingOccurrencesOfString:@" " withString:@":"];
    
    _offDateStr = [_offDateStr stringByReplacingOccurrencesOfString:@" " withString:@":"];
    
    NSArray *onDateArr = [_onDateStr componentsSeparatedByString:@":"];
    
    NSArray *offDateArr = [_offDateStr componentsSeparatedByString:@":"];
    
    NSString *startTimeHour = [[onDateArr lastObject] isEqualToString:@"PM"]?[NSString stringWithFormat:@"%ld",[[onDateArr firstObject] integerValue] +12]:[onDateArr firstObject];
    
    NSString *startTimeMinute = onDateArr[1];
    
    NSString *endTimeHour = [[offDateArr lastObject] isEqualToString:@"PM"]?[NSString stringWithFormat:@"%ld",[[offDateArr firstObject] integerValue] +12]:[offDateArr firstObject];
    
    NSString *endTimeMinute = offDateArr[1];
    
    NSTimeZone *systemTimeZone = [NSTimeZone
                                  systemTimeZone];
    
    NSInteger zone = [systemTimeZone secondsFromGMT]/60/60;
    
    NSMutableDictionary *params = @{@"dndStart":[NSString stringWithFormat:@"%@:%@",startTimeHour,startTimeMinute],@"dndEnd":[NSString stringWithFormat:@"%@:%@",endTimeHour,endTimeMinute],@"timeZone":@(zone)}.mutableCopy;
    
    NSString *str = [UKAPIList getAPIList].userSetting;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:params success:^(id responseObject) {
        
        [GlobalKit shareKit].dndStart = [NSString stringWithFormat:@"%@:%@",startTimeHour,startTimeMinute];
        
        [GlobalKit shareKit].dndEnd = [NSString stringWithFormat:@"%@:%@",endTimeHour,endTimeMinute];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Save success"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"Saving..."];
    
}


- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    formatter.dateFormat = @"hh:mm a";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    
    if (datePicker == _onDatePicker) {
        
        _onDateStr = dateStr;
    }else{
        
        _offDateStr = dateStr;
    }
    
    self.timeShowLabel.text = [NSString stringWithFormat:@"%@ - %@",_onDateStr, _offDateStr];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
