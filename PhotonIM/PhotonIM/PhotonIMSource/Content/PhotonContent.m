//
//  PhotonContent.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/25.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonContent.h"
#import <pushsdk/MoPushManager.h>
#import "PhotonDBUserStore.h"
#import "PhotonMessageCenter.h"
#import "PhotonAppLaunchManager.h"
@interface PhotonContent()
@property(nonatomic, strong, nullable)PhotonUser *currentUser;
@end
@implementation PhotonContent
+ (instancetype)sharedInstance{
    static PhotonContent *content = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        content = [[PhotonContent alloc] init];
    });
    return content;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentUser = [[PhotonUser alloc] init];
       id user = [[NSUserDefaults standardUserDefaults] objectForKey:@"photon_current_user"];
        if ([user isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDict = user;
            _currentUser.userID = [userDict objectForKey:@"photon_user_id"];
            _currentUser.userName = [userDict objectForKey:@"photon_user_name"];
            _currentUser.sessionID = [userDict objectForKey:@"photon_user_sessionid"];
        }
    }
    return self;
}
+ (PhotonAppDelegate *)sharedAppDelegate
{
    __block PhotonAppDelegate *appDelegate = nil;
    
    if ([NSThread isMainThread]) {
        appDelegate = (PhotonAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            appDelegate = (PhotonAppDelegate *)[[UIApplication sharedApplication] delegate];
        });
    }
    
    return appDelegate;
}
+ (PhotonUser *)currentUser{
    return [PhotonContent sharedInstance].currentUser;
}

+ (void)persistenceCurrentUser{
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    PhotonUser *user = [self currentUser];
    if ([user.userID isNotEmpty]) {
        [userDict setValue:user.userID forKey:@"photon_user_id"];
    }
    if ([user.userName isNotEmpty]) {
        [userDict setValue:user.userName forKey:@"photon_user_name"];
    }
    if ([user.sessionID isNotEmpty]) {
        [userDict setValue:user.sessionID forKey:@"photon_user_sessionid"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userDict forKey:@"photon_current_user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)clearCurrentUser{
    [PhotonContent sharedInstance].currentUser = [[PhotonUser alloc] init];
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"photon_current_user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (PhotonUser *)userDetailInfo{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    PhotonUser *user = [userDB getFriendsByUid:[PhotonContent currentUser].userID friendID:[PhotonContent currentUser].userID];
    return user;
}

+ (PhotonUser *)friendDetailInfo:(NSString *)fid{
    PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    PhotonUser *user = [userDB getFriendsByUid:[PhotonContent currentUser].userID friendID:fid];
    return user;
}
+ (void)addFriendToDB:(PhotonUser *)user{
     PhotonDBUserStore *userDB = [[PhotonDBUserStore alloc] init];
    [userDB addFriend:user forUid:[PhotonContent currentUser].userID];
}

+ (void)logout{
    [PhotonUtil runMainThread:^{
         [MoPushManager unAlias:[PhotonContent currentUser].userID];
        [self clearCurrentUser];
        [PhotonAppLaunchManager launchInWindow];
    }];
   
}

+ (void)login{
    [PhotonUtil runMainThread:^{
        [MoPushManager registerWithAlias:[PhotonContent currentUser].userID];
    }];
}
@end
