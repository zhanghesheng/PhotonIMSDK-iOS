//
//  PhotonGroupMemberListViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/24.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupMemberListViewController.h"
#import "PhotonMessageCenter.h"
#import "PhotonContacDataSource.h"
#import "PhotonGroupMemberListModel.h"
#import "PhotonEmptyTableItem.h"
#import "PhotonBaseContactItem.h"
#import "PhotonBaseContactCell.h"
#import "PhotonChatTransmitCell.h"
#import "PhotonChatTransmitItem.h"
#import "PhotonTitleTableItem.h"
@interface PhotonGroupMemberListViewController ()<PhotonChatTransmitCellDelegate>
@property (nonatomic, copy, nullable)NSString *gid;
@property (nonatomic, strong, nullable)PhotonGroupMemberListModel *model;
@property (nonatomic, strong, nullable)UILabel   *tipLable;
@property (nonatomic, strong, nullable)UIButton  *okBtn;
@property (nonatomic, strong, nullable)NSMutableArray *selectedChats;
@property (nonatomic, strong, nullable)PhotonIMMessage *message;

@property (nonatomic, copy, nullable)PhotonGroupMemberListBlock result;
@end

@implementation PhotonGroupMemberListViewController
- (instancetype)initWithGid:(NSString *)gid result:(PhotonGroupMemberListBlock)result{
    self = [super init];
    if (self) {
        _gid = gid;
        _result = [result copy];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择提醒的人";
    [self.view setBackgroundColor:[UIColor colorWithHex:0xF3F3F3]];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    
    _tipLable = [[UILabel alloc] init];
    _tipLable.textColor = [UIColor colorWithHex:0x4B4B4B];
    _tipLable.backgroundColor = [UIColor clearColor];
    _tipLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0f];
    self.tipLable.text = [NSString stringWithFormat:@"已选择：%@个",@(0)];
    [self.view addSubview:_tipLable];
    
    [_tipLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-SAFEAREA_INSETS_BOTTOM - 10);
        make.left.mas_equalTo(self.view).mas_offset(19);
        make.right.mas_equalTo(self.view).mas_offset(-150);
    }];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.okBtn = okBtn;
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.userInteractionEnabled = YES;
    [okBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [okBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
    [okBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-SAFEAREA_INSETS_BOTTOM - 10);
        make.right.mas_equalTo(self.view).mas_offset(-11);
        make.size.mas_equalTo(CGSizeMake(68.0, 32.5));
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view).mas_equalTo(0);
        make.bottom.mas_equalTo(okBtn.mas_top).mas_equalTo(- 13);
    }];
    [self loadDataItems];
}

- (void)loadDataItems{
    
    PhotonWeakSelf(self);
    if (![self.gid isNotEmpty]) {
        return;
    }
    NSDictionary *paramter = @{@"gid":self.gid};
    [self.model loadItems:paramter finish:^(NSDictionary * _Nullable dict) {
        [weakself loadData];
    } failure:^(PhotonErrorDescription * _Nullable error) {
    }];
    
}
- (void)loadData{
    PhotonContacDataSource *dataSource = [[PhotonContacDataSource alloc] initWithItems:self.model.items];
    self.dataSource = dataSource;
}
- (PhotonGroupMemberListModel *)model{
    if (!_model) {
        _model = [[PhotonGroupMemberListModel alloc] init];
    }
    return _model;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[PhotonChatTransmitCell class]]) {
        PhotonChatTransmitCell *tempCell = (PhotonChatTransmitCell *)cell;
        tempCell.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.model.items.count) {
        id item = [self.model.items objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[PhotonTitleTableItem class]]) {
            if (self.result) {
                self.result(2, nil);
            }
        }
    }
}

-(void)cell:(id)cell selectedItem:(id)item{
    if ([item isKindOfClass:[PhotonChatTransmitItem class]]) {
        PhotonChatTransmitItem *tempItem = (PhotonChatTransmitItem *)item;
        if (tempItem.selected) {
            if(![self.selectedChats containsObject:tempItem.userInfo]){
                [self.selectedChats addObject:tempItem.userInfo];
            }
        }else{
            if([self.selectedChats containsObject:tempItem.userInfo]){
                [self.selectedChats removeObject:tempItem.userInfo];
            }
        }
    }
    if(self.selectedChats.count){
        self.okBtn.userInteractionEnabled = YES;
        [self.okBtn setBackgroundColor:[UIColor colorWithHex:0x02A33D] forState:UIControlStateNormal];
    }else{
        self.okBtn.userInteractionEnabled = NO;
        [self.okBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    self.tipLable.text = [NSString stringWithFormat:@"已选择：%@个",@(self.selectedChats.count)];
}

- (void)okAction:(UIButton *)sender{
    if (self.selectedChats.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.selectedChats.count == self.model.memberCount) {
        if (self.result) {
            self.result(2, nil);
        }
      
    }else{
        NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:self.selectedChats.count];
        for (PhotonUser *user in self.selectedChats) {
            NSString *userID = user.userID;
            NSString *nickName = user.nickName;
            if ([userID isNotEmpty] && [nickName isNotEmpty]) {
                resultDict[nickName] =  resultDict[userID];
            }
        }
        if (self.result) {
            self.result(1, [resultDict copy]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)selectedChats{
    if (!_selectedChats) {
        _selectedChats = [NSMutableArray array];
    }
    return _selectedChats;
}
@end
