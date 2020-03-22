//
//  PhotonCircleProgressView.h
//  PhotonIM
//
//  Created by Bruce on 2020/3/19.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PhotonCircleProgressView;

@protocol PhotonCircleProgressViewDelegate <NSObject>

-(void)progressViewOver:(PhotonCircleProgressView *)progressView;

@end
@interface PhotonCircleProgressView : UIView
//进度值0-1.0之间
@property (nonatomic,assign)CGFloat progressValue;


//内部label文字
@property(nonatomic,strong)NSString *contentText;

//value等于1的时候的代理
@property(nonatomic,weak)id<PhotonCircleProgressViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
