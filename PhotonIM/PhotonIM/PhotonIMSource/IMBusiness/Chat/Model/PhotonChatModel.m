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
@end

@implementation PhotonChatModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageSize = 20;
        _anchorMsgId = @"";
        _startSyncServer = NO;
        _haveNext = YES;
    }
    return self;
}
- (void)loadMoreMeesages:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith beforeAuthor:(BOOL)beforeAnchor asc:(BOOL)asc finish:(void (^)(NSDictionary * _Nullable))finish{
    PhotonIMClient *imclient = [PhotonIMClient sharedClient];
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
        [imclient syncHistoryMessagesFromServer:chatType chatWith:chatWith anchor:self.anchorMsgId size:(int)self.pageSize beginTimeStamp:([[NSDate date] timeIntervalSince1970] * 1000 - 7 * 24 *60 * 60 * 1000) endTimeStamp:[[NSDate date] timeIntervalSince1970] * 1000 reaultBlock:^(NSArray<PhotonIMMessage *> * _Nullable messageList, NSString * _Nullable anchor,BOOL haveNext, NSError * _Nullable error) {
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
            [imclient loadHistoryMessages:chatType chatWith:chatWith anchor:weakself.anchorMsgId size:(int)weakself.pageSize reaultBlock:^(NSArray<PhotonIMMessage *> * _Nullable messages, NSString * _Nullable an, BOOL remainHistoryInServer) {
                NSMutableArray *items = [NSMutableArray array];
                weakself.anchorMsgId = [an copy];
                weakself.startSyncServer = remainHistoryInServer;
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
        NSArray<PhotonIMMessage *> * _Nullable beforeMessages = [imclient findMessageListByIdRange:chatType chatWith:chatWith anchorMsgId:self.anchorMsgId beforeAuthor:beforeAnchor  size:(int)self.pageSize/2];
        _ftsIndex = [beforeMessages count];
         NSArray<PhotonIMMessage *> * _Nullable afterMessages = [imclient findMessageListByIdRange:chatType chatWith:chatWith anchorMsgId:[[beforeMessages lastObject] messageID] beforeAuthor:!beforeAnchor size:(int)self.pageSize/2];
        
        NSMutableArray<PhotonIMMessage *> *messages = [NSMutableArray arrayWithArray:beforeMessages];
        [messages addObjectsFromArray:afterMessages];
           for (PhotonIMMessage *msg in messages) {
               id item =  [weakself wrapperMessage:msg];
               if (item) {
                   [items addObject:item];
               }
           }
    }else{
         NSArray<PhotonIMMessage *> * _Nullable messages = [imclient findMessageListByIdRange:chatType chatWith:chatWith anchorMsgId:self.anchorMsgId beforeAuthor:beforeAnchor  size:(int)self.pageSize];
       
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
            finish(@{@"result_count":@(items.count)});
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
    }else if (message.chatType == PhotonIMChatTypeGroup){
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
            PhotonChatLocationItem *locationItem = [[PhotonChatLocationItem alloc] init];
            PhotonIMLocationBody *audioBody = (PhotonIMLocationBody *)message.messageBody;
            locationItem.address = audioBody.address;
            locationItem.detailAddress = audioBody.detailedAddress;
            locationItem.locationCoordinate = CLLocationCoordinate2DMake(audioBody.lat, audioBody.lng);
            locationItem.userInfo = message;
            resultItem = locationItem;
        }
            break;
        case PhotonIMMessageTypeRaw:{// 自定义
            PhotonIMCustomBody *customBody = (PhotonIMCustomBody *)message.messageBody;
            if (customBody.data) {
                PhotonChatNoticItem *noticItem = [[PhotonChatNoticItem alloc] init];
                noticItem.notic = [[NSString alloc] initWithData:customBody.data encoding:NSUTF8StringEncoding];
                noticItem.userInfo = message;
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

@end
