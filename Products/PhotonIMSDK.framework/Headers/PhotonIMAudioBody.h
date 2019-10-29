//
//  PhotonIMAudioBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMAudioBody : PhotonIMMediaBody
+ (PhotonIMAudioBody *)audioBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                          localFileName:(nullable NSString *)localFileName;
@end

NS_ASSUME_NONNULL_END
