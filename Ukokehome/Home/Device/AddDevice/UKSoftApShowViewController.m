//
//  UKSoftApShowViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/23.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKSoftApShowViewController.h"
#import "UKEnteWiFiViewController.h"

@interface UKSoftApShowViewController ()

@end

@implementation UKSoftApShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)continueAction:(id)sender {
    
    [self performSegueWithIdentifier:@"UKSoftApEnteWiFiViewController" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [GlobalKit shareKit].isSoftAp = YES;
}


@end
