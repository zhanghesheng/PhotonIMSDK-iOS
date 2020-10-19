//
//  HXPreviewImageView.m
//  照片选择器
//
//  Created by 洪欣 on 2019/11/15.
//  Copyright © 2019 洪欣. All rights reserved.
//

#import "HXPreviewImageView.h"
#import "UIImageView+HXExtension.h"
#import "HXPhotoModel.h"
#import "HXPhotoDefine.h"
#import "HXCircleProgressView.h"
#import "UIView+HXExtension.h"

#import <PhotonIMSDK/PhotonIMSDK.h>

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+GIF.h"
#import "SDAnimatedImageView.h"
#elif __has_include("UIImageView+WebCache.h")
#import "UIImageView+WebCache.h"
#endif

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#elif __has_include("YYWebImage.h")
#import "YYWebImage.h"
#elif __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#elif __has_include("YYKit.h")
#import "YYKit.h"
#endif

@interface HXPreviewImageView ()
#if HasSDWebImage
@property (strong, nonatomic) SDAnimatedImageView *sdImageView;
#endif
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) HXCircleProgressView *progressView;
@end

@implementation HXPreviewImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sdImageView];
        [self addSubview:self.progressView];
    }
    return self;
}
- (void)setImage:(UIImage *)image{
#if HasPhotonIMSDK
    self.sdImageView.image = image;
#else
    self.imageView.image = image;
#endif
}
- (UIImage *)image {
    UIImage *image;
    if (self.model.type == HXPhotoModelMediaTypePhotoGif) {
        if (self.sdImageView.image.images.count > 0) {
            image = self.sdImageView.image.images.firstObject;
        }else {
            image = self.sdImageView.image;
        }
    }else {
        image = self.sdImageView.image;
    }
    return image;
}
- (void)setModel:(HXPhotoModel *)model {
    _model = model;
    HXWeakSelf
    
    if (model.type == HXPhotoModelMediaTypeCameraVideo) {
        self.progressView.progress = 1;
        self.progressView.hidden = YES;
        self.model.downloadComplete = YES;
        self.sdImageView.image = model.previewPhoto;
        if (self.downloadICloudAssetComplete) {
            self.downloadICloudAssetComplete();
        }
        if (self.downloadNetworkImageComplete) {
            self.downloadNetworkImageComplete();
        }
    }

    if (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeCameraVideo) {
        if (model.networkPhotoUrl) {
            self.progressView.hidden = model.downloadComplete;
            CGFloat progress = (CGFloat)model.receivedSize / model.expectedSize;
            self.progressView.progress = progress;
            if (model.userInfo) {
                PhotonIMDownloadFileQuality fileQuality = PhotonIMDownloadFileQualityHight;
                if (model.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeLocal) {
                    fileQuality = PhotonIMDownloadFileQualityOrigin;
                }
                UIImage *image = [UIImage imageWithContentsOfFile:model.fileLocalURL.path];
                if (image) {
                    self.progressView.progress = 1;
                    self.progressView.hidden = YES;
                    self.model.downloadComplete = YES;
                    self.sdImageView.image = image;
                    if (self.downloadICloudAssetComplete) {
                        self.downloadICloudAssetComplete();
                    }
                    if (self.downloadNetworkImageComplete) {
                        self.downloadNetworkImageComplete();
                    }
                [[PhotonIMClient sharedClient] getLocalFileWithMessage:model.userInfo fileQuality:fileQuality progress:^(NSProgress * _Nonnull downloadProgress) {
                         CGFloat pro = (CGFloat)downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                         weakSelf.progressView.progress = pro;
                    } completion:^(NSString * _Nullable filePath, NSError * _Nullable error) {
                        if ((!filePath || filePath.length == 0) || error) {
                             [weakSelf.progressView showError];
                        }else{
                            weakSelf.progressView.progress = 1;
                            weakSelf.progressView.hidden = YES;
                            weakSelf.model.downloadComplete = YES;
                            if (weakSelf.downloadICloudAssetComplete) {
                                weakSelf.downloadICloudAssetComplete();
                            }
                            if (weakSelf.downloadNetworkImageComplete) {
                                weakSelf.downloadNetworkImageComplete();
                            }
                            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                            weakSelf.sdImageView.image = image;
                            model.fileLocalURL = [NSURL fileURLWithPath:filePath];
                        }
                    }];
                    return;
                }
                [self.sdImageView hx_setImageWithModel:model progress:^(CGFloat progress, HXPhotoModel *model) {
                    if (weakSelf.model == model) {
                        weakSelf.progressView.progress = progress;
                    }
                } completed:^(UIImage *image, NSError *error, HXPhotoModel *model) {
                    if (weakSelf.model == model) {
                        if (error != nil) {
                            [weakSelf.progressView showError];
                        }else {
                            if (image) {
                                weakSelf.progressView.progress = 1;
                                weakSelf.progressView.hidden = YES;
                                weakSelf.imageView.image = image;
                                if (weakSelf.downloadICloudAssetComplete) { weakSelf.downloadICloudAssetComplete();
                                }
                                if (weakSelf.downloadNetworkImageComplete) {
                                    weakSelf.downloadNetworkImageComplete();
                                }
                            }
                        }
                    }
                }];
            }
        }
        
    }
}
- (void)requestHDImage {
    CGSize size;
    CGFloat scale;
    if (HX_IS_IPhoneX_All) {
        scale = 3.0f;
    }else if ([UIScreen mainScreen].bounds.size.width == 320) {
        scale = 2.0;
    }else if ([UIScreen mainScreen].bounds.size.width == 375) {
        scale = 2.5;
    }else {
        scale = 3.0;
    }
    
    if (self.hx_h > self.hx_w / 9 * 20 ||
        self.hx_w > self.hx_h / 9 * 20) {
        size = CGSizeMake(self.superview.hx_w * scale, self.superview.hx_h * scale);
    }else {
        size = CGSizeMake(self.model.endImageSize.width * scale, self.model.endImageSize.height * scale);
    }
    HXWeakSelf
    if (self.model.type == HXPhotoModelMediaTypeCameraPhoto) {
        if (self.model.networkPhotoUrl) {
            if (!self.model.downloadComplete) {
                self.progressView.hidden = NO;
                self.progressView.progress = (CGFloat)self.model.receivedSize / self.model.expectedSize;;
            }else if (self.model.downloadError) {
                [self.progressView showError];
            }
        }
    }else if (self.model.type == HXPhotoModelMediaTypePhoto) {
        self.requestID = [self.model requestPreviewImageWithSize:size startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            if (weakSelf.model.isICloud) {
                weakSelf.progressView.hidden = NO;
            }
            weakSelf.requestID = iCloudRequestId;
        } progressHandler:^(double progress, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            if (weakSelf.model.isICloud) {
                weakSelf.progressView.hidden = NO;
            }
            weakSelf.progressView.progress = progress;
        } success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
            if (weakSelf.model != model) return;
            [weakSelf downloadICloudAssetComplete];
            weakSelf.progressView.hidden = YES;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
#if HasPhotonIMSDK
            [weakSelf.sdImageView.layer removeAllAnimations];
            weakSelf.sdImageView.image = image;
            [weakSelf.sdImageView.layer addAnimation:transition forKey:nil];
#else
            [weakSelf.imageView.layer removeAllAnimations];
            weakSelf.imageView.image = image;
            [weakSelf.imageView.layer addAnimation:transition forKey:nil];
#endif
        } failed:^(NSDictionary *info, HXPhotoModel *model) {
            if (weakSelf.model != model) return;
            weakSelf.progressView.hidden = YES;
        }];
    }else if (self.model.type == HXPhotoModelMediaTypePhotoGif) {
        if (self.gifImage) {
#if HasPhotonIMSDK
            if (self.sdImageView.image != self.gifImage) {
                self.sdImageView.image = self.gifImage;
            }
#else
            if (self.imageView.image != self.gifImage) {
                self.imageView.image = self.gifImage;
            }
#endif
        }else {
            self.requestID = [self.model requestImageDataStartRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
                if (weakSelf.model != model) return;
                if (weakSelf.model.isICloud) {
                    weakSelf.progressView.hidden = NO;
                }
                weakSelf.requestID = iCloudRequestId;
            } progressHandler:^(double progress, HXPhotoModel *model) {
                if (weakSelf.model != model) return;
                if (weakSelf.model.isICloud) {
                    weakSelf.progressView.hidden = NO;
                }
                weakSelf.progressView.progress = progress;
            } success:^(NSData *imageData, UIImageOrientation orientation, HXPhotoModel *model, NSDictionary *info) {
                if (weakSelf.model != model) return;
                [weakSelf downloadICloudAssetComplete];
                weakSelf.progressView.hidden = YES;
#if HasPhotonIMSDK
                YYImage *gifImage = [YYImage imageWithData:imageData];
                weakSelf.sdImageView.image = gifImage;
                weakSelf.gifImage = gifImage;
#else
                UIImage *gifImage = [UIImage hx_animatedGIFWithData:imageData];
                weakSelf.imageView.image = gifImage;
                weakSelf.gifImage = gifImage;
                if (gifImage.images.count == 0) {
                    weakSelf.gifFirstFrame = gifImage;
                }else {
                    weakSelf.gifFirstFrame = gifImage.images.firstObject;
                }
#endif
                weakSelf.model.tempImage = nil;
            } failed:^(NSDictionary *info, HXPhotoModel *model) {
                if (weakSelf.model != model) return;
                weakSelf.progressView.hidden = YES;
            }];
        }
    }
}
- (void)cancelImage {
    
    if (self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
        self.requestID = -1;
    }
    if (self.model.type == HXPhotoModelMediaTypePhoto) {
#if HasPhotonIMSDK
        [self.sdImageView yy_cancelCurrentImageRequest];
#elif HasYYKit
        [self.animatedImageView cancelCurrentImageRequest];
#elif HasSDWebImage
//        [self.imageView sd_cancelCurrentAnimationImagesLoad];
#endif
    }else if (self.model.type == HXPhotoModelMediaTypePhotoGif) {
        if (!self.stopCancel) {
#if HasPhotonIMSDK
            self.sdImageView.image = self.gifFirstFrame;
#else
            self.imageView.image = self.gifFirstFrame;
#endif
            self.gifImage = nil;
        }else {
            self.stopCancel = NO;
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
#if HasPhotonIMSDK
    if (!CGRectEqualToRect(self.sdImageView.frame, self.bounds)) {
        self.sdImageView.frame = self.bounds;
    }
#else
    if (!CGRectEqualToRect(self.imageView.frame, self.bounds)) {
        self.imageView.frame = self.bounds;
    }
#endif
    self.progressView.hx_centerX = self.hx_w / 2;
    self.progressView.hx_centerY = self.hx_h / 2;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (HXCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HXCircleProgressView alloc] init];
        _progressView.hidden = YES;
    }
    return _progressView;
}
#if HasSDWebImage
- (SDAnimatedImageView *)sdImageView {
    if (!_sdImageView) {
        _sdImageView = [[SDAnimatedImageView alloc] init];
        _sdImageView.clipsToBounds = YES;
        _sdImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _sdImageView;
}
#endif
@end
