//
//  UKFilterViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/9/27.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKFilterViewController.h"
#import "UKFilterDetailViewController.h"

@interface UKFilterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *shortageImgView;
@property (weak, nonatomic) IBOutlet UILabel *shortageLabel;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *standbyImgView;
@property (weak, nonatomic) IBOutlet UILabel *standbyLabel;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *flushImgView;
@property (weak, nonatomic) IBOutlet UILabel *flushLabel;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *workingImgView;
@property (weak, nonatomic) IBOutlet UILabel *workingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leakageImgView;
@property (weak, nonatomic) IBOutlet UILabel *leakageLabel;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *waterImgView;
@property (weak, nonatomic) IBOutlet UIImageView *flushBgImgView;
@property (weak, nonatomic) IBOutlet UILabel *tdsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tdsUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waterQualityImgView;
@property (weak, nonatomic) IBOutlet UILabel *waterQualityLabel;

@end

@implementation UKFilterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewByModel];

    // Do any additional setup after loading the view.
}

- (void)initViewByModel{

    if ([self.model.property1 isEqualToString:@"yes"]) {
        _shortageImgView.highlighted = NO;
        _shortageLabel.textColor = RGB(252, 13, 27);
    }else{
        _shortageImgView.highlighted = YES;
        _shortageLabel.textColor = [UIColor whiteColor];
    }
 
    if ([self.model.property2 isEqualToString:@"yes"]) {
        _standbyImgView.image = [UIImage imageNamed:@"Standby"];
        _standbyLabel.textColor = [UIColor whiteColor];
    }else{
        _standbyImgView.animatedImage = [UKHelper getGifImageByName:@"standby"];
        _standbyLabel.textColor = RGB(252, 13, 27);
    }
    
    if ([self.model.property3 isEqualToString:@"on"]) {
        _flushImgView.animatedImage = [UKHelper getGifImageByName:@"flush"];
        _flushBgImgView.highlighted = NO;
        _flushLabel.textColor = RGB(252, 13, 27);
    }else{
        _flushImgView.image = [UIImage imageNamed:@"Flush"];
        _flushBgImgView.highlighted = YES;
        _flushLabel.textColor = [UIColor whiteColor];
    }
    
    if ([self.model.property4 isEqualToString:@"yes"]) {
        _workingImgView.animatedImage = [UKHelper getGifImageByName:@"working"];
        _workingLabel.textColor = RGB(252, 13, 27);
    }else{
        _workingImgView.image = [UIImage imageNamed:@"Working"];
        _workingLabel.textColor = [UIColor whiteColor];
    }
    
    if ([self.model.property5 isEqualToString:@"yes"]) {
        _leakageImgView.highlighted = NO;
        _leakageLabel.textColor = RGB(252, 13, 27);
    }else{
        _leakageImgView.highlighted = YES;
        _leakageLabel.textColor = [UIColor whiteColor];
    }
    
    _tdsLabel.text = self.model.property6;
    
    if ([self.model.property6 integerValue] > 15) {
        _waterImgView.animatedImage = [UKHelper getGifImageByName:@"YellowWater"];
        _waterQualityImgView.highlighted = YES;
        _waterQualityLabel.text = @"Not drinkable";
        _waterQualityLabel.textColor = [UIColor yellowColor];
    }else{
        _waterImgView.animatedImage = [UKHelper getGifImageByName:@"Water"];
        _waterQualityImgView.highlighted = NO;
        _waterQualityLabel.text = @"Water Quality Good";
        _waterQualityLabel.textColor = [UIColor whiteColor];
    }

}

- (IBAction)settingAction:(id)sender {
    
    [self gotoSetting];
}

- (IBAction)detailAction:(id)sender {
    
    [self performSegueWithIdentifier:@"UKFilterDetailViewController" sender:nil];
}
- (IBAction)flushAction:(UITapGestureRecognizer *)sender {
    
    if ([self.model.property1 isEqualToString:@"yes"]) {
        [HUD showAlertWithText:@"The Water Filter is shortaging"];
        return;
    }
    
    if ([self.model.property5 isEqualToString:@"yes"]) {
        [HUD showAlertWithText:@"The Water Filter is leaking"];
        return;
    }
    [self setDeviceKey:@"property3" andValue:@"on"];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UKFilterDetailViewController *controller = segue.destinationViewController;
    controller.model = self.model;
}


@end
