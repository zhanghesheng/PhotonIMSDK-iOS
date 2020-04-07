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
 服务端缩略图大图地址
 */
@property (nonatomic, copy, nullable)NSString *bigURL;
/**
 服务端缩略图地址
 */
@property (nonatomic, copy, nullable)NSString *thumbURL;

/**
 图片的宽高比
 */
@property (nonatomic, assign)CGFloat whRatio;

/// 构建PhotonIMImageBody对象,此构造方法适用于业务端自己管理文件上传下载及相关的存储
/// @param url 图片原图在服务端的地址
/// @param bigURL 图片大图在服务端的地址
/// @param thumbURL 图片缩略图在服务端的地址
/// @param localFileName 图片本地存储的相对路径8
/// @param whRatio 图片宽高比
+ (PhotonIMImageBody *)imageBodyWithURL:(NSString *)url
                                 bigURL:(nullable NSString *)bigURL
                            thumbURL:(nullable NSString *)thumbURL
                               localFileName:(nullable NSString *)localFileName
                                whRatio:(CGFloat)whRatio;

/// 构建PhotonIMImageBody对象,此构件方法适用于使用SDK的文件托管（sdk处理文件的上传下载和存储功能）
/// @param imageData 图片的二进制数据。适用于相册选择得到的图片数据
/// @param imageName 图片名称(显示)
/// @param whRatio 图片宽高比
+ (PhotonIMImageBody *)imageBodyWithData:(NSData *)imageData
                               imageName:(NSString *)imageName
                                 whRatio:(CGFloat)whRatio;


/// 构建PhotonIMImageBody对象,此构件方法适用于使用SDK的文件托管（sdk处理文件的上传下载和存储功能）
/// @param imagePath 图片存储在业务端的本地路径
/// @param imageName 图片名称(显示)
/// @param whRatio 图片宽高比
+ (PhotonIMImageBody *)imageBodyWithImagePath:(NSString *)imagePath
                                    imageName:(nullable NSString *)imageName
                                      whRatio:(CGFloat)whRatio;
@end

NS_ASSUME_NONNULL_END
