//
//  PhotonImageMessageChatItem.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/22.
//  Copyright © 2019 Bruce. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PhotonChatImageMessageItem.h"
@implementation PhotonChatImageMessageItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _whRatio = 0;
    }
    return self;
}
- (CGSize)contentSize{
    CGFloat scale = 1.0 / self.whRatio;
    if (self.whRatio == 0 || isinf(scale)) {
        scale = [UIScreen mainScreen].scale;
    }
    CGSize imageSize = CGSizeZero;
    CGFloat defaultWith = PhotoScreenWidth * 0.3;
    CGFloat realHeight = defaultWith * scale;
    imageSize = CGSizeMake(defaultWith, realHeight);
    return imageSize;
}
- (CGFloat)itemHeight{
    return [super itemHeight];
}

@end
