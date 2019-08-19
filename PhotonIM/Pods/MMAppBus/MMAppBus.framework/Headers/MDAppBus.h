//
//  MDAppBus.h
//  MomoChat
//
//  Created by Eli xu on 16/5/4.
//  Copyright © 2016年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef MD_REGISTER_SERVICE
#define MD_REGISTER_SERVICE(serviceProtocol) \
+ (void)load { [MDAppBus registerService:@protocol(serviceProtocol) withImplementClass:[self class]]; }

@protocol MDService <NSObject>
@required

/*
 生命周期管理后的初始化方法
 */
- (void)serviceDidInit;

@end


#undef AL_EXPORT_UNIT
#define AL_EXPORT_UNIT(unitProtocol) \
+ (void)load { [MDAppBus registerUnit:@protocol(unitProtocol) withUnitClass:[self class]]; }

@protocol MDUnit <NSObject>

@end


@interface MDAppBus : NSObject
/*
 just like
 id<XXXServiceProtocol> service = [MDAppContext service:XXXServiceProtocol];
 */

/*
 生命周期关联User 但是不对外部提供接口
 */
+ (id)element:(Class)aclass;

/*
 生命周期关联User 同时对外部提供接口
 */
+ (id)service:(Protocol *)serviceProtocol;
+ (BOOL)existService:(Protocol *)serviceProtocol;
+ (void)registerService:(Protocol *)serviceProtocol withImplementClass:(Class)implClass;

/*
 生命周期只由外部控制 同时对外部提供接口
 */
+ (Class)unit:(Protocol*)unitProtolcol;
+ (BOOL)existUnit:(Protocol *)unitProtocol;
+ (void)registerUnit:(Protocol *)unitProtocol withUnitClass:(Class)implClass;

@end
