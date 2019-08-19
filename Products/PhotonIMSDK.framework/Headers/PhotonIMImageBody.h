//
//  PhotonIMImageBody.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/6/28.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMImageBody : PhotonIMBaseBody
/**
 服务端缩略图地址
 */
@property (nonatomic, copy, nullable)NSString *thumbURL;


/**
 图片大小
 */
@property (nonatomic, assign)CGSize imageSize;

/**
 图片的宽高比
 */
@property (nonatomic, assign)CGFloat whRatio;
@end

NS_ASSUME_NONNULL_END
