//
//  MMLiveService.h
//  Pods
//
//  Created by momo783 on 2017/5/31.
//
//

#ifndef MMLiveService_h
#define MMLiveService_h
#import "MDAppBus.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

// CameraOutputAspectRatio
typedef NS_ENUM(NSUInteger, MMLServicePublisherCameraOutputAspectRatio) {
    MMLServicePublisherCameraOutputAspectRatio9x16,
    MMLServicePublisherCameraOutputAspectRatio1x1,
    MMLServicePublisherCameraOutputAspectRatio3x4,
};


typedef NS_ENUM(NSInteger, MMLServiceVideoCaptureQuality) {
    MMLServiceVideoCaptureQualityLow = 0,
    MMLServiceVideoCaptureQualityMedium = 1,
    MMLServiceVideoCaptureQualityHigh = 2,
};

typedef NS_ENUM(NSInteger, MMLServiceMediaCaptureDevicePosition) {
    MMLServiceMediaCaptureDevicePositionBack = 0,
    MMLServiceMediaCaptureDevicePositionFront = 1,
};

typedef NS_ENUM(NSInteger, MMLServicePublisherIdentify) {
    MMLServicePublisherIdentifyNone = 0,
    MMLServicePublisherIdentifyMomo = 1,
    MMLServicePublisherIdentifyWerwolf = 2,
    MMLServicePublisherIdentifyFriendVideo = 3, //好友快聊
    MMLServicePublisherIdentifyExternal = 4     //业务方(狼人杀， 快聊， 派单等)
};

typedef NS_ENUM(NSInteger, MMLServiceUserNetworkQuality) {
    MMLServiceUserNetwork_Quality_Unknown = 0,
    MMLServiceUserNetwork_Quality_Excellent = 1,
    MMLServiceUserNetwork_Quality_Good = 2,
    MMLServiceUserNetwork_Quality_Poor = 3,
    MMLServiceUserNetwork_Quality_Bad = 4,
    MMLServiceUserNetwork_Quality_VBad = 5,
    MMLServiceUserNetwork_Quality_Down = 6,
};

typedef enum : NSInteger {
    MMLServiceDefaultSdk = 0,
    MMLServiceAgoraSdk = 1,
    MMLServiceWeiLaSdk = 2,
} MMLServiceChooseAudioSdk;

//本地message逆序加
typedef enum {
    MMLiveGroupMessageStyle_None            = 0,
    MMLiveGroupMessageStyle_Text            = 1,  // 聊聊
    MMLiveGroupMessageStyle_Gift            = 2,  // 礼物消息
    MMLiveGroupMessageStyle_Broadcast       = 3,  // 弹幕消息
    MMLiveGroupMessageStyle_System          = 4,  // 2.10下掉
    MMLiveGroupMessageStyle_Rank            = 5,  // 旧的排行版变化，被废弃
    MMLiveGroupMessageStyle_EM              = 6,  // 弹幕表情2.6下掉
    MMLiveGroupMessageStyle_CustomerGift    = 7,  // 用户间礼物2.6下掉
    MMLiveGroupMessageStyle_Star            = 8,  // 星光值贡献
    MMLiveGroupMessageStyle_Enter           = 9,  // 聊聊入场
    MMLiveGroupMessageStyle_Common          = 10, // 代发统一2.8去掉
    MMLiveGroupMessageStyle_Extra           = 11, // 聊聊扩展
    MMLiveGroupMessageStyle_SysBroadcast    = 12, // 系统弹幕
    MMLiveGroupMessageStyle_PRank           = 97, // 排行榜变化
    MMLiveGroupMessageStyle_EnterShow       = 98, // 入场秀
    
} MMLiveGroupMessageStyle;

@protocol MMLServicePublisherCameraConfiguration <MDUnit>

@property (nonatomic,readonly) CGRect cropRegion;
@property (nonatomic,readonly) CGSize videoFrameSize;
@property (nonatomic,copy,readonly) NSString *captureSessionPreset;
@property (nonatomic,readonly) AVCaptureDevicePosition captureDevicePosition;

@end

