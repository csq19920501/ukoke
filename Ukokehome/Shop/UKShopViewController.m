//
//  UKShopViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/17.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKShopViewController.h"
#import <WebKit/WebKit.h>

@interface UKShopViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) FLAnimatedImageView *loadImageView;

@property (nonatomic,strong) WKWebView *WKWebView;

@end

@implementation UKShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%d",ISIPHONEX);
    
    NSInteger tabbarHeight = 49;
    
    if (ISIPHONEX) {
        tabbarHeight = 83;
    }
    
    self.WKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - tabbarHeight)];
    self.WKWebView.navigationDelegate = self;
    [self.view addSubview:self.WKWebView];
    [self.WKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://ukoke.com/"]]];
    //@"https://ukoke.com/ultrasonic-cleaner-ukoke-professional-ultrasonic-jewelry-cleaner-with-timer-portable-household-ultrasonic-cleaning-machine-for-eyeglasses-watches-rings-diamonds/"   //原来的连接 出现404字样

    _loadImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 20)];
    
    _loadImageView.animatedImage = [UKHelper getGifImageByName:@"Progress"];
    
    _loadImageView.center = self.view.center;
    
    [self.view addSubview:_loadImageView];

    [self.WKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

// 观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        float floatNum = [[change objectForKey:@"new"] floatValue];
        
        if (floatNum > 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.loadImageView removeFromSuperview];
            });
        }
        
    }else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

-(void)dealloc{
    
    [self.WKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
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
