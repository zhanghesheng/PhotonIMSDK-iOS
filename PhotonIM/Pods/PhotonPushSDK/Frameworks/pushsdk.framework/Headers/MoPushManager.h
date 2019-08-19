//
//  MoPushManager.h
//  pushsdk-ios
//
//  Created by wangduanqing on 2018/12/4.
//  Copyright © 2018年 momo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CallbackMessage.h"


//SDK版本
#define SDK_VERSION 10000

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,MOBuildStat) {
    MOBuildStat_DEBUG = 0,
    MOBuildStat_INHOUSE = 1,
    MOBuildStat_RELEASE = 2,
};


@interface MoPushManager : NSObject

@property (nonatomic,assign) SEL mCommandListener;
@property (nonatomic,weak) id lisenterTarget;
@property (nonatomic,strong) CallbackMessage *callbackMessage;
@property (nonatomic, strong, readonly) dispatch_queue_t queue;

/**
 初始化push sdk
 @paramter appID 在服务端申请获得的id
 return void
 */
+ (void)initSDK: (NSString  *)appID;

/**
 初始化push sdk是否完成
 */
+ (BOOL)isReady;

/**
 设置app的编译类型
 @paramter buildStat 编译类型(debug,inhouse,release, 默认是release)
 return void
 */
+ (void)setBuildStat:(MOBuildStat)buildStat;

/**
 使用初始化的app id 注册获取服务端的token
 */
+ (void)registerToken;

/**
 以别名注册，其相当于调用（registerToken和setAlias:alias:）方法
 @paramter alias 业务层要注册的别名
 */
+ (void)registerWithAlias:(NSString *) alias;


/**
 设置别名
 @paramter token 注册后获取到客户端的token，会通过注册的回调方法返回给客户端，一般可以忽略设置为nil
 @paramter alias 要设置的别名
 */
+ (void)setAlias: (NSString * _Nullable)token alias:(NSString *)alias;

/**
 设置别名
 @paramter alias 要设置的别名
 */
+ (void)setAlias:(NSString *)alias;

/**
 取消别名
 @paramter token 注册后获取到客户端的token，会通过注册的回调方法返回给客户端，一般可以忽略设置为nil
 @paramter alias 要取消的别名
 */
+ (void)unAlias: (NSString * _Nullable)token alias:(NSString *)alias;

/**
 取消别名
 @paramter alias 要取消的别名
 */
+ (void)unAlias:(NSString *)alias;

/**
 退出
 @paramter token 注册后获取到客户端的token，会通过注册的回调方法返回给客户端，一般可以忽略设置为nil
 */
+ (void)logout: (NSString * _Nullable)token;

/**
 退出
 */
+ (void)logout;

/*
 token绑定标签
 */

+ (void)setTag:(NSString *)tag;

/*
 token解绑标签
 */
+ (void)unTag:(NSString *)tag;

/*
 别名绑定标签
 */

+ (void)setTagWithAlias:(NSString *)alias tag:(NSString *)tag;

/*
 别名解绑标签
 */
+ (void)unTagWithAlias:(NSString *)alias tag:(NSString *)tag;

/**
 业务端注册回调的方法
 @paramter mSelctor 方法实现
 @paramter mTarget 方法实现所在的对象
 */
+ (void) addCommandListener: (SEL) mSelctor target:(id) mTarget;

+ (void) onCommand:(int) command name:(NSString *)name  code: (int) code message:(NSString *) message;

+ (BOOL)isReachable;


+ (dispatch_queue_t)getPushQueue;

+ (void)runBlock:(dispatch_block_t)aBlock;

+ (void)uploadLog;
@end

NS_ASSUME_NONNULL_END