@class MLFilterDescriptor;
@class FDKDecoration;
@protocol MMLiveServiceSDKFDKDecoration;
@protocol MMLiveServiceSDKFilter;

@protocol MMLiveServiceLiveSDKBeautySettings;
@protocol MMLServiceCameraSource <MDUnit>

@property (nonatomic) CGRect cropRegion;
@property (nonatomic) CGFloat outputScale;
@property (nonatomic) NSInteger videoCaptureDeviceFrameRate;
@property (nonatomic) id<MMLiveServiceLiveSDKBeautySettings > beautySettings;
@property (nonatomic, strong) MLFilterDescriptor *filterDescriptor;
- (void)rotateCamera;

- (void)startCapturing;
- (void)stopCapturing;

- (void)addDataConsumer:(id<NSObject>)dataConsumer;
- (void)removeDataConsumer:(id<NSObject>)dataConsumer;

- (void)addDecoration:(id <MMLiveServiceSDKFDKDecoration>)decoration withIdentifier:(NSString *)identifier;

- (void)removeDecorationWithIdentifier:(NSString *)identifier;

- (NSArray<NSString *> *)decorationIdentifiers;
@end

@protocol MMLServicePublisherOptions <MDUnit>

@property (nonatomic) MMLServicePublisherIdentify publisherIdentify;
@property (nonatomic, copy) NSString *serviceType;

@end

@protocol MMLServicePublisherDelegate;
@protocol MMLServiceConferenceVideoDelegate;
@protocol MMLServicePublisher <MDUnit>


@property (nonatomic, weak) id<MMLServicePublisherDelegate> delegate;
@property (nonatomic, weak) id<MMLServiceConferenceVideoDelegate> confDelegate;
@property (nonatomic, assign) BOOL isAudioRecording;
@property (nonatomic, assign) BOOL enableAgoraReconnect;
@property (nonatomic, assign) BOOL enableConferenceReconnect;
@property (nonatomic, assign) BOOL enableReportAudioVolume;
@property (nonatomic, assign) BOOL enableConferenceVideoFrame;
@property (nonatomic, assign) BOOL isGetConferenceRecordAudio;
@property (nonatomic, assign) BOOL useAudioScenario;

- (void)releasePublisher;

- (void)setPublisherOptions:(NSDictionary *)options;

- (void)startPublishingWithOptions:(id <MMLServicePublisherOptions>)options;

- (void)setEncryptionSecret:(NSString *)secret withMode:(NSString *)encryptionMode;
- (void)setAgoraSdkAppID:(NSString *)appID withChannelKey:(NSString *)channelKey;
- (void)setSdkAppID:(NSString *)appID withChannelKey:(NSString *)channelKey;
- (void)renewChannelKey:(NSString *)channelKey;

- (void)setClientAsAudience:(BOOL)enable;
// change client role, if YES as broadcast ,or NO as audience
- (void)setClientRoleAsBroadcast:(BOOL)enable;

// if YES for game, or NO for live
- (void)enableCommMode:(BOOL)enable;

// if YES mute, or NO unmute
- (void)muteLocalAudio:(BOOL)mute;
- (void)muteLocalVideo:(BOOL)mute;
- (void)muteAllRemoteAudio:(BOOL)mute;
- (void)muteAllRemoteVideo:(BOOL)mute;
- (void)muteRemoteAudioStream:(NSUInteger)uid mute:(BOOL)mute;
- (void)muteRemoteVideoStream:(NSUInteger)uid mute:(BOOL)mute;

- (void)playMusicWithUrl:(NSString *)url;
- (void)playMusicWithUrl:(NSString *)url loopback:(BOOL)loopback;
- (void)playMusicWithUrl:(NSString *)url loopback:(BOOL)loopback repeat:(NSInteger)repeat;
- (void)stopMusic;
- (void)pauseMusic;
- (void)resumeMusic;

- (void)playEffectWithId:(int)effectId url:(NSString *)url loop:(BOOL)loop pitch:(double)pitch pan:(double)pan gain:(double)gain;
- (void)playEffectWithId:(int)effectId url:(NSString *)url loop:(BOOL)loop;
- (void)stopEffectWithId:(int)effectId;
- (void)stopAllEffect;
//音效的音量取值范围为[0.0, 1.0],默认值为1.0
- (void)setEffectVolumeWithId:(int)effectId withVolume:(double)volume;
- (void)setEffectsVolume:(double)volume;

