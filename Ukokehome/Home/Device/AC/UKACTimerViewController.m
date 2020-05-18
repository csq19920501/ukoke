//
//  UKACTimerViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKACTimerViewController.h"

@interface UKACTimerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *onDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *offDatePicker;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch; //enable
@property (weak, nonatomic) IBOutlet UILabel *timeShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *allTimeLabel;
@property (nonatomic, copy) NSString *onDateStr;
@property (nonatomic, copy) NSString *offDateStr;
@property (weak, nonatomic) IBOutlet UISwitch *repeatSwitch; //repeat
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repeatLabelHeight;


@end

@implementation UKACTimerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getTimeInfo];

}
- (IBAction)repeatChange:(id)sender {
    UISwitch *repeatSwith = sender;
    if (!repeatSwith.on) {
        self.repeatLabelHeight.constant = 0;
    }else{
        self.repeatLabelHeight.constant = 20.5;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"acTimerviewViewDidLoad");
    [self initView];
    
    // Do any additional setup after loading the view.
}

- (void)getTimeInfo{
    
    NSString *str = [UKAPIList getAPIList].timingInfo;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:@{@"did":@([self.model.id intValue])}.mutableCopy success:^(id responseObject) {

        NSString *startTimeHour = responseObject[@"startTimeHour"];
        NSString *startTimeMinute = responseObject[@"startTimeMinute"];
        NSString *endTimeHour = responseObject[@"endTimeHour"];
        NSString *endTimeMinute = responseObject[@"endTimeMinute"];
        NSString *repeatFlag = responseObject[@"repeatFlag"];
        NSString *timeFlag = responseObject[@"timeFlag"];
        if ([startTimeHour intValue] != 0) {
            
            self.onDateStr = [NSString stringWithFormat:@"%@:%@",startTimeHour,startTimeMinute];
            
            self.offDateStr = [NSString stringWithFormat:@"%@:%@",endTimeHour,endTimeMinute];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            
            formatter.dateFormat = @"HH:mm";
            NSDate *onDate = [formatter dateFromString:self.onDateStr];
            NSDate *offDate = [formatter dateFromString:self.offDateStr];
            
            self.onDatePicker.date = onDate;
            
            self.offDatePicker.date = offDate;
            
            [self initShowTimeLabelWithStartDate:self.onDatePicker.date endDate:self.offDatePicker.date];
            self.enableSwitch.on = [timeFlag boolValue]?YES:NO;
            self.repeatSwitch.on = [repeatFlag boolValue]?YES:NO;
            if (!self.repeatSwitch.on) {
                self.repeatLabelHeight.constant = 0;
            }else{
                self.repeatLabelHeight.constant = 20.5;
            }
        }
        if(timeFlag == nil){
            self.enableSwitch.on = YES;
        }

    } failure:^(id error) {
        
    }WithHud:YES AndTitle:@"Refreshing..."];
}

- (void)initView{
    
    [_onDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    [_offDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    _onDatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    _offDatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    [_onDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];

    [_offDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    [self initShowTimeLabelWithStartDate:[NSDate date] endDate:[NSDate date]];
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
    NSDate* startDate = [self getNowDateFromatAnDate:[formatter dateFromString:_onDateStr]];
    NSDate* endDate = [self getNowDateFromatAnDate:[formatter dateFromString:_offDateStr]];
    
    [self pleaseInsertStarTimeo:startDate andInsertEndTime:endDate];
}

- (IBAction)saveAction:(id)sender {
    
    NSTimeZone *systemTimeZone = [NSTimeZone
                                  systemTimeZone];
    
    NSInteger zone = [systemTimeZone secondsFromGMT]/60/60;
    
    _onDateStr = [_onDateStr stringByReplacingOccurrencesOfString:@" " withString:@":"];
    
    _offDateStr = [_offDateStr stringByReplacingOccurrencesOfString:@" " withString:@":"];

    NSArray *onDateArr = [_onDateStr componentsSeparatedByString:@":"];
    
    NSArray *offDateArr = [_offDateStr componentsSeparatedByString:@":"];
    
    NSString *startTimeHour = [[onDateArr lastObject] isEqualToString:@"PM"]?[NSString stringWithFormat:@"%ld",[[onDateArr firstObject] integerValue] +12]:[onDateArr firstObject];
    
    NSString *startTimeMinute = onDateArr[1];
    
    NSString *endTimeHour = [[offDateArr lastObject] isEqualToString:@"PM"]?[NSString stringWithFormat:@"%ld",[[offDateArr firstObject] integerValue] +12]:[offDateArr firstObject];
    
    NSString *endTimeMinute = offDateArr[1];
    
    NSString *repaetFlag = _repeatSwitch.on?@"1":@"0";
    NSString *timeFlag = _enableSwitch.on?@"1":@"0";
    
    NSMutableDictionary *params = @{@"timeZone":@(zone),@"startTimeHour":startTimeHour,@"startTimeMinute":startTimeMinute,@"endTimeHour":endTimeHour,@"endTimeMinute":endTimeMinute,@"repeatFlag":repaetFlag,@"timeFlag":timeFlag,@"did":@([self.model.id intValue])}.mutableCopy;
    
    NSLog(@"params = %@",params);

    NSString *str = [UKAPIList getAPIList].timingSet;
    
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:params success:^(id responseObject) {
        
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
    NSDate* startDate = [self getNowDateFromatAnDate:[formatter dateFromString:_onDateStr]];
    NSDate* endDate = [self getNowDateFromatAnDate:[formatter dateFromString:_offDateStr]];

    [self pleaseInsertStarTimeo:startDate andInsertEndTime:endDate];
    
    self.timeShowLabel.text = [NSString stringWithFormat:@"%@ - %@",_onDateStr, _offDateStr];
    
}

- (void)pleaseInsertStarTimeo:(NSDate *)startDate andInsertEndTime:(NSDate *)endDate{
    
    if ([_onDateStr containsString:@"PM"] && [_offDateStr containsString:@"AM"]) {
        
        endDate = [endDate dateByAddingTimeInterval:24*60*60];
        
    }else if (([_onDateStr containsString:@"AM"] && [_offDateStr containsString:@"AM"]) || ([_onDateStr containsString:@"PM"] && [_offDateStr containsString:@"PM"])){
        
        if ([_offDateStr compare:_onDateStr] < 0) {
            
            endDate = [endDate dateByAddingTimeInterval:24*60*60];

        }
    }

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *cmps = [calendar components:type fromDate:startDate toDate:endDate options:0];

    NSLog(@"两个时间相差%ld小时%ld分钟",cmps.hour, cmps.minute);
    
    _allTimeLabel.text = [NSString stringWithFormat:@"%ld hours %ld minutes",cmps.hour, cmps.minute];
}


- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
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
