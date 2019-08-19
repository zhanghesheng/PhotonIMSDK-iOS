//
//  CallbackMessage.h
//  pushsdk-ios
//
//  Created by wangduanqing on 2018/12/6.
//  Copyright © 2018年 momo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, COMMAND) {
    COMMAND_REGISTER = 1,// 注册token
    COMMAND_REGISTER_ALIAS = 2,// 已别名注册token
    COMMAND_UNREGISTER  = 3,// 取消注册
    COMMAND_ALIAS = 4,// 注册别名
    COMMAND_UNALIAS = 5,// 取消别名
    COMMAND_VENDOR_REG = 6,// 注册devicetoken
    COMMAND_LOGOUT = 7,// 退出登录
    COMMAND_REGTOKENTAG = 8,// token绑定标签
    COMMAND_UNREGTOKENTAG = 9,// token解绑标签
    COMMAND_REGALIASTAG = 10,// 别名绑定标签
    COMMAND_UNREGALIASTAG = 11// 别名绑定标签
};

@interface CallbackMessage : NSObject

/**
 注册等请求命令的编号
 */
@property (nonatomic,assign) COMMAND command;
/**
 注册等请求响应码，
 */
@property (nonatomic,assign) int resultCode;
/**
 注册等请求命令名称 比如 reg
 */
@property (nonatomic, copy) NSString *commandName;
/**
 注册等请求命令响应的内容，比如token
 */
@property (nonatomic,copy) NSString * message;

@end

NS_ASSUME_NONNULL_END