- (void)setMicVolume:(float)micVolume;
- (void)setMusicVolume:(float)musicVolume;

- (void)enableSoftAEC:(BOOL)enable;

//设置连线播放是外放还是听筒，返回0成功否则失败
- (int)setConferencePlaybackSpeakerphone:(BOOL)enable;

@end

@protocol MMLServiceConferenceVideoDelegate <NSObject>

- (void)publisher:(id <MMLServicePublisher>)publisher onRemoteConferenceVideoFrame:(CMSampleBufferRef)sampleBuffer userId:(uint32_t)uid;
- (void)publisher:(id <MMLServicePublisher>)publisher onConferenceRecordAudioPacket:(NSData *)data channel:(int)channel sampleRate:(int)sampleRate;

@end;

@protocol MMLServicePublisherDelegate <NSObject>

// 推流成功
- (void)publisher:(id <MMLServicePublisher>)publisher hostDidJoinChannel:(NSString *)channel;

// 推流成功的扩展方法
- (void)publisher:(id <MMLServicePublisher>)publisher hostDidJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSUInteger)elapsed;

// 推流成功的扩展方法
- (void)publisher:(id <MMLServicePublisher>)publisher didRemoteJoinChannel:(NSString *)channel withUid:(NSUInteger)uid;

// 退出成功
- (void)publisherDidLeaveChannel:(id <MMLServicePublisher>)publisher;

// channelkey无效
- (void)publisherRequestChannelKey:(id <MMLServicePublisher>)publisher;

// 推流器推流失败
- (void)publisher:(id <MMLServicePublisher>)publisher streamPublishingFailedWithError:(NSError*)error;

// 推流器开始推流
- (void)publisherDidStartPublishing:(id <MMLServicePublisher>)publisher error:(NSError *)error;

// 推流器停止推流
- (void)publisherDidStopPublishing:(id <MMLServicePublisher>)publisher error:(NSError*)error;

// 视频流断开
- (void)publisher:(id <MMLServicePublisher>)publisher didOfflineOfUid:(NSString *)uid;

// 视频流断开拓展方法
- (void)publisher:(id <MMLServicePublisher>)publisher didOfflineOfUid:(NSString *)uid reason:(NSUInteger)reason;

// 收到一个视频流
- (void)publisher:(id <MMLServicePublisher>)publisher didReceivedVideoForRemoteId:(NSString *)uid remoteView:(UIView *)remoteView;

- (void)musicPlayerDidfailed:(id <MMLServicePublisher>)publisher error:(NSError*)error;

- (void)musicPlayerDidCompleted:(id <MMLServicePublisher>)publisher error:(NSError*)error;

- (void)effectPlayerDidfailed:(id <MMLServicePublisher>)publisher effectId:(int)effectId error:(NSError*)error;

- (void)effectPlayerDidCompleted:(id <MMLServicePublisher>)publisher effectId:(int)effectId error:(NSError*)error;

- (void)publisher:(id <MMLServicePublisher>)publisher didRemoteAudioMuted:(BOOL)muted remoteUid:(NSUInteger)uid;

- (void)publisher:(id <MMLServicePublisher>)publisher didRemoteVideoMuted:(BOOL)muted remoteUid:(NSUInteger)uid;

- (void)publisher:(id <MMLServicePublisher>)publisher setClientRoleAsBroadcast:(BOOL)enable code:(int)code;

- (void)publisher:(id <MMLServicePublisher>)publisher audioQualityOfUid:(NSUInteger)uid quality:(MMLServiceUserNetworkQuality)quality delay:(NSUInteger)delay lost:(NSUInteger)lost;

- (void)publisher:(id <MMLServicePublisher>)publisher networkQuality:(NSUInteger)uid txQuality:(MMLServiceUserNetworkQuality)txQuality rxQuality:(MMLServiceUserNetworkQuality)rxQuality;

