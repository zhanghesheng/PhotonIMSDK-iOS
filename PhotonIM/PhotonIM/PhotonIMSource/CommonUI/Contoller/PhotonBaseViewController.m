//
//  PhotonBaseViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonBaseViewController.h"
#import "PhotonTableViewCell.h"
@interface PhotonBaseViewController ()
@property (nonatomic, strong, nullable) UIView   *noDataView;
@property (nonatomic, assign) CGPoint contentOffsetForRestore;
@end

@implementation PhotonBaseViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
        _tableView = [[PhotonBaseUITableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
        _tableView = [[PhotonBaseUITableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
    }
    return self;
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    self.items = [NSMutableArray arrayWithCapacity:1];
}


- (void)backPre{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadDataItems{
    
}

- (void)reloadData{
    
}

- (void)insert:(NSArray<NSIndexPath *> *)indexPaths animated:(BOOL)animated
{
    if (!indexPaths.count)
    {
        return;
    }

    NSMutableArray *addIndexPathes = [NSMutableArray array];
    [indexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[obj integerValue] inSection:0];
        [addIndexPathes addObject:indexPath];
    }];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:addIndexPathes withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:addIndexPathes.lastObject atScrollPosition:UITableViewScrollPositionTop animated:NO];

    [UIView animateWithDuration:0.25 delay:0 options:7 animations:^{
    } completion:nil];
}

- (void)remove:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    NSInteger row = [self.tableView numberOfRowsInSection:0] - 1;
    if (row > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


- (void)update:(NSIndexPath *)indexPath
{
    PhotonTableViewCell *cell = (PhotonTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        CGFloat scrollOffsetY = self.tableView.contentOffset.y;
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, scrollOffsetY) animated:NO];
    }
}

- (void)loadNoDataView{
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.userInteractionEnabled = NO;
    }
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nomessage"]];
    icon.backgroundColor = [UIColor clearColor];
    icon.userInteractionEnabled = NO;
    [_noDataView addSubview:icon];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.textColor = [UIColor colorWithHex:0xCECECE];
    tip.userInteractionEnabled = NO;
    tip.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.text = @"暂无消息";
    
    [_noDataView addSubview:icon];
    [_noDataView addSubview:tip];
    [self.view addSubview:_noDataView];
    
    [_noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.noDataView);
    }];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(icon.mas_bottom);
    }];
    
}
- (void)removeNoDataView{
    [self.noDataView removeFromSuperview];
}
- (void)setDataSource:(id<PotonTableViewDataSourceProtocol>)dataSource{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        _tableView.dataSource = nil;
    }
    
    _tableView.dataSource = _dataSource;
    if (self.enableWithoutScrollToTop) {
        [_tableView reloadDataWithoutScrollToTop];
    }else{
        [_tableView reloadData];
    }
    
}

#pragma mark UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView.dataSource isKindOfClass:[PotonTableViewDataSource class]]) {
        id <PotonTableViewDataSourceProtocol> dataSource = (id <PotonTableViewDataSourceProtocol>) tableView.dataSource;
        id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        Class cls = [dataSource tableView:tableView cellClassForObject:object];
        CGFloat height = [cls tableView:tableView rowHeightForObject:object];
        return height;
    }
    return DEFAULT_TABLE_CELL_HRIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.dataSource isKindOfClass:[PotonTableViewDataSource class]]) {
        id <PotonTableViewDataSourceProtocol> dataSource = (id <PotonTableViewDataSourceProtocol>) tableView.dataSource;
        id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        Class cls = [dataSource tableView:tableView cellClassForObject:object];
        CGFloat height = [cls tableView:tableView rowHeightForObject:object];
        return height;
    }
    
    return DEFAULT_TABLE_CELL_HRIGHT;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
