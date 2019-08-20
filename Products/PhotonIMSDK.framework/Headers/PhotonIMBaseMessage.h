//
//  PhotonIMBaseMessage.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMEnum.h"
NS_ASSUME_NONNULL_BEGIN
@interface PhotonIMBaseMessage : NSObject

/**
 消息类型
 */
@property(nonatomic, copy, nullable) NSString *messageID;

/**
 对方id 
 */
@property(nonatomic, copy, nullable)NSString *chatWith;

/**
 时间，以毫秒为单位
 */
@property(nonatomic, assign) int64_t timeStamp;
/**
 发送者
 */
@property(nonatomic, copy, nullable) NSString *fr;
/**
 接收者
 */
@property(nonatomic, copy, nullable) NSString *to;

/**
 消息类型
 */
@property(nonatomic, assign)PhotonIMMessageType messageType;

/**
 会话类型
 */
@property(nonatomic, assign)PhotonIMChatType chatType;


/**
 扩展信息
 */
@property(nonatomic, strong, nullable) NSMutableDictionary<NSString*, NSString*> *extra;




#pragma mark ---- 协议外的消息状态 ---------

/**
 消息送达状态
 */
@property (nonatomic, assign)PhotonIMMessageStatus messageStatus;


/**
 消息发送回执的提醒文本，比如（被拒收或者触发spam）
 */
@property (nonatomic,copy, nullable)NSString  *notic;


#pragma mark ----- 消息在服务端的位置标记，使用sdk的数据库不需要关注此项 -----
/**
 当前消息属于哪个消息队列
 */
@property (nonatomic, copy, nullable) NSString *lt;

/**
 当前消息在队列中的游标
 */
@property (nonatomic, assign) int64_t lv;
@end

NS_ASSUME_NONNULL_END
