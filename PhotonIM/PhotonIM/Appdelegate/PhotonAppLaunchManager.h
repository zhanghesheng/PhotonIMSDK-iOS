//
//  PhotonAppLaunchManager.h
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhotonAppLaunchManager : NSObject
+ (void)registerWithWindow:(UIWindow *)window;
+ (void)launchInWindow;
@end

NS_ASSUME_NONNULL_END
