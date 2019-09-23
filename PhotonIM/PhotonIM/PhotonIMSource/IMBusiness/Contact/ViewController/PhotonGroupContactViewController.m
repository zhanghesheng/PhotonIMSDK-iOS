//
//  PhotonGroupContactViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/23.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupContactViewController.h"
#import "PhotonBaseViewController+Refresh.h"
#import "PhotonGroupContactModel.h"
#import "PhotonContacDataSource.h"

@interface PhotonGroupContactViewController ()
@property (nonatomic, strong, nullable)PhotonGroupContactModel *model;
@end

@implementation PhotonGroupContactViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshHeader];
    self.title = @"附近的群组";
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self loadDataItems];
}

- (void)loadDataItems{
    __weak typeof(self)weakSlef = self;
    [self.model loadItems:nil finish:^(NSDictionary * _Nullable dict) {
        [weakSlef removeNoDataView];
        [weakSlef p_loadDataItems];
        [weakSlef endRefreshing];
    } failure:^(PhotonErrorDescription * _Nullable error) {
        [PhotonUtil showAlertWithTitle:@"加载群组列表失败" message:error.errorMessage];
        [weakSlef p_loadDataItems];
        [weakSlef loadNoDataView];
        [weakSlef endRefreshing];
    }];
}
- (void)p_loadDataItems{
    PhotonContacDataSource *dataSource = [[PhotonContacDataSource alloc] initWithItems:self.model.items];
    self.dataSource = dataSource;
}

- (PhotonGroupContactModel *)model{
    if (!_model) {
        _model = [[PhotonGroupContactModel alloc] init];
    }
    return _model;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}


@end