@end

@protocol MMLiveServiceLiveSDK <MDUnit>
@property (nonatomic, assign) BOOL isBroadcasting;

// 开始直播（开始流程）
- (void)startBroadcast;

// 关闭直播，不唤起UI
- (void)stopBroadcast;

// 房间直播信息（含结束按钮、结束流程）
- (void)showRoomLiveInfo;

//  直播间的聊聊生成器
- (UIView *)liveMessageChatView;

// 释放init方法的代理
- (void)dismissDelegate;
//大额礼物托盘动画，show: YES 显示大额礼物，NO 不显示大额礼物动画
//referenceView
- (UIView *)costlyGiftTrayViewWithFrame:(CGRect)frame rocketAnimation:(BOOL)show referenceView:(UIView *)referenceView;

// 埋点
- (void)uploadLogWithType:(NSString *)type info:(NSDictionary *)info;
@end

@class FDKDecorationItem,FDKFacialMask,FDKFacialDistortion,FDKBeautySettings,FDKTriggerTip,FDKFilterEffect;
NS_ASSUME_NONNULL_BEGIN
@protocol MMLiveServiceSDKFDKDecoration <MDUnit>

@property (nonatomic) NSInteger preferredFrameRate;

@property (nonatomic) NSInteger preferredFacialLandmarksCount;

@property (nonatomic,copy,nullable) NSArray<FDKDecorationItem *> *items;

@property (nonatomic,copy,nullable) NSArray<FDKFacialDistortion *> *facialDistortions;

@property (nonatomic,copy,nullable) NSArray<FDKFacialMask *> *facialMasks;

@property (nonatomic,copy,nullable) NSArray<FDKFilterEffect *> *filterEffects;

@property (nonatomic,copy,nullable) FDKTriggerTip *triggerTip;

@property (nonatomic,copy,nullable) FDKBeautySettings *beautySettings;

@property (nonatomic) BOOL treatAsDecorationGiftPack;

+ (nullable instancetype)decorationWithContentsOfURL:(NSURL *)URL;

@property (nonatomic,readonly) NSArray<NSNumber *> *itemTriggerTypes;
@property (nonatomic,readonly) NSArray<NSString *> *itemObjectTriggerTypes;

@property (nonatomic,readonly) BOOL containsAudioVisualizationItem;

@property (nonatomic,readonly) BOOL requiresImageSegmentation;

@property (nonatomic,copy) NSDictionary *additionalInfo;
@end


@protocol MMLiveServiceLiveSDKBeautySettings <MDUnit>

@property (nonatomic) float skinSmoothingAmount;

@property (nonatomic) float eyesEnhancementAmount;

@property (nonatomic) float faceThinningAmount;

@property (nonatomic) float skinWhitenAmount;


@end

@protocol MMLiveServiceSDKFilter <MDUnit>

@property (nonatomic, strong) UIImage *preivewImage;
@property (nonatomic, strong) MLFilterDescriptor  *filter;
@property (nonatomic, copy) NSString  *name;

@end

//@protocol MMShowProductInfo;

@protocol MMLiveGroupMessage <NSObject>

@property (nonatomic, strong) NSDictionary *body;//productid,  img 礼物icon, buyTimes连送次数
@property (nonatomic, strong) NSString *noticeNick;//用户名称
@property (nonatomic, strong) NSString *roomId;//房间ID
@property (nonatomic, assign) MMLiveGroupMessageStyle contentStyle;
@property (nonatomic, strong) NSString *imgUrl;
//@property (nonatomic, strong) id<MMShowProductInfo> pi;//礼物资料
@property (nonatomic, strong) NSString *text;//消息文本
@property (nonatomic, strong) NSString *targetId; //收到礼物的对象
@property(nonatomic, readwrite) BOOL hasAmbientEffect;//是否有连送效果氛围灯
@property(nonatomic, readwrite) BOOL hasBombEffect;//控制小额礼物是否有连送效果
@property(nonatomic, readwrite) NSInteger ambientEffectLevel;//连送效果氛围灯类型，有几种不同的效果

@end

//@protocol MMShowProductInfo <NSObject>
//
//
//
//@end

