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
#import <AuthenticationServices/AuthenticationServices.h>
@interface UKWelcomeViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

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
    
//    UIButton *applse = (UIButton *)[self.view viewWithTag:10003];
//    applse.layer.masksToBounds = YES;
//    applse.layer.cornerRadius = 28;
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
        
        if (@available(iOS 13.0, *)) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
            // 创建新的AppleID 授权请求
            ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
            // 在用户授权期间请求的联系信息
            appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self;
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            authorizationController.presentationContextProvider = self;
            // 在控制器初始化期间启动授权流
            [authorizationController performRequests];
        }else{
            // 处理不支持系统版本
            [HUD showAlertWithText:@"Sorry,Please update your mobile phone system"];
        }
        
        return;
       
       
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
//        loginType = @"instagram";
        loginType = @"apple";
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
#pragma mark - appleLogin
// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
- (void)perfomExistingAccountSetupFlows{
    NSLog(@"///已经认证过了/////");
    
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 授权请求AppleID
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 为了执行钥匙串凭证分享生成请求的一种机制
        ASAuthorizationPasswordProvider *passwordProvider = [[ASAuthorizationPasswordProvider alloc] init];
        ASAuthorizationPasswordRequest *passwordRequest = [passwordProvider createRequest];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest, passwordRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }else{
        // 处理不支持系统版本
        NSLog(@"该系统版本不可用Apple登录");
    }
}


//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        
//        NSLog(@"familyName =%@",familyName);
//        NSLog(@"givenName =%@",givenName);
//        NSLog(@"nickName =%@",appleIDCredential.fullName.nickname);
//        NSLog(@"email =%@",email);

        if(familyName){
            self.userName = [NSString stringWithFormat:@"%@%@",givenName,familyName];
        }else{
            self.userName = @"Ukoke";
        }
        
        self.thirdId = user;
        self.email = email;
        [self loginWithThirdType:SSDKPlatformTypeInstagram];
        NSData *identityToken = appleIDCredential.identityToken;
        NSData *authorizationCode = appleIDCredential.authorizationCode;
        
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);
        
        // Create an account in your system.
        // For the purpose of this demo app, store the userIdentifier in the keychain.
        //  需要使用钥匙串的方式保存用户的唯一信息
        // [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        
    }else{
        NSLog(@"授权信息均不符");
        
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSLog(@"Handle error：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@", errorMsg);
}

// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    NSLog(@"88888888888");
    // 返回window
    return [UIApplication sharedApplication].windows.lastObject;
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
