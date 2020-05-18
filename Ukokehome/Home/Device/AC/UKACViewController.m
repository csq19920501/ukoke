//
//  UKACViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/9/26.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKACViewController.h"
#import "UKACTimerViewController.h"
#import "UIImage+GIF.h"
#import "Masonry.h"

#define TAG1 10000
#define TAG2 20000
#define TAG3 30000
#define TAG4 40000

#define ToRad(deg)         ( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)        ( (180.0 * (rad)) / M_PI )
#define SQR(x)            ( (x) * (x) )
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define ANGLE 230.0

@interface UKACViewController ()
@property (weak, nonatomic) IBOutlet UIButton *CFTempBtn;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIButton *swingBtn;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImgVIew;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *modeBtns;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *speedBtns;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tempBgImgView;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (nonatomic, assign) NSInteger minTemp;
@property (nonatomic, assign) NSInteger maxTemp;
@property (nonatomic, copy) NSString *tempType;
@property (nonatomic, assign) CGFloat length;
@property (nonatomic, assign) float angle;
@property (weak, nonatomic) IBOutlet UIButton *settingBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panCenterx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dryCenterx;
@property (nonatomic, assign) int targetTemp;
@end

@implementation UKACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statusImgView.animatedImage = [UKHelper getGifImageByName:@"Graphic"];
    NSLog(@"self.modle %@",self.model);
    [self initViewByModel];
    
    [self checkNewBuild];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:RGB(123, 214, 235)];
    
    
    
    //检测空调定时开关
    NSString *str = [UKAPIList getAPIList].timingInfo;
    [ETAFNetworking postLMK_AFNHttpSrt:str parameters:@{@"did":@([self.model.id intValue])}.mutableCopy success:^(id responseObject) {
        NSString *startTimeHour = responseObject[@"startTimeHour"];
        NSString *timeFlag = responseObject[@"timeFlag"];
      
     
        
        if(timeFlag == nil){
            
            if ([startTimeHour intValue] != 0) {
                
                self.timerButton.selected = YES;

            }else{
                
                self.timerButton.selected = NO;
            }
        }else{
          NSString *timeFlag = responseObject[@"timeFlag"];
            
            if(timeFlag.intValue != 0){
                self.timerButton.selected = YES;
            }else{
                self.timerButton.selected = NO;
            }
        }

    } failure:^(id error) {

    }WithHud:NO AndTitle:@""];
    
    if (APPDELEGATE.hasNew) {
        self.settingBut.badgeCenterOffset = CGPointMake(-8, 12);
        [self.settingBut showBadge];
    }else {
        [self.settingBut clearBadge];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.length = 110;
    
    [self calculateAngleFromTargetTemp];
    
    if (APPDELEGATE.hasNew) {
        self.settingBut.badgeCenterOffset = CGPointMake(-8, 12);
        [self.settingBut showBadge];
    }else {
        [self.settingBut clearBadge];
    }
}
-(void)checkNewBuild{
    NSMutableDictionary *dic = @{@"deviceId":self.model.deviceId}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].wfversionGet parameters:dic success:^(id responseObject) {
        
        NSString *code = responseObject[@"code"];
        
        if ([code integerValue] == VERSION_IS_CANUPDATE) {
            APPDELEGATE.hasNew = YES;
            self.settingBut.badgeCenterOffset = CGPointMake(-8, 12);
            [self.settingBut showBadge];
        }else if ([code integerValue] == VERSION_IS_NEW){
            APPDELEGATE.hasNew = NO;
            [self.settingBut clearBadge];
        }else{
        }
    } failure:^(id error) {
    } WithHud:NO AndTitle:@"Checking..."];
}
- (void)initViewByModel{
//    self.model.property6 = @"1";
    if ([self.model.mode isEqualToString:@"3"]) {
        
       self.model.fanSpeed = @"1";
    }
    
    _tempType = [self.model.property4 isEqualToString:@"1"]?@"℃":@"°F";

    if ([self.model.status isEqualToString:@"on"]) {
        
        _tempBgImgView.hidden = NO;
        _maxTempLabel.hidden = NO;
        _minTempLabel.hidden = NO;
        _bubbleView.hidden = NO;
        _tempLabel.hidden = NO;
        
        [self.model cherkProperty2SafeArea];
        _currentTempLabel.text = [NSString stringWithFormat:@"%@%@",self.model.property2,_tempType];
        
    }else{
        _tempBgImgView.hidden = YES;
        _maxTempLabel.hidden = YES;
        _minTempLabel.hidden = YES;
        _bubbleView.hidden = YES;
        _tempLabel.hidden = YES;
        _currentTempLabel.text = @"OFF";
        
        self.model.mode = @"0";
        self.model.property1 = @"off";
        self.model.fanSpeed = @"0";
    }
    
    if ([self.model.property4 isEqualToString:@"1"]) {
        
        _minTemp = 16;
        
        _maxTemp = 30;
        
        if ([self.model.mode isEqualToString:@"3"] || [self.model.mode isEqualToString:@"4"]) {
            
            [_CFTempBtn setImage:[UIImage imageNamed:@"tempChange_2"] forState:UIControlStateNormal];

        }else{
            
            [_CFTempBtn setImage:[UIImage imageNamed:@"tempChange_1"] forState:UIControlStateNormal];

        }

    }else{
        
        _minTemp = 60;
        
        _maxTemp = 86;
        
        if ([self.model.mode isEqualToString:@"3"] || [self.model.mode isEqualToString:@"4"]) {
            
            [_CFTempBtn setImage:[UIImage imageNamed:@"tempChange_4"] forState:UIControlStateNormal];
            
        }else{
            
            [_CFTempBtn setImage:[UIImage imageNamed:@"tempChange_3"] forState:UIControlStateNormal];
            
        }
    }
    
    _minTempLabel.text = [NSString stringWithFormat:@"%ld%@",_minTemp,_tempType];
    
    _maxTempLabel.text = [NSString stringWithFormat:@"%ld%@",_maxTemp,_tempType];

    [self.model.property1 isEqualToString:@"on"]?(_swingBtn.selected = YES):(_swingBtn.selected = NO);
    
    for (UIButton *btn in _modeBtns) {
        
        if ([self.model.mode integerValue] == btn.tag - TAG1) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    for (UIButton *btn in _speedBtns) {
        
        if ([self.model.fanSpeed integerValue] == btn.tag - TAG2) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    
    if ([self.model.mode isEqualToString:@"3"] || [self.model.mode isEqualToString:@"4"]) {
        
        _bgImgView.image = [UIImage imageNamed:@"heatBg"];
        
        _bubbleImgVIew.highlighted = YES;
        
        _maxTempLabel.textColor = RGB(255, 196, 145);
        
        _minTempLabel.textColor = RGB(255, 196, 145);

    }else{
        
        _bgImgView.image = [UIImage imageNamed:@"Background1"];
        
        _bubbleImgVIew.highlighted = NO;

        _maxTempLabel.textColor = RGB(110, 215, 235);

        _minTempLabel.textColor = RGB(110, 215, 235);
    }
    
    if (!self.isPaning) {
        
        _tempLabel.text = [NSString stringWithFormat:@"%@%@",self.model.targetTemp,_tempType];

        [self calculateAngleFromTargetTemp];

    }

    if ([self.model.property6 isEqualToString:@"1"]) {
        //单冷
        UIButton *but = (UIButton *)[self.view viewWithTag:10004];
        but.hidden = YES;
        
        UIButton *coolBut = (UIButton *)[self.view viewWithTag:10001];
        UIButton *but2 = (UIButton *)[self.view viewWithTag:10002];
        UIButton *but3 = (UIButton *)[self.view viewWithTag:10003];
        
        [self.panCenterx setActive:NO];
        [self.dryCenterx setActive:NO];
        [but2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(coolBut.mas_centerX).offset(0);
        }];
        [but3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.swingBtn.mas_centerX).offset(0);
        }];
        
    }else if ([self.model.property6 isEqualToString:@"2"]) {
        //单暖
        UIButton *but = (UIButton *)[self.view viewWithTag:10001];
        but.hidden = YES;
    }else{
        
    }
    
}

