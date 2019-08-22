//
//  PhotonIMError.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 code    描述
 0       发送成功
 1000    服务器内部错误
 1001    消息内容包含敏感词
 1002    图片非法
 1003    消息发送频率过高
 1004    消息不可撤回
 -1      消息发送超时
 -2      切换账号时，等待发送的消息
 */
@interface PhotonIMError : NSError
@property(nonatomic,copy,readonly,nullable,)NSString *em;
- (instancetype)initWithDomain:(NSErrorDomain)domain code:(NSInteger)code errorMessage:(NSString *)em userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code errorMessage:(NSString *)em userInfo:(NSDictionary<NSErrorUserInfoKey,id> *)dict;
@end

NS_ASSUME_NONNULL_END
