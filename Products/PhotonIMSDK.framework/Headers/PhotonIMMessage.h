//
//  PhotonIMMessage.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/29.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonIMBaseMessage.h"
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMMessage : PhotonIMBaseMessage

/**
 消息体,
 */
@property (nonatomic, strong, readonly ,nullable)PhotonIMBaseBody *messageBody;

///////////////// 消息撤回相关 ///////////////////

/**
 撤回消息的id
 */
@property (nonatomic, copy, nullable)NSString *withdrawMsgID;

/**
消息撤回后的提示,上行消息非必需
 */

@property (nonatomic, copy, nullable)NSString *withdrawNotice;



///////////////// 消息已读相关 ///////////////////
/**
 已读消息的id集合
 */
@property (nonatomic, copy, nullable)NSArray  *readMagIds;


/**
 设置消息体

 @param mesageBody <#mesageBody description#>
 */
- (void)setMesageBody:(PhotonIMBaseBody * _Nullable)mesageBody;
@end

NS_ASSUME_NONNULL_END
