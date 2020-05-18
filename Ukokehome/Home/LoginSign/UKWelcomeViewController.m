//
//  UKWelcomeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/15.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKWelcomeViewController.h"
#import "UKProfileViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TWTRKit.h>
#import "insLoginViewController.h"
#import "AppDelegate.h"
@interface UKWelcomeViewController ()

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *thirdId;

@property (nonatomic, copy) NSString *email;

@end

@implementation UKWelcomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [GlobalKit shareKit].isInLogin = YES;
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [[Twitter sharedInstance].sessionStore reloadSessionStore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GIDSignInButton class];
    
  
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.presentingViewController = self;
    //    [GIDSignIn sharedInstance].scopes = @[ @"email" ];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [GlobalKit shareKit].isInLogin = NO;

}

- (IBAction)thirdLoginAction:(UIButton *)sender {
    //郁闷 ，shardSDK用的好好地，安卓有问题。经理要求ios一起改回原生的sdk做第三方登录
    [HUD showUIBlockingIndicator];
    
    SSDKPlatformType type;

    if (sender.tag == 10001) {
        
        type = SSDKPlatformTypeFacebook;
        [self faceBookLogin];
        return;
        
    }else if (sender.tag == 10002){
//        type = SSDKPlatformTypeGooglePlus;
        [[GIDSignIn sharedInstance]signIn];
        return;
        
    }else if (sender.tag == 10003){
        [HUD hideUIBlockingIndicator];
        return;
//        type = SSDKPlatformTypeInstagram;
       
    }else{
        //原生的sdk不支持网页第三方登录，故手机没装twitter时，用的shardSDK在网页第三方登录
//        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
//            NSLog(@"Install twitter");
//            [self twitterLogin];
//            return;
//        }else{
//            NSLog(@"unInstall twitter ");
            type = SSDKPlatformTypeTwitter;
//        }
    }
    
    [ShareSDK cancelAuthorize:type  result:nil]; 
    
    [SSDKAuthViewStyle setNavigationBarBackgroundColor:[UIColor whiteColor]];
    
    [SSDKAuthViewStyle setTitleColor:[UIColor blackColor]];
    
    [SSDKAuthViewStyle setCancelButtonLabelColor:[UIColor blackColor]];
    
    [ShareSDK getUserInfo:type
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         [HUD hideUIBlockingIndicator];
         
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"rawData=%@",user.rawData);

             self.userName = user.nickname;
             self.thirdId = user.uid;
             if (type == SSDKPlatformTypeFacebook) {
                 
                 if (user.rawData[@"email"]) {
                     self.email = user.rawData[@"email"];
                 }
                 
             }else if (type == SSDKPlatformTypeGooglePlus){
                 
                 if ([user.rawData[@"emails"] isKindOfClass:[NSArray class]]) {
                     
                     self.email = [user.rawData[@"emails"] firstObject][@"value"];

                 }
             }
             
             [self loginWithThirdType:type];
             
         }else
         {
             NSLog(@"%@",error);
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 
                 [HUD showAlertWithText:@"Login failed"];

             });
         }
         
     }];

}

- (void)loginWithThirdType:(SSDKPlatformType) type{
    
    NSString *loginType;
    
    if (type == SSDKPlatformTypeFacebook) {
        loginType = @"facebook";
    }else if (type == SSDKPlatformTypeGooglePlus){
        loginType = @"google";
    }else if (type == SSDKPlatformTypeInstagram){
        loginType = @"instagram";
    }else{
        loginType = @"twitter";
    }
    
    NSMutableDictionary *params = @{@"thirdId":self.thirdId,@"userName":self.userName, @"loginType":loginType}.mutableCopy;
    
    if ([GlobalKit shareKit].clientId) {
        
        [params setObject:[GlobalKit shareKit].clientId forKey:@"clientId"];
        
    }else{
        
        [HUD showAlertWithText:@"Service error"];
        return;
    }
    
    if (self.email) {
        
        [params setObject:self.email forKey:@"email"];

    }
    
    [params setObject:@(ISIPHONE) forKey:@"platform"];
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].login parameters:params success:^(id responseObject) {
        
        [GlobalKit shareKit].pwd = responseObject[@"password"];
        
        [UKHelper storeUserInfoByDic:responseObject];
        
        [ETLMKSOCKETMANAGER connectSocket];
        
        if (responseObject[@"phoneNum"]) {
            
            [self performSegueWithIdentifier:@"UKThirdToHomeSegue" sender:nil];
            
        }else{
            
            [self performSegueWithIdentifier:@"UKThirdPhoneNumViewController" sender:nil];

        }
        
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Logining..."];
    
}


