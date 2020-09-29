//
//  PhotonChatModel.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatModel.h"
@interface PhotonChatModel()
@property (nonatomic,assign)BOOL startSyncServer;
@property (nonatomic,assign)BOOL haveNext;
@property (nonatomic,assign)NSInteger ftsIndex;

@property (nonatomic)NSTimeInterval beginTime;
@property (nonatomic)NSTimeInterval endTime;
@end

@implementation PhotonChatModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageSize = [PhotonContent currentSettingModel].size?:20;
        _anchorMsgId = @"";
        _startSyncServer = [PhotonContent currentSettingModel].onlyLoadService;
        _haveNext = YES;
        _beginTime = 0;
        _endTime = [[NSDate date] timeIntervalSince1970] * 1000.0;
        if (_startSyncServer) {
            _beginTime = [PhotonContent currentSettingModel].beginTime?:_beginTime;
            _endTime = [PhotonContent currentSettingModel].endTime?:_endTime;
        }
    }
    return self;
}
- (void)loadMoreMeesages:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith beforeAuthor:(BOOL)beforeAnchor asc:(BOOL)asc finish:(void (^)(NSDictionary * _Nullable))finish{
   
    PhotonIMClient *imclient = [PhotonIMClient sharedClient];
    NSInteger count = [imclient getMessageCountWithMsgType:chatType chatWith:chatWith messageType:@[@(PhotonIMMessageTypeImage)]];
    PhotonWeakSelf(self);
    if (_loadFtsData) {
        [self loadMoreFtsMeesages:chatType chatWith:chatWith beforeAuthor:beforeAnchor asc:asc finish:finish];
        return;
    }
    
    if (self.startSyncServer ) {// 是否加载服务端上的数据
        if (!self.haveNext) {
             if (finish) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      finish(nil);
                  });
              }
            return;
        }
        [imclient syncHistoryMessagesFromServer:chatType chatWith:chatWith anchor:self.anchorMsgId size:(int)self.pageSize beginTimeStamp:_beginTime endTimeStamp:_endTime reaultBlock:^(NSArray<PhotonIMMessage *> * _Nullable messageList, NSString * _Nullable anchor,BOOL haveNext, NSError * _Nullable error) {
             weakself.haveNext = haveNext;
            if (error) {
                weakself.startSyncServer = NO;
            }else if(messageList.count > 0){
                weakself.anchorMsgId = anchor;
                NSMutableArray *items = [NSMutableArray array];
                for (PhotonIMMessage *msg in messageList) {
                    id item =  [weakself wrapperMessage:msg];
                    if (item) {
                        [items addObject:item];
                    }
                }
                NSMutableArray *totolItems = [NSMutableArray arrayWithCapacity:weakself.items.count + items.count];
                [totolItems addObjectsFromArray:items];
                [totolItems addObjectsFromArray:weakself.items];
                weakself.items = [PhotonIMThreadSafeArray arrayWithArray:totolItems];
            }
            if (finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish(nil);
                });
            }
            
        }];
    }else{
            if(!weakself.anchorMsgId || weakself.anchorMsgId.length == 0){
                weakself.anchorMsgId = [[[weakself.items firstObject] userInfo] messageID];
            }
        [imclient loadHistoryMessages:chatType chatWith:chatWith messageTypeList:@[@(PhotonIMMessageTypeUnknow)] anchorMsgId:weakself.anchorMsgId size:(int)self.pageSize reaultBlock:^(NSArray<PhotonIMMessage *> * _Nullable messages, NSString * _Nullable an) {
            NSMutableArray *items = [NSMutableArray array];
            weakself.anchorMsgId = [an copy];
            for (PhotonIMMessage *msg in messages) {
                id item =  [weakself wrapperMessage:msg];
                if (item) {
                    [items addObject:item];
                }
            }
            NSMutableArray *totolItems = [NSMutableArray arrayWithCapacity:weakself.items.count + items.count];
            [totolItems addObjectsFromArray:items];
            [totolItems addObjectsFromArray:weakself.items];
            weakself.items = [PhotonIMThreadSafeArray arrayWithArray:totolItems];
            if (finish) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    finish(nil);
                });
            }
        }] ;
    }

}

