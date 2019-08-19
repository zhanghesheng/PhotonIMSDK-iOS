//
//  PhotonDBManager.h
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
NS_ASSUME_NONNULL_BEGIN

@interface PhotonDBManager : NSObject
+ (instancetype)defaultManager;
+ (FMDatabaseQueue *)dbQueue;

+ (void)openDB;

+ (void)closeDB;
@end

NS_ASSUME_NONNULL_END
