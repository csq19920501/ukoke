//
//  UKUpDetailViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/16.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKUpDetailViewController.h"
#import "UKUpdateViewController.h"

@interface UKUpDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *upDetailLabel;

@end

@implementation UKUpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _upDetailLabel.text = [_updateDetail stringByReplacingOccurrencesOfString:@"#"withString:@"\n"];
    
    // Do any additional setup after loading the view.
}
- (IBAction)updateAction:(id)sender {
//     APPDELEGATE.hasNew = NO;
    NSMutableDictionary *dic = @{@"deviceId":self.model.deviceId}.mutableCopy;

    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].wfversionUpgrade parameters:dic success:^(id responseObject) {

        [self performSegueWithIdentifier:@"UKUpdateViewController" sender:nil];
        APPDELEGATE.hasNew = NO;

    } failure:^(id error) {

    } WithHud:YES AndTitle:@"Checking..."];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UKUpdateViewController *controller = segue.destinationViewController;
    
    controller.model = self.model;
}


@end
