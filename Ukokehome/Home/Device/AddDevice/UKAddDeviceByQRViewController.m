//
//  UKAddDeviceViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/15.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKAddDeviceByQRViewController.h"
#import "UKEnteWiFiViewController.h"

@interface UKAddDeviceByQRViewController ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *showLabels;
@property (weak, nonatomic) IBOutlet UIImageView *showImgView;

@end

@implementation UKAddDeviceByQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.showImgView];
    
    for (UILabel *label in _showLabels) {
        
        [self.view bringSubviewToFront:label];

    }
    
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array isScan:(BOOL)scan
{
    if (!array || array.count < 1)
    {
        [self scanFailIsScan:scan];
        
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString *strResult = scanResult.strScanned;
    
    if (!strResult) {
        
        [self scanFailIsScan:scan];
        
        return;
    }
    
    if (scan) {
        
        [self scanCompletionWithResult:strResult];
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self scanCompletionWithResult:strResult];
            
        });
    }
    
}

- (void)scanFailIsScan:(BOOL) scan{
    
    if (scan) {
        
        [self reStartDevice];
        
    }else{
        
        [self getScanDataString:@"Please enlarge the qr code in the album to recognize it" reScan:NO];
        
    }
}

-(void)getScanDataString:(NSString *)message reScan:(BOOL) scan{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (scan) {
            
            [self reStartDevice];
            
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scanCompletionWithResult:(NSString *)strQRcode{
    
    BOOL isTrueDevice = NO;
    
    if ([strQRcode hasPrefix:@"typeId="]) {
        
        isTrueDevice = YES;

    }
    
    NSString *typeId;
    
    if (isTrueDevice) {
        
        typeId = [strQRcode substringWithRange:NSMakeRange(7, 4)];
        
        [GlobalKit shareKit].deviceType = typeId;
        
        [self performSegueWithIdentifier:@"UKEnteWiFiViewController" sender:nil];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD showAlertWithText:@"Code scanning type Error"];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"UKEnteWiFiViewController"]) {
                
        [GlobalKit shareKit].isSoftAp = NO;
        
    }
}


@end