- (void)loadMoreFtsMeesages:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith beforeAuthor:(BOOL)beforeAnchor asc:(BOOL)asc finish:(void (^)(NSDictionary * _Nullable))finish{
    BOOL noHistory = NO;
    PhotonIMClient *imclient = [PhotonIMClient sharedClient];
      PhotonWeakSelf(self);
    if (self.items.count) {
        if (beforeAnchor) {
               self.anchorMsgId = [[[weakself.items firstObject] userInfo] messageID];
           }else{
               self.anchorMsgId = [[[weakself.items lastObject] userInfo] messageID];
           }
    }
   
     NSMutableArray *items = [NSMutableArray array];
    if (self.items.count == 0) {
        NSArray<PhotonIMMessage *> * _Nullable beforeMessages = [imclient loadHistoryMessages:chatType chatWith:chatWith anchorMsgId:self.anchorMsgId beforeAuthor:beforeAnchor size:(int)self.pageSize/2];

        _ftsIndex = [beforeMessages count];
         NSArray<PhotonIMMessage *> * _Nullable afterMessages = [imclient loadHistoryMessages:chatType chatWith:chatWith anchorMsgId:[[beforeMessages lastObject] messageID] beginTimeStamp:0 endTime:[[NSDate date] timeIntervalSince1970] * 1000.0  beforeAuthor:!beforeAnchor size:(int)self.pageSize/2];
        
        NSMutableArray<PhotonIMMessage *> *messages = [NSMutableArray arrayWithArray:beforeMessages];
        [messages addObjectsFromArray:afterMessages];
           for (PhotonIMMessage *msg in messages) {
               id item =  [weakself wrapperMessage:msg];
               if (item) {
                   [items addObject:item];
               }
           }
        if (items.count == 0 && self.anchorMsgId.length > 0) {
            PhotonIMMessage * message = [imclient findMessage:chatType chatWith:chatWith msgId:self.anchorMsgId];
            id item =  [self wrapperMessage:message];
            if (item) {
                [items addObject:item];
            }
            noHistory = YES;
        }
    }else{
        NSArray<PhotonIMMessage *> * _Nullable messages = [imclient loadHistoryMessages:chatType chatWith:chatWith anchorMsgId:self.anchorMsgId beforeAuthor:beforeAnchor size:(int)self.pageSize];
       
           for (PhotonIMMessage *msg in messages) {
               id item =  [weakself wrapperMessage:msg];
               if (item) {
                   [items addObject:item];
               }
           }
        
    }
    if (beforeAnchor) {
        NSMutableArray *totolItems = [NSMutableArray arrayWithCapacity:weakself.items.count + items.count];
        [totolItems addObjectsFromArray:items];
        [totolItems addObjectsFromArray:weakself.items];
        self.items = [PhotonIMThreadSafeArray arrayWithArray:totolItems];
    }else{
        [self.items addObjectsFromArray:items];
    }
    if (finish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            finish(@{@"result_count":noHistory?@(0):@(items.count)});
        });
    }
}

- (NSIndexPath *)getFtsSearchContentIndexpath{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_ftsIndex inSection:0];
    return indexPath;
}

- (NSInteger)getPageSize{
   return [self pageSize];
}

