//
//  UKHomeViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/9/26.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKHomeViewController.h"
#import "UKHomeCollectionViewCell.h"
#import "UKHomeTableViewCell.h"
#import "UKEditProfileViewController.h"

@interface UKHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL isShowTable;
@property (nonatomic, strong) UKDeviceModel *selectModel;
@property (nonatomic, strong) NSMutableArray *deviceArray;
@end

@implementation UKHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceAction:) name:ETUPDATEDEVIECENOT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recvEnterForeGround:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self checkPhoneNumAndEmail];
    
    [self getDeviceListWithShowError:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    __weak typeof(self) weakSelf = self;
    [(YYLRefreshRequestErrorView *)self.tableView.refreshRequestErrorView setRefreshRequestErrorViewBlock:^{
        
        [weakSelf getDeviceListWithShowError:YES];

    }];
    
    [(YYLRefreshRequestErrorView *)self.collectionView.refreshRequestErrorView setRefreshRequestErrorViewBlock:^{
        
        [weakSelf getDeviceListWithShowError:YES];

    }];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)recvEnterForeGround:(NSNotification *)notice{
    
    [self getDeviceListWithShowError:NO];
}

- (void)checkPhoneNumAndEmail{
    
    if (![GlobalKit shareKit].phoneNumber || ![GlobalKit shareKit].email || [[GlobalKit shareKit].phoneNumber length] <= 1 || [[GlobalKit shareKit].phoneNumber length] <= 1) {
        
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please fill in your mobile phone number or email address" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Go" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UKEditProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UKEditProfileViewController"];
            
            controller.userName = [GlobalKit shareKit].userName;
            controller.email = [GlobalKit shareKit].email;
            controller.phoneNum = [GlobalKit shareKit].phoneNumber;
            controller.address = [GlobalKit shareKit].address;
            controller.birthday = [GlobalKit shareKit].birthday;
            controller.gender = [GlobalKit shareKit].gender?([[GlobalKit shareKit].gender isEqualToString:@"m"]?@"Male":@"Female"):nil;
            controller.isEdit = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {    
          
            [self logoutAction];
        }];
        
        [alertViewController addAction:sureAction];
        
        [alertViewController addAction:logoutAction];
//        alertViewController.modalPresentationStyle = 0;
        [self presentViewController:alertViewController animated:YES completion:nil];
    }

}

- (void)initView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.tableView.frame = self.containView.bounds;
        
        self.collectionView.frame = self.containView.bounds;
        
        self.tableView.tableFooterView = [UIView new];
        
        [self.containView addSubview:self.collectionView];
        
    });
}

- (void)updateDeviceAction:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    
    NSDictionary *result = dic[@"result"];
    
    [self.deviceArray enumerateObjectsUsingBlock:^(UKDeviceModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([model.deviceId containsString:result[@"deviceId"]]) {
            
            *stop = YES;
            
            if (*stop) {
                
                for (NSString *key in result) {
                    
                    if (![key isEqualToString:@"deviceId"]) {
                        
                        [model setValue:result[key] forKey:key];
                        
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    [self.collectionView reloadData];
                });
            }
        }
    }];
}

- (void)getDeviceListWithShowError:(BOOL) show{
    __weak typeof(self) weakSelf = self;
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].deviceList parameters:nil success:^(id responseObject) {
        
        weakSelf.deviceArray = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject[@"recordList"]) {
            
            UKDeviceModel *model = [UKDeviceModel mj_objectWithKeyValues:dic];
            
            [self.deviceArray addObject:model];
        }
        
        weakSelf.tableView.loadErrorType = YYLLoadErrorTypeDefalt;
        
        weakSelf.collectionView.loadErrorType = YYLLoadErrorTypeDefalt;

        [weakSelf.tableView reloadData];
        
        [weakSelf.collectionView reloadData];

        if (weakSelf.deviceArray.count == 0) {
            
            weakSelf.tableView.loadErrorType = YYLLoadErrorTypeNoData;
            
            weakSelf.collectionView.loadErrorType = YYLLoadErrorTypeNoData;

        }
        
    } failure:^(id error) {
        if (!show) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideUIBlockingIndicator];
            });
        }
        [self.deviceArray removeAllObjects];
        [weakSelf.tableView reloadData];
        [weakSelf.collectionView reloadData];
        
        weakSelf.tableView.loadErrorType = YYLLoadErrorTypeRequest;
        weakSelf.collectionView.loadErrorType = YYLLoadErrorTypeRequest;

    } WithHud:NO AndTitle:nil];
    
}

