//
//  PhotonAccountItem.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonBaseTableItem.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,PhotonAccountType) {
    PhotonAccountTypeRegister = 1,
    PhotonAccountTypeLogin = 2,
};
@interface PhotonAccountItem : PhotonBaseTableItem
@property (nonatomic, copy, nullable) NSString *placeholder;
@property (nonatomic, assign) PhotonAccountType accountType;

@property (nonatomic, copy, nullable) NSString *userID;
@property (nonatomic, copy, nullable) NSString *password;
@end

NS_ASSUME_NONNULL_END