// 处理二人聊天收到的信息
- (PhotonBaseTableItem *)wrapperMessage:(PhotonIMMessage *)message{
    PhotonChatBaseItem * resultItem = nil;
    PhotonChatMessageFromType fromeType = [message.fr isEqualToString:[PhotonContent currentUser].userID]?PhotonChatMessageFromSelf:PhotonChatMessageFromFriend;
    // 处理撤回的消息
    if (message.messageStatus == PhotonIMMessageStatusRecall) {
        PhotonChatNoticItem *noticItem = [[PhotonChatNoticItem alloc] init];
        noticItem.notic = message.withdrawNotice;
        noticItem.userInfo = message;
        return noticItem;
    }
    NSString *avatarUrl = @"";
    if (message.chatType == PhotonIMChatTypeSingle) {
        avatarUrl = [PhotonContent friendDetailInfo:message.fr].avatarURL;
    }else if (message.chatType == PhotonIMChatTypeGroup || message.chatType == PhotonIMChatTypeRoom){
        avatarUrl = [PhotonContent findUserWithGroupId:message.to uid:message.fr].avatarURL;
    }
    switch (message.messageType) {
        case PhotonIMMessageTypeText:{// 文本
            PhotonChatTextMessageItem *textItem = [[PhotonChatTextMessageItem alloc] init];
            PhotonIMTextBody * body = (PhotonIMTextBody *)message.messageBody;
            textItem.messageText = [body text];
            textItem.userInfo = message;
           
            resultItem = textItem;
        }
            break;
        case PhotonIMMessageTypeImage:{// 图片
            PhotonChatImageMessageItem *imageItem = [[PhotonChatImageMessageItem alloc] init];
            PhotonIMImageBody *imgBody = (PhotonIMImageBody *)message.messageBody;
            if([imgBody.thumbURL isNotEmpty]){
                imageItem.thumURL = imgBody.thumbURL;
            }
            if([imgBody.url isNotEmpty]){
                imageItem.orignURL = imgBody.url;
            }
            imageItem.fileName = imgBody.localFileName;
            if(fromeType == PhotonChatMessageFromSelf){
                imageItem.localPath = imgBody.localFilePath;
            }
            imageItem.whRatio = imgBody.whRatio;
            
            imageItem.userInfo = message;
            imageItem.whRatio = imgBody.whRatio;
            resultItem = imageItem;
        }
            break;
        case PhotonIMMessageTypeAudio:{// 语音
            PhotonChatVoiceMessageItem *audioItem = [[PhotonChatVoiceMessageItem alloc] init];
            PhotonIMAudioBody *audioBody = (PhotonIMAudioBody *)message.messageBody;
            if([audioBody.url isNotEmpty]){
                audioItem.url = [NSURL URLWithString:audioBody.url];
            }
            audioItem.fileName = audioBody.localFileName;
            audioItem.duration = audioBody.mediaTime;
            audioItem.fileLocalPath = audioBody.localFilePath;
            audioItem.userInfo = message;
            audioItem.isPlayed = audioBody.localMediaPlayed;
            resultItem = audioItem;
        }
            break;
        case PhotonIMMessageTypeVideo:{// 视频
            PhotonChatVideoMessageItem *videoItem = [[PhotonChatVideoMessageItem alloc] init];
            PhotonIMVideoBody *videoBody = (PhotonIMVideoBody *)message.messageBody;
            if([videoBody.url isNotEmpty]){
                videoItem.url = [NSURL URLWithString:videoBody.url];
            }
            videoItem.duration = videoBody.mediaTime;
            videoItem.coverURL = videoBody.coverUrl;
            videoItem.whRatio = videoBody.whRatio;
            if (![videoItem.coverURL isNotEmpty]) {
                videoItem.coverImage = [PhotonUtil firstFrameWithVideoURL:videoBody.localFilePath size:videoItem.contentSize];
                videoItem.whRatio = videoItem.coverImage.size.width/videoItem.coverImage.size.height;
            }
            videoItem.userInfo = message;
            resultItem = videoItem;
        }
            break;
        case PhotonIMMessageTypeLocation:{// 位置
            PhotonChatLocationItem *locationItem = [[PhotonChatLocationItem alloc] init];
            PhotonIMLocationBody *audioBody = (PhotonIMLocationBody *)message.messageBody;
            locationItem.address = audioBody.address;
            locationItem.detailAddress = audioBody.detailedAddress;
            locationItem.locationCoordinate = CLLocationCoordinate2DMake(audioBody.lat, audioBody.lng);
            locationItem.userInfo = message;
            resultItem = locationItem;
        }
            break;
        case PhotonIMMessageTypeFile:{// 文件
            PhotonChatFileMessageItem *fileItem = [[PhotonChatFileMessageItem alloc] init];
            PhotonIMFileBody *fileBody = (PhotonIMFileBody *)message.messageBody;
            fileItem.fileSize = [NSString stringWithFormat:@"%.1f k",(float)fileBody.fileSize/1024.0];
            fileItem.fileName = fileBody.fileDisplayName;
            fileItem.fileICon = [UIImage imageNamed:@"chatfile"];
            fileItem.filePath = fileBody.localFilePath;
            fileItem.userInfo = message;
            resultItem = fileItem;
        }
            break;
        case PhotonIMMessageTypeRaw:{// 自定义
            PhotonIMCustomBody *customBody = (PhotonIMCustomBody *)message.messageBody;
            if (customBody.data) {
                PhotonChatNoticItem *noticItem = [[PhotonChatNoticItem alloc] init];
                noticItem.notic = [[NSString alloc] initWithData:customBody.data encoding:NSUTF8StringEncoding];
                noticItem.userInfo = message;
                [[PhotonContent currentUser] loadMembersFormGroup:message.chatWith completion:nil];
                return noticItem;
            }
        }
            break;
        default:
            break;
    }
    resultItem.timeStamp = message.timeStamp;
    resultItem.avatalarImgaeURL = avatarUrl;
    resultItem.fromType = fromeType;
    resultItem.tipText = message.notic;
    return resultItem;
}


