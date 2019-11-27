//
//  PhotonConversationListViewController.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatTestListViewController.h"
#import "PhotonChatTestListViewController+Delegate.h"
#import <MMFoundation/MMFoundation.h>
#import "PhotonBaseViewController+Refresh.h"
#import "PhotonChatTestDataSource.h"
#import "PhotonChatTestItem.h"
#import "PhotonChatTestModel.h"
#import "PhotonMessageCenter.h"
#import "PhotonNetTableItem.h"
#import "PhotonIMDispatchSource.h"
static NSString *message_title = @"消息";
static NSString *message_connecting = @"消息(连接中...)";
static NSString *message_no_connect = @"消息(未连接)";
static NSString *message_syncing = @"消息(收取中......)";

@interface PhotonChatTestListViewController ()<PhotonMessageProtocol,MFDispatchSourceDelegate>
@property (nonatomic, strong, nullable)MFDispatchSource  *dataDispatchSource;
@property (nonatomic, assign)BOOL   isAppeared;
@property (nonatomic, assign)BOOL   needRefreshData;
@property (nonatomic, strong)PhotonIMTimer *imTimer;
@property (nonatomic, assign)NSInteger  refreshCount;
@property (nonatomic, assign)BOOL  isExcute;
@property (nonatomic, assign)NSInteger lastOprationTimeStamp;

@property (atomic, assign)BOOL isRefreshing;
@property (atomic, assign)BOOL firstLoadData;
@property (atomic, retain)dispatch_semaphore_t signa;

@property (nonatomic, strong) UIView  *headerContentView;
@property (nonatomic, strong) UILabel *authSuccessedCountLable;
@property (nonatomic, strong) UILabel *authFailedCountLable;
@end

@implementation PhotonChatTestListViewController
- (void)dealloc
{
    [[PhotonMessageCenter sharedCenter] removeObserver:self];
    [_dataDispatchSource clearDelegateAndCancel];
}
- (instancetype)init
{
    if (self = [super init]) {
        _signa = dispatch_semaphore_create(0);
        self.model = [[PhotonChatTestModel alloc] init];
         [[PhotonMessageCenter sharedCenter] addObserver:self];
        _refreshCount = 0;
        _firstLoadData = YES;
        self.navigationItem.title =@"测试";
        [self.tabBarItem setTitle:@"测试"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"message"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"message_onClick"]];
        _dataDispatchSource = [MFDispatchSource sourceWithDelegate:self type:refreshType_Data dataQueue:dispatch_queue_create("com.cosmos.PhotonIM.conversationdata", DISPATCH_QUEUE_SERIAL)];

    }
    return self;
}

