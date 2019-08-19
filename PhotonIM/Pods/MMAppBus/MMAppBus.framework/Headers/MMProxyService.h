//
//  MMProxyService.h
//  Pods
//
//  Created by momo783 on 2017/5/31.
//
//

#ifndef MMProxyService_h
#define MMProxyService_h
#import "MDAppBus.h"

#import <UIKit/UIKit.h>
@class CLLocation, MDApiMapping, MDAudioPlayer;

// 分享
typedef void (^MMProxyServiceShareBlock)(NSString *roomId, NSInteger roomType);

@protocol MMProxyService <MDService>

/**********************MDContext & MDUser********************/

/**
 *  RootNav
 */
- (UINavigationController *)rootNavController;

/**
 *  用户Session
 */
- (NSString *)session;

/**
 *  定位坐标
 */
- (CLLocation *)location;

/**
 *  Api代理
 */
- (MDApiMapping *)apiMapping;

/**
 *  音频播放
 */
- (MDAudioPlayer *)audioPlayer;

/**
 * 获取ua部分数据
 */
- (NSString *)getJsonUserAgent;

/**********************Goto 跳转***************************/
/**
 *  调用客户端goto
 */
- (void)handleActionString:(NSString *)actionString;

/**********************音频句柄处理**************************/

/**
 *  获取音频句柄
 */
- (NSInteger)prime:(NSInteger)bizType;

/**
 * 交还音频句柄
 */
- (void)resign;

/************************分享处理****************************/
- (MMProxyServiceShareBlock)shareBlock;

/************************全链日志****************************/
/**
 *  根节点
 */
- (void)startLogAction:(NSString *)actionName;
- (void)endLogAction:(NSString *)actionName;


/**
 *  子节点
 */
- (void)startStep:(NSString *)actionName spanName:(NSString *)spanName;
- (void)endStep:(NSString *)actionName;

/********************Referee转换地址*************************/
/**
 * referee本地列表或默认缓存列表
 */
- (NSDictionary*)refereeDict;

/**
 * 使用referee机制转换http url, urlPath为服务器文件路径
 */
- (NSString*)httpsUrlWithPath:(NSString*)urlPath;

- (BOOL)isEnableTestEnvironment;

- (NSString*)replaceHostWithOrigin:(NSString*)oldHost;

/***********************崩溃辅助信息**************************/
/**
 崩溃辅助日志，记录崩溃前用户行为，可在Fabric Logs查看

 @param log 日志内容
 */
- (void)crashLog:(NSString *)log;

/**
 崩溃辅助标记，记录崩溃前状态，可在Fabric Keys查看

 @param key 标记名
 @param value 标记值
 */
- (void)crashKey:(NSString *)key value:(NSString *)value;

/***********************业务冲突提示**************************/
/**
 设置业务冲突状态，设置期间其它音视频相关业务都会被拦截并弹出提示。调用方需要强持有返回的对象，释放后自动结束业务冲突状态。
 
 @param tip 提示内容，nil则弹出默认提示（尽量不要传nil）
 @return 业务冲突处理器，释放后自动结束冲突状态
 */
- (id)setBizConflictWithTip:(NSString *)tip;

@end

#endif /* MMProxyService_h */
