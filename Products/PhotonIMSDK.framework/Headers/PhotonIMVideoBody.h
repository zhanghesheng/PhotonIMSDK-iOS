//
//  PhotonIMVideoBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/3.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <PhotonIMSDK/PhotonIMSDK.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN
/// 视频消息的消息体，构建此消息体发送视频消息，其对应的消息类型是PhotonIMMessageType::PhotonIMMessageTypeVideo
@interface PhotonIMVideoBody : PhotonIMMediaBody

/// 服务端存储的封面图地址
@property(nonatomic, copy, nullable) NSString *coverUrl;
// 封面图的宽高比
@property(nonatomic, assign)CGFloat  whRatio;

/// 遍历构造VideoBody
/// @param url 服务端存储的资源地址
/// @param mediaTime 视频时长（单位可由业务端协商自行决定）
/// @param coverUrl 服务端存储的封面图地址
/// @param whRatio 封面图的宽高比
/// @param localFileName 资源本地存储的相对路径
+ (PhotonIMVideoBody *)videoBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                               coverUrl:(nullable NSString *)coverUrl
                                whRatio:(CGFloat)whRatio
                          localFileName:(nullable NSString *)localFileName;


/// 遍历构造VideoBody
/// @param url 服务端存储的资源地址
/// @param mediaTime 视频时长（单位可由业务端协商自行决定）
/// @param coverUrl 服务端存储的封面图地址
/// @param whRatio 封面图的宽高比
/// @param localFileName 资源本地存储的相对路径
/// @param srcDescription  资源描述，此字段会入库，内容可作为全文搜索使用
+ (PhotonIMVideoBody *)videoBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                               coverUrl:(nullable NSString *)coverUrl
                                whRatio:(CGFloat)whRatio
                          localFileName:(nullable NSString *)localFileName
                            srcDescription:(nullable NSString *)srcDescription;
@end

NS_ASSUME_NONNULL_END
