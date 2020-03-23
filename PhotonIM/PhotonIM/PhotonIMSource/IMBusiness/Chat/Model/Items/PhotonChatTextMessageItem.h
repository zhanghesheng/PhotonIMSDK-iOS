//
//  PhotonTextMeesageChatItem.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/21.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonChatBaseItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotonChatTextMessageItem : PhotonChatBaseItem
@property(nonatomic, copy, nullable) NSString *messageText;
@property(nonatomic, copy, nullable) NSAttributedString *messageAttriText;
@property(nonatomic, copy, nullable) NSArray *atInfo;
@property(nonatomic, assign) int  type;
@end

NS_ASSUME_NONNULL_END