@protocol MMLiveServiceLiveSDKDelegate <NSObject>

- (void)liveSDKHelperClickStartBroadcast; // 点击开始直播

- (void)liveSDKHelperStartBroadcastDidSuccess:(__nullable id)info; // 开启直播成功

- (void)liveSDKHelperStartBroadcastDidFail:(NSError *)error; // 开启直播失败

- (void)liveSDKHelperEndBroadcastDidSuccess:(__nullable id)info; // 关闭直播成功

- (void)liveSDKHelperEndBroadcastDidFail:(NSError *)error; // 关闭直播失败

- (void)liveSDKHelperBeForcedEndBroadcastWithInfo:(id)info; // 被IM强行踢出，退出录屏和推流

- (void)liveSDKHelperDidReceiveGiftMessage:(id)giftMessage; // MMLiveGroupMessage

@end


typedef void  (^MGRecordVideoCompletionBlock)(void);
@protocol MGServiceScreenRecorderDelegate;
@protocol MGServiceScreenRecorder <MDUnit>

@property (nonatomic,weak)  id<MGServiceScreenRecorderDelegate> delegate;
-(BOOL)startRecording;
-(void)stopRecordingWithCompletion:(MGRecordVideoCompletionBlock)completionBlock;


@end

@protocol MGServiceScreenRecorderDelegate <NSObject>
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder screenSnapshot:(UIImage *)snapshot;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder recordCurrentTimestamp:(CGFloat)timestamp;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder recordTotalSize:(NSInteger)size recordTotalDuatuion:(CGFloat)duration recordSnapshot:(UIImage *)image;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder drawContextInactive:(NSURL *)videoFilePath;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder didFailToWriteBufferToVideoWriter:(AVAssetWriter *)assetWriter withError:(NSError *)error;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder didFailToRemoveFileAtPath:(NSURL *)videoFilePath withError:(NSError *)error;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder didFailToSaveVideoToCameraRoll:(NSURL *)videoFilePath withError:(NSError *)error;
- (void)screenRecorder:(id<MGServiceScreenRecorder>)screenRecorder didFailToSaveImageToCameraRoll:(UIImage *)image withError:(NSError *)error;

@end


@protocol MMLiveService <MDService>

/**
 *  创建实现 MLServicePublisherCameraConfiguration 协议的对象
 */
- (id <MMLServicePublisherCameraConfiguration>)configurationWithCaptureQuality:(MMLServiceVideoCaptureQuality)quality
                                                                devicePosition:(MMLServiceMediaCaptureDevicePosition)position
                                                          preferredAspectRatio:(MMLServicePublisherCameraOutputAspectRatio)preferredAspectRatio;

/**
 *  创建CameraSource
 */
- (id <MMLServiceCameraSource>)cameraSourceWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;

/**
 *  Publisher 配置
 */
- (id <MMLServicePublisherOptions>)publisherOptionsWithRoomID:(NSString *)roomID userID:(NSString *)userID isRoomOwner:(BOOL)isRoomOwner dictionary:(NSDictionary *)dictionary;

/**
 *  Publisher 初始化
 */
- (id <MMLServicePublisher>)publisherWithContentView:(UIView *)view inputVideoSize:(CGSize)inputVideoSize isHost:(BOOL)isHost isAgora:(NSInteger)isAgora;


// 创建一个 LiveSDKHelper ，用于狼人杀等游戏的录屏
- (id <MMLiveServiceLiveSDK>)liveSDKHelperWithDelegate:(UIViewController <MMLiveServiceLiveSDKDelegate>*)delegate;

// 美颜信息
- (id <MMLiveServiceLiveSDKBeautySettings>)liveSDKHelperBeautySettings;

// 面具接口
- (id <MMLiveServiceSDKFDKDecoration>)liveSDKHelperFDKDecorationWithLocalUrl:(NSURL *)localUrl;

- (NSArray <MMLiveServiceSDKFilter>*)liveSDKHelperFilters;

- (id <MGServiceScreenRecorder>)screenRecorder;

@end



NS_ASSUME_NONNULL_END
#endif /* MMLiveService_h */
