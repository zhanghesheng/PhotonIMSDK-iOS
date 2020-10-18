//
//  PhotonAccountCell.h
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@class PhotonAccountItem;
@protocol PhotonAccountCellDelegate <NSObject>
@optional
- (void)loginAction:(PhotonAccountItem *)item;
- (void)registerAction:(PhotonAccountItem *)item;
- (void)tipToRegister;
- (void)tipToLogin;
@end
@interface PhotonAccountCell : PhotonTableViewCell
@property (nonatomic,strong,readonly, nonnull)UIButton      *accountBtn;
@property (nonatomic,weak, nullable) id<PhotonAccountCellDelegate> delegate;
- (void)resignFirst;
@end

NS_ASSUME_NONNULL_END
