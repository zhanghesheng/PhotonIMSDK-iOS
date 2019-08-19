//
//  PhotonDBFriendStore.h
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonDBaseStore.h"

NS_ASSUME_NONNULL_BEGIN
@class PhotonUser;
@interface PhotonDBUserStore : PhotonDBaseStore
- (BOOL)addFriend:(nullable PhotonUser *)user forUid:(nullable NSString *)uid;

- (BOOL)updateFriendsData:(nullable NSArray *)friendData forUid:(nullable NSString *)uid;

- (NSMutableArray<PhotonUser *> *)getFriendsByUid:(nullable NSString *)uid;

- (PhotonUser *)getFriendsByUid:(nullable NSString *)uid friendID:(nullable NSString *)fid;

- (BOOL)deleteFriendByFid:(nullable NSString *)fid forUid:(nullable NSString *)uid;
@end

NS_ASSUME_NONNULL_END