- (void)createHeaderContentView{
    _headerContentView = [[UIView alloc] init];
    _headerContentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_headerContentView];
    CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    [_headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.view).mas_offset(navigationBarAndStatusBarHeight);
        make.height.mas_equalTo(60);
    }];
    UILabel *testLable = [[UILabel alloc] init];
    testLable.text = @"本轮测试";
    testLable.textColor = [UIColor blackColor];
    testLable.font = [UIFont systemFontOfSize:15];
    testLable.textAlignment = NSTextAlignmentLeft;
    [_headerContentView addSubview:testLable];
    [testLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.and.right.mas_equalTo(self.view).mas_offset(10);
           make.top.mas_equalTo(self.headerContentView).mas_offset(2);
           make.height.mas_equalTo(20);
    }];
    
    UILabel *authSuccessedLable = [[UILabel alloc] init];
    authSuccessedLable.text = @"auth成功数:";
    authSuccessedLable.textColor = [UIColor grayColor];
    authSuccessedLable.font = [UIFont systemFontOfSize:13];
    authSuccessedLable.textAlignment = NSTextAlignmentLeft;
    [_headerContentView addSubview:authSuccessedLable];
    [authSuccessedLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.view).mas_offset(10);
           make.top.mas_equalTo(testLable.mas_bottom).mas_offset(2);
           make.width.mas_equalTo(90);
           make.height.mas_equalTo(15);
    }];
    
    _authSuccessedCountLable = [[UILabel alloc] init];
    _authSuccessedCountLable.text = @"0";
    _authSuccessedCountLable.textColor = [UIColor blackColor];
    _authSuccessedCountLable.font = [UIFont systemFontOfSize:13];
    _authSuccessedCountLable.textAlignment = NSTextAlignmentLeft;
    [_headerContentView addSubview:_authSuccessedCountLable];
    [_authSuccessedCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(authSuccessedLable.mas_right).mas_offset(5);
           make.right.mas_equalTo(self.view).mas_offset(-60);
           make.centerY.mas_equalTo(authSuccessedLable.mas_centerY).mas_offset(2);
           make.height.mas_equalTo(15);
    }];
    
    UILabel *authFailedLable = [[UILabel alloc] init];
    authFailedLable.text = @"auth失败数:";
    authFailedLable.textColor = [UIColor grayColor];
    authFailedLable.font = [UIFont systemFontOfSize:13];
    authFailedLable.textAlignment = NSTextAlignmentLeft;
    [_headerContentView addSubview:authFailedLable];
    [authFailedLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self.view).mas_offset(10);
           make.top.mas_equalTo(authSuccessedLable.mas_bottom).mas_offset(0);
           make.width.mas_equalTo(90);
           make.height.mas_equalTo(15);
    }];
    
    _authFailedCountLable = [[UILabel alloc] init];
    _authFailedCountLable.text = @"0";
    _authFailedCountLable.textColor = [UIColor blackColor];
    _authFailedCountLable.font = [UIFont systemFontOfSize:13];
    _authFailedCountLable.textAlignment = NSTextAlignmentLeft;
    [_headerContentView addSubview:_authFailedCountLable];
    [_authFailedCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(authFailedLable.mas_right).mas_offset(5);
           make.right.mas_equalTo(self.view).mas_offset(-60);
           make.centerY.mas_equalTo(authFailedLable.mas_centerY).mas_offset(0);
           make.height.mas_equalTo(15);
    }];
    
    UIButton *clearBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn = @"0";
    _authFailedCountLable.textColor = [UIColor blackColor];
    _authFailedCountLable.font = [UIFont systemFontOfSize:13];
    _authFailedCountLable.textAlignment = NSTextAlignmentLeft;
    [_headerContentView addSubview:_authFailedCountLable];
    [_authFailedCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(authFailedLable.mas_right).mas_offset(5);
           make.right.mas_equalTo(self.view).mas_offset(-60);
           make.centerY.mas_equalTo(authFailedLable.mas_centerY).mas_offset(0);
           make.height.mas_equalTo(15);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needRefreshData) {
        [self.dataDispatchSource addSemaphore];
        self.needRefreshData = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isAppeared = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isAppeared = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeaderContentView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.and.left.and.right.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.headerContentView.mas_bottom).mas_offset(0);
    }];
    [self.dataDispatchSource addSemaphore];
}
- (void)loadDataItems{
    __weak typeof(self)weakSlef = self;
    [self.model loadItems:nil finish:^(NSDictionary * _Nullable dict) {
        [weakSlef removeNoDataView];
        [weakSlef reloadData];
        [weakSlef endRefreshing];
        weakSlef.isRefreshing = NO;
    } failure:^(PhotonErrorDescription * _Nullable error) {
        [PhotonUtil showAlertWithTitle:@"加载会话列表失败" message:error.errorMessage];
        [weakSlef reloadData];
        [weakSlef loadNoDataView];
        [weakSlef endRefreshing];
        weakSlef.isRefreshing = NO;
    }];
}
- (void)refreshTableView{
    if(!_firstLoadData){
        dispatch_semaphore_signal(_signa);
    }
    _firstLoadData = NO;
    
    PhotonChatTestDataSource *dataSource = [[PhotonChatTestDataSource alloc] initWithItems:self.model.items];
    self.dataSource = dataSource;
}

- (void)conversationChange:(PhotonIMConversationEvent)envent chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
    if (_firstLoadData) {
        dispatch_semaphore_wait(_signa, DISPATCH_TIME_FOREVER);
    }
     PhotonIMConversation *conversation = [[PhotonMessageCenter sharedCenter] findConversation:chatType chatWith:chatWith];
    if (!conversation) {
        return;
    }
    if (!self.isAppeared) {
        self.needRefreshData  = YES;
        return;
    }
    switch (envent) {
        case PhotonIMConversationEventCreate:{
             [self.dataDispatchSource addSemaphore];
        }
            break;
        case PhotonIMConversationEventDelete:
            break;
        case PhotonIMConversationEventUpdate:{
            [self updateConversation:conversation chatType:chatType chatWith:chatWith];
        }
            break;
        default:
            break;
    }
}

- (void)updateConversation:(PhotonIMConversation *)conversation chatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith{
    PhotonChatTestItem *temp = nil;
    NSInteger index = -1;
    BOOL isToTop = NO;
    for (PhotonChatTestItem *item in self.model.items) {
        PhotonIMConversation *conver = [item userInfo];
        if ([[conver chatWith] isEqualToString:chatWith] && ([conver chatType] == chatType)) {
            PhotonUser *user = [PhotonContent friendDetailInfo:conversation.chatWith];
            conversation.FAvatarPath = user.avatarURL;
            temp = item;
            temp.userInfo = conversation;
            index = [self.model.items indexOfObject:item];
            isToTop = (conversation.lastTimeStamp > conver.lastTimeStamp) && (index > 0);
            break;
        }
    }
    
    if (temp && isToTop) {
        [self.model.items removeObjectAtIndex:index];
        [self.model.items insertObject:temp atIndex:0];
        [self reloadData];
        return;
    }
    if (temp && index == 0) {
        [self updateItem:temp];
    }
}

- (PhotonIMDispatchSourceEventBlock)uiEventBlock{
    __weak typeof(self)weakSlef = self;
    PhotonIMDispatchSourceEventBlock eventBlock = ^(id userInfo){
        if (userInfo) {
           [weakSlef updateItem:userInfo];
        }
       
    };
    return eventBlock;
}


- (void)startRefreshConversations{
    if (_isRefreshing) {
           return;
       }
       _isRefreshing = YES;
    [self loadDataItems];
}


#pragma mark --- 刷新数据 ------
- (void)refreshData{
    [self startRefreshConversations];
}
@end
