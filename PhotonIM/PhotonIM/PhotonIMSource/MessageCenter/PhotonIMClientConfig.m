//
//  PhotonIMClientConfig.m
//  PhotonIM
//
//  Created by Bruce on 2020/5/9.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonIMClientConfig.h"

@implementation PhotonIMClientConfig
- (NSString *)customConnectionHost{
    return @"";
}

- (NSString *)customAppVersion{
    return @"";
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
     [[NSUserDefaults standardUserDefaults] setValue:[@([[NSDate date] timeIntervalSince1970]) stringValue] forKey:@"timeStamp_pushqq"];
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary *dict = response.notification.request.content.userInfo;
        NSLog(@"%@",dict[@"gotoStr"]);
    }
    completionHandler();
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)){
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"cdscds" message:@"vxvsd" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"ok", nil];
    [alert show];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"获取到deviceToken -- %@", deviceToken); //SDK内部hook，业务层无需配置
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"获取失败deviceToken -- %@", error.localizedDescription);
}


// appid
- (NSString *)getAppid{
    return @"2bd1a15c553de0a9df6dcede9af22962";
}

- (NSString *)getAppVersion{
    return @"1438";
}

- (NSString *)getOsType{
    return @"iOS";
}

- (NSString *)getUseragent{
    return @"MomoChat/9.0 ios/1471 (iPhone 8; iOS 12.1.2; zh_CN; iPhone10,1; S1)";
}
// 获取全局的域名配置，需要配置预埋
- (NSString *)getHttpDNSGlobalConfigs{
    return @"";
}
// 获取当前的用户id
- (NSString *)getUserid{
    return @"12345";
}

// 获取当前的用户id
- (double)getLng{
    return 0.0f;
}

// 获取当前的用户id
- (double)getLat{
    return 32.43f;
}

// 指定预先解析的域名
- (nonnull NSArray<NSString *> *)getPreResolveHosts {
    return @[@"immomo.com"];
}

@end
