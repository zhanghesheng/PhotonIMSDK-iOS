//
//  PhotonIMImageBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMTextBody : PhotonIMBaseBody
@property (nonatomic, copy, readonly, nullable)NSString *text;

- (instancetype)initWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
