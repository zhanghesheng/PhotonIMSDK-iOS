//
//  PhotonIMTimer.h
//  PhotonIMSDK
//
//  Created by Bruce on 2019/7/9.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotonIMTimer : NSObject
+ (id) initWithInterval:(float)aInterval
                 repeat:(BOOL)aRepeat
                handler:(dispatch_block_t _Nullable)handler;
+ (id) initWithInterval:(float)aInterval
                  delay:(float)delay
                 repeat:(BOOL)aRepeat
                handler:(dispatch_block_t _Nullable)handler;
+ (id) initWithInterval:(float)aInterval
                  delay:(float)delay
                 repeat:(BOOL)aRepeat
            targetQueue:(dispatch_queue_t)queue
                handler:(dispatch_block_t _Nullable)handler;

- (void)setDurationTime:(NSTimeInterval)duration;
- (void)setDelayTime:(NSTimeInterval)delay;
- (void)delay:(dispatch_block_t _Nullable)handler;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
