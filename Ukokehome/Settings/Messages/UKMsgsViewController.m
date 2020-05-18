//
//  UKMsgsViewController.m
//  Ukokehome
//
//  Created by ethome on 2018/10/20.
//  Copyright © 2018年 ethome. All rights reserved.
//

#import "UKMsgsViewController.h"
#import "UKMsgsTableViewCell.h"
#import "MJRefresh.h"
#import "NSString+ETAttributedStringHeight.h"


@interface UKMsgsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *editToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;

@property (nonatomic, strong) NSMutableArray *messageArray;

@property (nonatomic, strong) NSMutableArray *deleteArray;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL isAllSelect;
@end

@implementation UKMsgsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMessage:)
                                                 name:@"MessageNotification"
                                               object:nil];
    _deleteArray = [NSMutableArray array];
    _messageArray = [NSMutableArray array];
    
    _pageIndex = 1;
    
    [self updateMessageByIndex:_pageIndex];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tintColor = [UIColor whiteColor];
    
    [self getAllMessage];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MessageNotification" object:nil];

}

- (void)getAllMessage
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
        
        [self updateMessageByIndex:weakSelf.pageIndex];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex ++;
        
        [self updateMessageByIndex:weakSelf.pageIndex];
        
    }];
    
}

- (void)updateMessageByIndex:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    
    [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].msgList parameters:@{@"page.pageNum":@(index),@"page.numPerPage":@(100)}.mutableCopy success:^(id responseObject) {
        
        weakSelf.isAllSelect = NO;
        
        if (index == 1) {
            weakSelf.messageArray = [NSMutableArray array];
        }
        NSArray *messageArr = responseObject[@"recordList"];
        
        for (NSDictionary *dic in messageArr) {
            
            UKMessageModel *model = [[UKMessageModel alloc] init];
            
            [model setValuesForKeysWithDictionary:dic ];
            
            model.createDate = [NSString stringWithFormat:@"%lld",[model.createDate longLongValue]/1000];
            
            [weakSelf.messageArray addObject:model];
        }
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        if (weakSelf.messageArray.count >= [responseObject[@"totalCount"] integerValue]) {
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [weakSelf.tableView.mj_footer endRefreshing];
            
        }
        
    } failure:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.tableView.mj_footer endRefreshing];
    } WithHud:YES AndTitle:@"Updating..."];
    
}

- (IBAction)allSelectAction:(UIBarButtonItem *)sender {
    
    for (int i = 0; i < self.messageArray.count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        if (self.isAllSelect) {
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [self.deleteArray removeAllObjects];
            
        }else{
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            [self.deleteArray addObject:self.messageArray[i]];
        }
    }
    
    self.isAllSelect = !self.isAllSelect;
}
- (IBAction)deleteAction:(id)sender {
    
    if (self.deleteArray.count == 0) {
        
        [HUD showAlertWithText:@"No choice message"];
        
    }else{
        
        NSString *delAll = @"N";
        NSMutableArray *delMessageIdArr = [NSMutableArray array];
        
        if (self.deleteArray.count == self.messageArray.count) {
            
            delAll = @"Y";
            
        }
        
        for (UKMessageModel *model in self.deleteArray) {
            [delMessageIdArr addObject:model.id];
        }
        
        NSMutableDictionary *dic = @{@"msgIds":[delMessageIdArr componentsJoinedByString:@","]}.mutableCopy;
        
        if ([delAll isEqualToString:@"Y"]) {
            
            dic = @{@"delAll":@"Y"}.mutableCopy;
        }
        
        [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].msgDelete parameters:dic success:^(id responseObject) {
            if ([delAll isEqualToString:@"Y"]) {
                
                [self.messageArray removeAllObjects];
                
            }else{
                
                [self.messageArray removeObjectsInArray:self.deleteArray];
                
            }
            [self.deleteArray removeAllObjects];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        } failure:^(id error) {
            
        } WithHud:YES AndTitle:@"Deleting..."];

    }

}

- (void)reloadMessage:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    
    UKMessageModel *model = [[UKMessageModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dic];
    
    model.userId = [GlobalKit shareKit].userId;
    
    model.createDate = [UKHelper timeIntByDateString:model.createDate];
    
    [_messageArray insertObject:model atIndex:0];
    
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    
}


- (IBAction)editAction:(UIBarButtonItem *)sender {
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.tableView.editing = !self.tableView.editing;
    
    if (self.tableView.editing) {
        [sender setTitle:@"Cancel"];
        
        _editToolbar.hidden = NO;
        
        self.isAllSelect = NO;
        
    }else{
        [sender setTitle:@"Edit"];
        
        _editToolbar.hidden = YES;
        
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _messageArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UKMsgsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UKMsgsTableViewCell" forIndexPath:indexPath];
    
    UKMessageModel *model = _messageArray[indexPath.section];
    
    cell.model = model;
        
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    bgColorView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = bgColorView;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UKMessageModel *model = _messageArray[indexPath.section];
    
    if (model.isExtension) {
        CGFloat height = [[model.messageInfo getSuitableHeightWithString:model.messageInfo WithWidth:self.view.frame.size.width - 40] floatValue];
        
        if (height <= 20) {
            
            return 80;
            
        }else{
            
            return 65 + height;
            
        }
        
    }else{
        
        return 80;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_rightBarItem.title isEqualToString:@"Cancel"]) {
        
        [self.deleteArray addObject:[self.messageArray objectAtIndex:indexPath.section]];
        
    }else{
        
        UKMessageModel *model = _messageArray[indexPath.section];
        
        model.isExtension = !model.isExtension;
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    if ([_rightBarItem.title isEqualToString:@"Cancel"]) {
        
        [self.deleteArray removeObject:[self.messageArray objectAtIndex:indexPath.section]];
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_rightBarItem.title isEqualToString:@"Edit"]) {
        
        return UITableViewCellEditingStyleDelete;
        
    }else{
        
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UKMessageModel *model = self.messageArray[indexPath.section];
        
        [ETAFNetworking postLMK_AFNHttpSrt:[UKAPIList getAPIList].msgDelete parameters:@{@"msgIds":model.id}.mutableCopy success:^(id responseObject) {
            
            [self.messageArray removeObjectAtIndex:indexPath.section];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
            
        } failure:^(id error) {
            
        } WithHud:YES AndTitle:@"Deleting..."];
        
    }];
    
    return @[button];
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