- (void)initViewWhileSetFail{
    
    _tempLabel.text = [NSString stringWithFormat:@"%@%@",self.model.targetTemp,_tempType];

    [self calculateAngleFromTargetTemp];

}

- (IBAction)statusAction:(id)sender {
    
    [self setDeviceKey:@"status" andValue:[self.model.status isEqualToString:@"on"]?@"off":@"on"];

}

- (IBAction)tempTypeAction:(UIButton *)sender {
    
    [self setDeviceKey:@"property4" andValue:[self.model.property4 isEqualToString:@"1"]?@"2":@"1"];

}

- (IBAction)modeAction:(UIButton *)sender {
    
    [self setDeviceKey:@"mode" andValue:[NSString stringWithFormat:@"%ld",sender.tag - TAG1]];
    
}
- (IBAction)swingAction:(UIButton *)sender {
    
    [self setDeviceKey:@"property1" andValue:[self.model.property1 isEqualToString:@"on"]?@"off":@"on"];
    
}
- (IBAction)timeAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"UKACTimerViewController" sender:nil];
//    UKACTimerViewController *view = [[UKACTimerViewController alloc]initWithNibName:@"UKACTimerViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:view animated:YES];

}

- (IBAction)speedAction:(UIButton *)sender {
    
    if ([self.model.mode isEqualToString:@"3"]) {
        
        [HUD showAlertWithText:@"Wind speed cannot be set under Dry mode"];
        
        return;
    }
    [self setDeviceKey:@"fanSpeed" andValue:[NSString stringWithFormat:@"%ld",sender.tag - TAG4]];

}

- (IBAction)settingAction:(id)sender {
    [self gotoSetting];
}