//google第三方登录
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    [HUD hideUIBlockingIndicator];
    
    if (error != nil) {
        if (error.code == kGIDSignInErrorCodeHasNoAuthInKeychain) {
            NSLog(@"The user has not signed in before or they have since signed out.");
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        NSLog(@"%@",error);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [HUD showAlertWithText:@"Login failed"];
            
        });
        return;
    }
    // ...
    NSLog(@"第三方登录 userID = %@",user.userID);
    self.userName = user.profile.name;
    self.thirdId = user.userID;
    self.email = user.profile.email;
    [self loginWithThirdType:SSDKPlatformTypeGooglePlus];
}
//faceBook login
-(void)faceBookLogin{
    [HUD hideUIBlockingIndicator];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logOut];
    [[FBSDKLoginManager new] logOut];
    //这个一定要写，不然会出现换一个帐号就无法获取信息的错误(退出方法)
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    login.loginBehavior = FBSDKLoginBehaviorWeb; // 优先方式
    [login  logInWithReadPermissions: @[@"public_profile"]
                  fromViewController:self
                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                 if (error) {
//                                     NSError *error = [CIAccountError createError:ErrorThirdLoginFailure];
//                                     failureBlock(error);
                                     [HUD hideUIBlockingIndicator];
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         
                                         [HUD showAlertWithText:@"Login failed"];
                                         
                                     });
                                 } else if (result.isCancelled) {
//                                     NSError *error = [CIAccountError createError:ErrorThirdLoginCancel];
//                                     failureBlock(error);
                                     [HUD hideUIBlockingIndicator];
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         
                                         [HUD showAlertWithText:@"Login failed"];
                                         
                                     });
                                 } else {
                                     NSString *token = result.token.tokenString;
                                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                                   initWithGraphPath:result.token.userID
                                                                   parameters:nil
                                                                   HTTPMethod:@"GET"];
                                     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                           id result,
                                                                           NSError *error) {
                                         
                                         [HUD hideUIBlockingIndicator];
                                         
                                         if (error) {
//                                             NSError *resultError = [CIAccountError createError:ErrorThirdLoginFailure];
//                                             failureBlock(resultError);
                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                 
                                                 [HUD showAlertWithText:@"Login failed"];
                                                 
                                             });
                                         }else{
                                             NSString *nickName = [result objectForKey:@"name"];
                                             NSString *openId = [result objectForKey:@"id"];
                                             NSLog(@"第三方登录成功 %@",result);
                                             
                                             self.userName = result[@"name"];
                                             self.thirdId = result[@"id"];
                                             self.email = result[@"email"];
                                             
                                             [login logOut];
                                             
                                             [self loginWithThirdType:SSDKPlatformTypeFacebook];
//                                             NSDictionary *resultDic = @{@"openid":openId,
//                                                                         @"nickname":nickName,
//                                                                         @"account_type":@"facebook",
//                                                                         @"access_token":token,
//                                                                         @"third_appid":Facebook_APP_ID};
//                                             successBlock(resultDic);
                                         }
                                         
                                     }];
                                 }
                             }];
}
//twitter第三方登录
-(void)twitterLogin{
    [HUD hideUIBlockingIndicator];
    
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        [HUD hideUIBlockingIndicator];
        if(session){
            
            NSLog(@"%@已登录",session.userName);
            NSLog(@"%@已登录",session.userID);
            self.userName = session.userName;
            self.thirdId = session.userID;
//            self.email = session.email;
            [self loginWithThirdType:SSDKPlatformTypeTwitter];
            
            [[Twitter sharedInstance].sessionStore logOutUserID:session.userID];
            [[Twitter sharedInstance].sessionStore reloadSessionStore];
            
//            NSHTTPCookie *cookie;
//            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            for (cookie in [storage cookies])
//            {
//                NSString* domainName = [cookie domain];
//                NSRange domainRange = [domainName rangeOfString:@"Twitter"];
//                if(domainRange.length > 0)
//                {
//                    [storage deleteCookie:cookie];
//                }
//            }
//
//            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
//            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
//            for (NSHTTPCookie *cookie in cookies)
//            {
//                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//            }

        }  else  {
            
            NSLog(@"error:%@",error.localizedDescription);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [HUD showAlertWithText:@"Login failed"];
//                [GlobalKit shareKit].token = nil;
            });
        }
        
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:@"insLoginViewController" ]) {
        insLoginViewController *controller = segue.destinationViewController;
        
        controller.insLoginBlack = ^(NSString* _Nullable name,NSString * _Nullable Id){
            if (name.length) {
                weakSelf.userName = name;
                weakSelf.thirdId = Id;
                [weakSelf loginWithThirdType:SSDKPlatformTypeInstagram];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [HUD showAlertWithText:@"Login failed"];
//                    [GlobalKit shareKit].token = nil;
                });
            }
        };
    }
    
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
