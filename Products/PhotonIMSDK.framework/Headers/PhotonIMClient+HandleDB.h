//
//  PhotonIMClient+HandleDB.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/19.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMClient(HandleDB)


/**
 获取总的未读数

 @return <#return value description#>
 */
- (NSInteger)getAllUnreadCount;


/**
 判断消息是否在数据库中存储

 @param message <#message description#>
 @return <#return value description#>
 */
- (BOOL)isMessageExist:(PhotonIMMessage *)message;

/**
 存储或者更新数据 如果数据不存在，则插入一条数据，数据存在则更新
 @param update 是否同时更新会话中的最后一条消息
 @param message <#message description#>
 */
- (void)insertOrUpdateMessage:(PhotonIMMessage *)message updateConversion:(BOOL)update;

/**
 更新消息状态
 使用场景: 只更新数据库中的消息状态时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageStatus:(PhotonIMMessage *)message;

/**
 更新消息状态
 使用场景: 只更新数据库中的消息文本内容时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageContent:(PhotonIMMessage *)message;

/**
 更新消息中多媒体的时长
 使用场景: 只更新数据库中的消息多媒体的时长时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageMediaTime:(PhotonIMMessage *)message;

/**
 更新消息中资源服务端地址
 使用场景: 只更新数据库中的消息资源服务端地址时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageFileUrl:(PhotonIMMessage *)message;

/**
 更新消息中资源本地地址
 使用场景: 只更新数据库中的消息资源本地地址时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageLocalFile:(PhotonIMMessage *)message;

/**
 更新消息中多媒体资源是否播放的状态
 使用场景: 只更新数据库中的消息多媒体资源是否播放的状态时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageLocalMediaPlayed:(PhotonIMMessage *)message;

/**
 更新消息中额外信息
 使用场景: 只更新数据库中的消息额外信息时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageExtra:(PhotonIMMessage *)message;

/**
 更新消息中自定义消息体
 使用场景: 只更新数据库中的消息自定义消息体时推荐调用
 @param message <#message description#>
 */
- (void)updateMessageCustom:(PhotonIMMessage *)message;


/**
 删除消息
 
 @param message <#message description#>
 */
- (void)deleteMessage:(PhotonIMMessage *)message;


/**
 清空指定会话下的所有消息
 
 @param conversation 会话对象
 */
- (void)clearMessagesWithConversation:(PhotonIMConversation *)conversation;

/**
 清空指定会话下的所有消息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 注:chatType 和 chatWith 二者确定会话的唯一性
 */
- (void)clearMessagesWithChatType:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 查找消息

 @param message 以此消息为锚点进行查询
 @param beforeAuthor 是否查找锚点之前的数据
 @param asc 是否为升序
 @param size 以锚点为中心，要查找的消息的个数
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessageListByIdRange:(PhotonIMMessage *)message beforeAuthor:(BOOL)beforeAuthor asc:(BOOL)asc size:(int)size;


/**
 查找消息

 @param chatType 查找的会话类型
 @param chatWith 会话中对方的id
 @param anchorMsgId 锚点消息id （未有可为空）
 @param beforeAnchor 是否查找锚点之前的数据
 @param asc 是否为升序
 @param size 以锚点为中心，要查找的消息的个数
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessageListByIdRange:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith anchorMsgId:(nullable NSString *)anchorMsgId beforeAuthor:(BOOL)beforeAnchor asc:(BOOL)asc size:(int)size;

/**
 按消息的状态查找数据
 
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)findMessagesByStatus:(PhotonIMMessageStatus)msgStatus;
/**
 获取用户数据库中所有正在发送的消息
 
 @return <#return value description#>
 */
- (NSArray<PhotonIMMessage *> *)getAllSendingMessages;


#pragma mark ------ 回话数据操作相关 --------

/**
 创建存储一个会话

 @param conversation <#conversation description#>
 */
- (void)saveConversation:(PhotonIMConversation *)conversation;


/**
 批量存储会话

 @param conversations <#conversations description#>
 */
- (void)saveConversationBatch:(NSArray<PhotonIMConversation *>*)conversations;

/**
  更新会话的免打扰设置

 @param conversation <#conversation description#>
 */
- (void)updateConversationIgnoreAlert:(PhotonIMConversation *)conversation;
/**
 更新会话的指定设置
 
 @param conversation <#conversation description#>
 */
- (void)updateConversationSticky:(PhotonIMConversation *)conversation;

/**
 会话草稿

 @param conversation <#conversation description#>
 */
- (void)updateConversationDraft:(PhotonIMConversation *)conversation;

/**
 更新会话的额外信息

 @param conversation <#conversation description#>
 */
- (void)updateConversationExtra:(PhotonIMConversation *)conversation;

/**
 更新会话的额外信息
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param extra 额外信息
 */
- (void)updateConversationExtra:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith extra:(NSDictionary *)extra;

/**
 更新会话的未读数
 
 @param conversation <#conversation description#>
 */
- (void)updateConversationUnReadCount:(PhotonIMConversation *)conversation;


/**
 更新会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param count 未读数
 */
- (void)updateConversationUnReadCount:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith count:(NSInteger)count;

/**
 清空一个会话的未读数
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 */
- (void)clearConversationUnReadCount:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 删除会话

 @param conversation 会话对象
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMConversation *)conversation clearChatMessage:(BOOL)clearChatMessage;

/**
 删除会话

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param clearChatMessage 是否同时清空会话中的消息
 */
- (void)deleteConversation:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith clearChatMessage:(BOOL)clearChatMessage;

/**
 判断会话是否存在

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return YES 会话存在 NO 会话不存在
 */
- (BOOL)isConversationExist:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;

/**
 查找会话
 
 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @return 会话对象
 */
- (PhotonIMConversation *)findConversation:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith;
/**
 查找会话
 @param start 开始查找的位置
 @param size 查找的个数
 @param asc 按升序还是降序查找 YES 是升序
 @return <#return value description#>
 */
- (NSArray<PhotonIMConversation *> *)findConversationList:(int)start size:(int)size asc:(BOOL)asc;

// 
- (void)updateConversationWithLastMsgArg1:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith arg:(int)arg;
- (void)updateConversationWithLastMsgArg2:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith arg:(int)arg;
// 自定义字段的操作
- (void)updateConversationWithCustomArg1:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith arg:(int)arg;
- (void)updateConversationWithCustomArg2:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith arg:(int)arg;
- (NSArray<PhotonIMConversation *> *)findConversationListWithCustomArg1:(int)arg asc:(BOOL)asc;
- (NSArray<PhotonIMConversation *> *)findConversationListWithCustomArg2:(int)arg asc:(BOOL)asc;


/**
 下拉获取加载更多的会话消息

 @param chatType 会话类型
 @param chatWith 会话中对方的id
 @param anchor 开始一次查询的锚点
 @param size 每次查询的条数
 @param result 回调的数据结构是查询到数据以及下次查询数据的锚点
 */
- (void)loadHistoryMessages:(PhotonIMChatType)chatType chatWith:(NSString *)chatWith anchor:(nullable NSString *)anchor size:(int)size reaultBlock:(void(^)(NSArray<PhotonIMMessage *> *,NSString *))result;
@end

NS_ASSUME_NONNULL_END
