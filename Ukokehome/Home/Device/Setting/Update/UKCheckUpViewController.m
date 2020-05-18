//
//  UKCheckUpViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKCheckUpViewController.h"
#import "UKUpDetailViewController.h"

@interface UKCheckUpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *upgradeBut;



@property (nonatomic, copy) NSString *updateDetail;


@end

@implementation UKCheckUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{
//    if (APPDELEGATE.hasNew) {
//
//
//        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"Upgrade(new)"];
//
//        [AttributedStr addAttribute:NSFontAttributeName
//
//                              value:[UIFont systemFontOfSize:15.0]
//
//                              range:NSMakeRange(0, 7)];
//        [AttributedStr addAttribute:NSFontAttributeName
//
//                              value:[UIFont systemFontOfSize:12.0]
//
//                              range:NSMakeRange(7, 5)];
//
//        [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                              value:[UIColor redColor]
//
//                              range:NSMakeRange(7, 5)];
//        [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                              value:[UIColor whiteColor]
//
//                              range:NSMakeRange(0, 7)];
//
//
//        [self.upgradeBut setAttributedTitle:AttributedStr forState:UIControlStateNormal];
//
//
//    }else {
//        self.upgradeBut.titleLabel.text = @"Upgrade";
//    }
}
- (IBAction)updateAction:(id)sender {
    
    NSMutableDictionary *dic = @{@"deviceId":self.model.deviceId}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].wfversionGet parameters:dic success:^(id responseObject) {
        
        NSString *code = responseObject[@"code"];
        
        if ([code integerValue] == VERSION_IS_CANUPDATE) {
            
            self.updateDetail = responseObject[@"memo"];

            [self performSegueWithIdentifier:@"UKUpDetailViewController" sender:nil];
            APPDELEGATE.hasNew = YES;
//             [self.upgradeBut showBadge];
            
        }else if ([code integerValue] == VERSION_IS_NEW){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showAlertWithText:@"The device is the latest version"];
            });
            APPDELEGATE.hasNew = NO;
//            [self.upgradeBut clearBadge];
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD showAlertWithText:@"The device is updating"];
            });
        }
        
    } failure:^(id error) {
    } WithHud:YES AndTitle:@"Checking..."];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UKUpDetailViewController *controller = segue.destinationViewController;
    
    controller.updateDetail = self.updateDetail;
    
    controller.model = self.model;
}


@end
