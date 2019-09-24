//
//  PhotonGroupMemberListViewController.h
//  PhotonIM
//
//  Created by Bruce on 2019/9/24.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonBaseViewController.h"
#import "PhotonMacros.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ PhotonGroupMemberListBlock)(AtType type,NSDictionary * _Nullable);

@interface PhotonGroupMemberListViewController : PhotonBaseViewController
- (instancetype)initWithGid:(NSString *)gid result:(PhotonGroupMemberListBlock)result;
@end

NS_ASSUME_NONNULL_END
