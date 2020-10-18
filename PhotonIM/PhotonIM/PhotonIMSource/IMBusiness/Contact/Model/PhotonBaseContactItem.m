//
//  PhotonBaseContactItem.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonBaseContactItem.h"

@implementation PhotonBaseContactItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        _ration = 1;
    }
    return self;
}
- (CGFloat)itemHeight{
    return 70.0f;
}
@end
