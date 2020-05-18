//
//  UKRegionViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/18.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKRegionViewController.h"
#import "UKSettingsTableViewCell.h"
#import "BMChineseSort.h"

@interface UKRegionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *areaArray;

@property(nonatomic,strong) NSMutableArray *indexArray;

@property(nonatomic,strong) NSMutableArray *letterResultArr;

@property (nonatomic, strong) NSString *region;

@end

@implementation UKRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _areaArray = @[@"Alabama",@"Alaska",@"Arizona",@"Arkansas",@"California",@"Colorado",@"Connecticut",@"Delaware",@"Florida",@"Georgia",@"Hawaii",@"Idaho",@"Illinois",@"Indiana",@"Iowa",@"Kansas",@"Kentucky",@"Louisiana",@"Maine",@"Maryland",@"Massachusetts",@"Michigan",@"Minnesota",@"Mississippi",@"Missouri",@"Montana",@"Nebraska",@"Nevada",@"New hampshire",@"New jersey",@"New mexico",@"New York",@"North Carolina",@"North Dakota",@"Ohio",@"Oklahoma",@"Oregon",@"Pennsylvania",@"Rhode island",@"South carolina",@"South dakota",@"Tennessee",@"Texas",@"Utah",@"Vermont",@"Virginia",@"Washington",@"West Virginia",@"Wisconsin",@"Wyoming"];
    
    _indexArray = [BMChineseSort IndexArray:_areaArray];
    
    _letterResultArr = [BMChineseSort LetterSortArray:_areaArray];
    
    _region = [GlobalKit shareKit].region;
    
    [self.tableView reloadData];

    // Do any additional setup after loading the view.
}

- (IBAction)saveAction:(id)sender {
    
    if (!_region) {
        
        [HUD showAlertWithText:@"Please select region"];
    }
    
    NSMutableDictionary *dic = @{@"region":_region}.mutableCopy;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].userSetting parameters:dic success:^(id responseObject) {
        
        [GlobalKit shareKit].region = self.region;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAlertWithText:@"Save success"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(id error) {
        
    } WithHud:YES AndTitle:@"Saving..."];
    
}

#pragma mark - Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    label.text = [NSString stringWithFormat:@"    %@",[self.indexArray objectAtIndex:section]];
    
    label.textColor = [UIColor whiteColor];
    
    return label;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UKSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UKSettingsTableViewCell" forIndexPath:indexPath];
    
    NSString *name = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.menuLabel.text = name;
    
    if ([name isEqualToString:_region]) {
        
        cell.indictorImgView.hidden = NO;
    }else{
        
        cell.indictorImgView.hidden = YES;

    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *name = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    _region = name;
    
    [self.tableView reloadData];
    
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