- (void)logoutAction{
    
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Sign Out" message:@"Are you sure to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self checkPhoneNumAndEmail];
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [UKAPIList getAPIList].logout;
        
        NSMutableDictionary *params =[NSMutableDictionary dictionary];
        
        [params setObject:@(ISIPHONE) forKey:@"platform"];
        
        [ETAFNetworking postLMK_AFNHttpSrt:url parameters:params success:^(id responseObject) {
            
            [ETLMKSOCKETMANAGER disconnectSocket];
            
            [[GlobalKit shareKit] clearSession];
            
            UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UKLoginNavigationViewController"];
            controller.modalPresentationStyle = UIModalPresentationFullScreen;
            
            
            [[UKHelper getCurrentVC] presentViewController:controller animated:YES completion:nil];

        } failure:^(id error) {
            
//            [self checkPhoneNumAndEmail];
            
            [ETLMKSOCKETMANAGER disconnectSocket];
            
            [[GlobalKit shareKit] clearSession];
            
            UINavigationController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UKLoginNavigationViewController"];
            controller.modalPresentationStyle = 0;
            [[UKHelper getCurrentVC] presentViewController:controller animated:YES completion:nil];

        }WithHud:YES AndTitle:@"Sign Outing..."];
        
    }];
    
    [alertViewController addAction:cancelAction];
    
    [alertViewController addAction:sureAction];
    
    [self presentViewController:alertViewController animated:YES completion:nil];

}

- (IBAction)userAction:(id)sender {
        
    [self performSegueWithIdentifier:@"UKProfileViewController" sender:nil];
}
- (IBAction)messageAction:(id)sender {
    
    [self performSegueWithIdentifier:@"UKMsgsViewController" sender:nil];

}

- (IBAction)changeView:(UIButton *)sender {
    
    if (!_isShowTable) {
        
        [sender setImage:[UIImage imageNamed:@"table"] forState:UIControlStateNormal];

        [UIView transitionFromView:self.collectionView toView:self.tableView duration:.8f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            
        }];
        
    }else
    {
        [sender setImage:[UIImage imageNamed:@"Mask"] forState:UIControlStateNormal];

        [UIView transitionFromView:self.tableView toView:self.collectionView duration:.8f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        }];
    }
    
    _isShowTable = !_isShowTable;
    
}


#pragma mark ---- CollectionDelegate  ----


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _deviceArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 10);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1;
    
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    float width =  self.view.bounds.size.width *178 / 375;
    float height = self.view.bounds.size.width *210 / 375;
    
    CGSize newSize = CGSizeMake(width , height);
    
    return newSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UKHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceCollectionCell" forIndexPath:indexPath];
    
    UKDeviceModel *model = _deviceArray[indexPath.row];

    cell.model = model;
    
    [cell.statusSwitch removeTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventValueChanged];
    
    [cell.statusSwitch addTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventValueChanged];

    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UKDeviceModel *model = _deviceArray[indexPath.row];
    
    [UKDeviceAPIManager getDeviceWithModel:model success:^(UKDeviceModel * _Nonnull model) {

        self.selectModel = model;

        [self performSegueWithIdentifier:[UKHelper getDeviceClassByModel:model] sender:nil];

    } failure:^(NSString * _Nonnull error) {

    }];
    
}

- (void)statusAction:(UISwitch *)sender{
    
    NSLog(@"%@",[sender.superview.superview class]);
    __block UKDeviceModel *deviceModel;
    __block BOOL isCollectionView = NO;
    __block NSInteger index;
    if ([[sender.superview.superview class] isEqual:[UKHomeCollectionViewCell class]]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UKHomeCollectionViewCell *)sender.superview.superview];
        
        index = indexPath.row;
        
        deviceModel = _deviceArray[indexPath.row];
        
        isCollectionView = YES;

    }else{
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UKHomeTableViewCell *)sender.superview.superview];
        
        index = indexPath.section;

        deviceModel = _deviceArray[indexPath.section];
        
        isCollectionView = NO;

    }
    
    [UKDeviceAPIManager setDeviceWithKey:@"status" andValue:sender.on?@"on":@"off" withModel:deviceModel success:^(UKDeviceModel * _Nonnull model) {
        
        self.selectModel = model;
        
        [self.deviceArray replaceObjectAtIndex:index withObject:model];
        
        [self.tableView reloadData];
        
        [self.collectionView reloadData];
        
    } failure:^(NSString * _Nonnull error) {
        
        [self.tableView reloadData];
        
        [self.collectionView reloadData];
        
    }];
}

#pragma mark ---- tableViewDelegate  ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _deviceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UKHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell" forIndexPath:indexPath];
    
    UKDeviceModel *model = _deviceArray[indexPath.section];
    
    cell.model = model;
    
    [cell.statusSwitch removeTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventValueChanged];
    
    [cell.statusSwitch addTarget:self action:@selector(statusAction:) forControlEvents:UIControlEventValueChanged];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UKDeviceModel *model = _deviceArray[indexPath.section];
    
    [UKDeviceAPIManager getDeviceWithModel:model success:^(UKDeviceModel * _Nonnull model) {
        
        self.selectModel = model;
        
        [self performSegueWithIdentifier:[UKHelper getDeviceClassByModel:model] sender:nil];
        
    } failure:^(NSString * _Nonnull error) {
        
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:[UKHelper getDeviceClassByModel:self.selectModel]]) {
        
        UKBaseDeviceViewController *controller = segue.destinationViewController;
        
        controller.model = self.selectModel;
        
        controller.isFromHome = YES;
    }
}

@end
