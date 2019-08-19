//
//  PhotonIMClient+HandleReceiveMessge.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMClient (HandleReceiveMessge)
#pragma mark ---- 监听下行消息 --------

/**
 添加监听对象
 
 @param observer <#observer description#>
 */
- (void)addObservers:(id<PhotonIMClientProtocol>)observer;

/**
 移除指定的监听对象
 
 @param observer <#observer description#>
 */
- (void)removeObserver:(id<PhotonIMClientProtocol>)observer;

/**
 移除所有的监听对象
 */
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