- (BOOL)wrapperWithdrawMessage:(PhotonIMMessage *)messag{
    PhotonChatBaseItem *tempItem = nil;
    NSArray *items=[self.items copy];
    for (PhotonChatBaseItem *item in items) {
        PhotonIMMessage *tempMsg = item.userInfo;
        if ([tempMsg.messageID isEqualToString:messag.withdrawMsgID]) {
            tempItem = item;
        }
    }
    if (tempItem) {
        NSInteger index = [self.items indexOfObject:tempItem];
        PhotonChatNoticItem *noticItem = [[PhotonChatNoticItem alloc] init];
        noticItem.notic = messag.withdrawNotice;
        [self.items replaceObjectAtIndex:index withObject:noticItem];
        return YES;
    }
    return NO;
}

- (BOOL)wrapperReadMessage:(PhotonIMMessage *)message{
    BOOL ret = NO;
    NSArray *readMsgIds = message.readMsgIDs;
    if (readMsgIds.count > 0) {
        NSArray *items=[self.items copy];
        for (NSString *msgID in readMsgIds) {
            for (PhotonChatBaseItem *item in items) {
                PhotonIMMessage *tempMsg = item.userInfo;
                if ([tempMsg.messageID isEqualToString:msgID]) {
                    tempMsg.messageStatus = PhotonIMMessageStatusSentRead;
                    ret = YES;
                }
            }
        }
    }
    return ret;
}

- (void)addItem:(id)item{
    PhotonWeakSelf(self);
    [PhotonUtil runMainThread:^{
        NSInteger count = weakself.items.count;
        if (item && count > weakself.pageSize * 2){
            NSArray *items = [self.items subarrayWithRange:NSMakeRange(count-(weakself.pageSize), weakself.pageSize)];
            weakself.items = [items mutableCopy];
            weakself.anchorMsgId = [[[self.items firstObject] userInfo] messageID];
            [weakself.items addObject:item];
        }else if (item){
            [weakself.items addObject:item];
        }
    }];
   
}

- (NSArray *)insertItem:(id)item{
    
    return nil;
}

- (void)resetFtsSearch{
    self.loadFtsData = NO;
    self.anchorMsgId = nil;
    [self.items removeAllObjects];
}


- (void)quit:(NSString *)gid finish:(void (^)(NSDictionary * _Nullable))finish failure:(void (^)(PhotonErrorDescription * _Nullable))failure{
    if (![gid isNotEmpty]) {
        return;
    }
    NSDictionary *patamter = @{@"gid":gid};
    NSString *path = @"/photonimdemo/room/remote/quit";
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:path paramter:patamter completion:^(NSDictionary * _Nonnull responseDict) {
        if (finish) {
            finish(nil);
        }
        [PhotonUtil hiddenLoading];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        [PhotonUtil hiddenLoading];
        if (failure) {
            failure(error);
        }
    }];
}

@end
