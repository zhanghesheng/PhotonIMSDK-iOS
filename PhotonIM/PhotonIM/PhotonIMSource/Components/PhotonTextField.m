//
//  PhotonTextField.m
//  PhotonIM
//
//  Created by Bruce on 2020/10/20.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonTextField.h"

@implementation PhotonTextField
//未编辑状态下的起始位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}
// 编辑状态下的起始位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}
//placeholder起始位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}

@end
