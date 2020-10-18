//
//  PhotonContactViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/23.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonContactViewController.h"
#import "PhotonBaseContactItem.h"
#import "PhotonContacDataSource.h"
#import "PhotonSingleContactViewController.h"
#import "PhotonGroupContactViewController.h"
#import "PhotonMacros.h"
@implementation PhotonContactViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.tabBarItem setTitle:@"通讯录"];
        [self.tabBarItem  setImage:[UIImage imageNamed:@"contact"]];
        [self.tabBarItem  setSelectedImage:[UIImage imageNamed:@"contact_onclick"]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.tabBarItem.tag = 2;
    PhotonBaseContactItem *singleItem = [[PhotonBaseContactItem alloc] init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    singleItem.contactID = @"1";
    singleItem.contactAvatar = @"locationpeople";
    singleItem.contactName = @"附近在线的人";
    singleItem.contactIcon = @"right_arrow";
    singleItem.ration = .6;
    
    PhotonBaseContactItem *groupItem = [[PhotonBaseContactItem alloc] init];
    groupItem.contactID = @"2";
    groupItem.contactAvatar = @"locationgroup";
    groupItem.contactName = @"附近的群组";
    groupItem.contactIcon = @"right_arrow";
    groupItem.ration = .6;
    
    PhotonBaseContactItem *roomItem = [[PhotonBaseContactItem alloc] init];
    roomItem.contactID = @"3";
    roomItem.contactAvatar = @"chatroom";
    roomItem.contactName = @"附近的房间";
    roomItem.contactIcon = @"right_arrow";
    roomItem.ration = .6;
    
    [self.items addObject:singleItem];
    [self.items addObject:groupItem];
    [self.items addObject:roomItem];
    
    PhotonContacDataSource *dataSource = [[PhotonContacDataSource alloc] initWithItems:self.items];
    self.dataSource = dataSource;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.items.count) {
        PhotonBaseContactItem *item = (PhotonBaseContactItem *)[self.items objectAtIndex:indexPath.row];
        NSInteger type = [item.contactID integerValue];
        if (type == 1) {
            PhotonSingleContactViewController * singleCtl = [[PhotonSingleContactViewController alloc] init];
             [singleCtl setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:singleCtl animated:YES];
        }
        if (type == 2 || type == 3) {
            PhotonGroupContactViewController *groupCtl = [[PhotonGroupContactViewController alloc] initWithType:type];
            [groupCtl setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:groupCtl animated:YES];
        }
    }
}
@end
