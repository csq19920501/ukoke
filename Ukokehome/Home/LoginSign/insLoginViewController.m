//
//  insLoginViewController.m
//  Ukokehome
//
//  Created by ethome on 2019/9/4.
//  Copyright © 2019 ethome. All rights reserved.
//

#import "insLoginViewController.h"
#import "InstagramKit.h"
#import <WebKit/WebKit.h>
@interface insLoginViewController ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property(nonatomic,assign)BOOL hasLogin;
@end

@implementation insLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[InstagramEngine sharedEngine] logout];
    self.title = @"instagram";

    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}
-(void)viewDidLayoutSubviews{
    
    [[InstagramEngine sharedEngine] logout];
    
    WKWebViewConfiguration *webConfiguration = [[WKWebViewConfiguration alloc] init];
    webConfiguration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.backView.frame configuration:webConfiguration];
    webView.scrollView.bounces = NO;
    
    //    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:InstagramKitLoginScopeBasic];
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL];
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
    [webView loadRequest:request];
    [HUD showUIBlockingIndicator];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [HUD hideUIBlockingIndicator];
    });
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"csq___ 111 ___%@",navigationResponse.response.URL);
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:navigationResponse.response.URL error:&error]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
        
         NSLog(@"Navigation___ 111 ___%@",navigationResponse.response.URL);
        [self getUserinfo];
    }else{
        NSLog(@"Navigation___ 222 ___%@",navigationResponse.response.URL);
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    [HUD hideUIBlockingIndicator];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"csq___ 222 ___%@",navigationAction.request.URL);
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:navigationAction.request.URL error:&error]) {
        decisionHandler(WKNavigationActionPolicyCancel);
       NSLog(@"Navigation___ 333 ___%@",navigationAction.request.URL);
        [self getUserinfo];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
        NSLog(@"Navigation___ 444 ___%@",navigationAction.request.URL);
    }
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
   NSLog(@"Navigation___ 555 ___");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"Navigation___ 666 ___");
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getUserinfo{
    if(self.hasLogin){
        return;
    }else{
        self.hasLogin = YES;
    }
    __weak typeof(self) weakSelf = self;
    [HUD showUIBlockingIndicator];
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:
     ^(InstagramUser* user){
         [HUD hideUIBlockingIndicator];
                      NSLog(@"csq___name___   %@",user.username);
                      NSLog(@"csq__id___   %@",user.Id);
         weakSelf.insLoginBlack(user.username, user.Id);
         [[InstagramEngine sharedEngine] logout];
         [self.navigationController popViewControllerAnimated:YES];
     }
                                                          failure:^(NSError* error, NSInteger serverStatusCode, NSDictionary *response){
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  [HUD showAlertWithText:@"Login failed"];
                                                                  
                                                              });
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                  weakSelf.insLoginBlack(nil, nil);
                                                                  [[InstagramEngine sharedEngine] logout];
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              });
                                                              
                                                          }];
}
@end
