//
//  PhotonIMDispatchSource.m
//  PhotonIM
//
//  Created by Bruce on 2019/11/26.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonIMDispatchSource.h"
@interface PhotonIMDispatchSource()
@property (atomic,strong)dispatch_source_t source;
@property (atomic,strong)dispatch_queue_t  eventQueue;
@property (atomic,copy)PhotonIMDispatchSourceEventBlock eventBlack;
@property (atomic,strong)id  userInfo;
@end
@implementation PhotonIMDispatchSource
- (instancetype)initWithEventQueue:(dispatch_queue_t)eventQueue eventBlack:(PhotonIMDispatchSourceEventBlock)envent{
    self = [super init];
    if (self) {
        if (!eventQueue) {
            _eventQueue = dispatch_get_main_queue();
        }else{
            _eventQueue = eventQueue;
        }
        _eventBlack = [envent copy];
        [self createDispatchSource];
    }
    return self;
}
- (void)createDispatchSource{
    if (!_source) {
        __weak typeof(self)weakSelf = self;
        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, self.eventQueue);//由于此类用于用户事件对数据的频繁更新从而对UI的更新操作要在mainQueue上
        dispatch_source_set_event_handler(self.source, ^{
            if (weakSelf.eventBlack) {
                weakSelf.eventBlack(weakSelf.userInfo);
            }
        });
        dispatch_resume(_source);
    }
    
}
- (void)addEventSource:(nullable id)userInfo{
    _userInfo = userInfo;
    __weak typeof(self)weakSelf = self;
    dispatch_apply(1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index){
           if (weakSelf.source) {
               dispatch_source_merge_data(weakSelf.source, 1);
           }
       });
}

- (void)clearDelegateAndCancel
{
    if (_source) {
        dispatch_source_cancel(_source);
        _source = nil;
    }
}

- (void)dealloc
{
    [self clearDelegateAndCancel];
}

@end