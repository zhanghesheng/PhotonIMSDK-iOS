//
//  PhotonGroupMemberListModel.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/24.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupMemberListModel.h"
#import "PhotonChatTransmitItem.h"
#import "PhotonTitleTableItem.h"
@implementation PhotonGroupMemberListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadItems:(nullable NSDictionary *)params finish:(void (^)(NSDictionary * _Nullable))finish failure:(void (^)(PhotonErrorDescription * _Nullable))failure{
    [super loadItems:params finish:finish failure:failure];
    __weak typeof(self)weakSelf = self;
    [PhotonUtil showLoading:nil];
    [self.netService commonRequestMethod:PhotonRequestMethodPost queryString:@"photonimdemo/group/remote/members" paramter:params completion:^(NSDictionary * _Nonnull responseDict) {
        [weakSelf wrappResponseddDict:responseDict];
        if (finish) {
            finish(nil);
        }
        [PhotonUtil hiddenLoading];
    } failure:^(PhotonErrorDescription * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [PhotonUtil hiddenLoading];
    }];
}

- (void)wrappResponseddDict:(NSDictionary *)dict{
    [super wrappResponseddDict:dict];
    NSDictionary *data = [dict objectForKey:@"data"];
    if (data.count > 0) {
        NSArray *lists = [data objectForKey:@"lists"];
        PhotonTitleTableItem *allItem = [[PhotonTitleTableItem alloc]init];
        allItem.title = [NSString stringWithFormat:@"所有人(%@)",@(data.count)];
        [self.items addObject:allItem];
        if (lists.count > 0) {
            self.items = [PhotonIMThreadSafeArray arrayWithCapacity:lists.count];
            for (NSDictionary *item in lists) {
                PhotonUser *user = [[PhotonUser alloc] init];
                user.userID = [[item objectForKey:@"userId"] isNil];
                user.nickName = [[item objectForKey:@"nickname"] isNil];
                user.userName = [[item objectForKey:@"username"] isNil];
                user.avatarURL = [[item objectForKey:@"avatar"] isNil];
                [PhotonContent addFriendToDB:user];
                if (user) {
                    PhotonChatTransmitItem *item = [[PhotonChatTransmitItem alloc] init];
                    item.contactID = user.userID;
                    item.contactName = user.nickName;
                    item.contactAvatar = user.avatarURL;
                    [self.items addObject:item];
                }
            }
        }
    }
}

@end