- (IBAction)panAction:(UIPanGestureRecognizer *)sender {
    
    if ([self.model.mode isEqualToString:@"2"] || [self.model.mode isEqualToString:@"3"]) {
        
        [HUD showAlertWithText:@"TargetTemp cannot be set under Fan mode and Dry mode"];
        
        return;
    }
    
    if(sender.state == UIGestureRecognizerStateChanged)
    {
        self.isPaning = YES;
        
        CGPoint point = [sender locationInView:self.view];
        
        CGPoint lastPoint  = point;
        
        float currentAngle = angleFromNorth(CGPointMake(self.backgroundView.center.x, self.backgroundView.center.y), lastPoint, NO);
        
        NSLog(@"currentAngle = %ld",(long)currentAngle);
        
        if(currentAngle > ANGLE || currentAngle < 0)
        {
            return;
        }
        
        //计算手指与大圆圆心距离
        CGFloat bigXSpace = point.x - self.backgroundView.center.x;
        CGFloat bigYSpace = point.y - self.backgroundView.center.y;
        CGFloat bigSpace = sqrt(bigXSpace * bigXSpace + bigYSpace * bigYSpace);
        //计算手指与大圆横坐标距离与圆心距离的比例
        CGFloat zBigXSpace = bigXSpace >= 0 ? bigXSpace : -bigXSpace;
        CGFloat bigRatio = zBigXSpace / bigSpace;
        //计算小圆与大圆横坐标距离
        CGFloat zSmallXSpace = self.length * bigRatio;
        //计算小圆与大圆纵坐标距离
        CGFloat zSmallYSpace = sqrt(self.length * self.length - zSmallXSpace * zSmallXSpace);
        //确定小圆位置
        CGFloat smallXSpace = (point.x > self.backgroundView.center.x) ? zSmallXSpace : -zSmallXSpace;
        CGFloat smallYSpace = (point.y > self.backgroundView.center.y) ? zSmallYSpace : -zSmallYSpace;
        self.bubbleView.center = CGPointMake(self.backgroundView.center.x + smallXSpace, self.backgroundView.center.y + smallYSpace);
        
        self.tempLabel.center = CGPointMake(self.backgroundView.center.x + smallXSpace, self.backgroundView.center.y + smallYSpace);
        
        self.targetTemp = [self calculateTargetTempFromAngle:currentAngle];
        
        _tempLabel.text = [NSString stringWithFormat:@"%d%@",self.targetTemp,_tempType];
        
        _currentTempLabel.frame =  _currentTempLabel.superview.bounds;
        
        _currentTempLabel.text = [NSString stringWithFormat:@"%d%@",self.targetTemp,_tempType];
        
        self.angle = currentAngle;

    }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled || sender.state ==  UIGestureRecognizerStateFailed){
        
        
       
        [self.model cherkProperty2SafeArea];
        
        _currentTempLabel.text = [NSString stringWithFormat:@"%@%@",self.model.property2,_tempType];
        
        [self setDeviceKey:@"targetTemp" andValue:[NSString stringWithFormat:@"%d",self.targetTemp]];

    }
    
}


-(void)calculateAngleFromTargetTemp
{
    //计算角度
    
    self.targetTemp = [self.model.targetTemp floatValue];
    
    self.angle = (self.targetTemp - _minTemp) * ANGLE / (_maxTemp - _minTemp);
    
    if(self.angle > ANGLE){
        self.angle = ANGLE;
    }
    if(self.angle < 0){
        self.angle = 0;
    }
    
    self.bubbleView.center = [self getXYFromAngle:self.angle];
    
    self.tempLabel.center = [self getXYFromAngle:self.angle];
 
}

-(float)calculateTargetTempFromAngle:(float)angle
{
    //计算角度
    
    float result = ANGLE / (_maxTemp - _minTemp);
    
    float targetTemp = angle / result + _minTemp;
    
    NSLog(@"%f",targetTemp);
    if (targetTemp < _minTemp) {
        targetTemp = _minTemp;
    }else if (targetTemp > _maxTemp){
        targetTemp = _maxTemp;
    }else{
        
        targetTemp = [NSString stringWithFormat:@"%.f",targetTemp].floatValue;
    }
    
    return [NSString stringWithFormat:@"%.1f",targetTemp].intValue;
}

static inline float angleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    result += 90;
    return (result >=0  ? result : result + 360);
}

- (CGPoint)getXYFromAngle:(float)angle
{
    CGPoint circlePoint;
    float y = self.backgroundView.center.y - self.length * cos(ToRad(angle));
    float x = self.backgroundView.center.x + self.length * sin(ToRad(angle));
    
    circlePoint = CGPointMake(x,y);
    return circlePoint;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UKACTimerViewController *controller = segue.destinationViewController;
    
    controller.model = self.model;
    
//    UKACTimerViewController *controller2 = [[UKACTimerViewController alloc]init];
//    controller2.model = self.model;
}


@end
