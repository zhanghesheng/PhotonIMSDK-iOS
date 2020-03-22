//
//  PhotonCircleProgressView.m
//  PhotonIM
//
//  Created by Bruce on 2020/3/19.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonCircleProgressView.h"
@interface PhotonCircleProgressView ()
{
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *frontFillLayer;       //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
}
@end
@implementation PhotonCircleProgressView

@synthesize progressValue = _progressValue;
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
    }
    return self;
    
}

//初始化创建图层
- (void)setUp
{
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;

    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = nil;

    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:frontFillLayer];
    
    //设置颜色
    frontFillLayer.strokeColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:0/255.0 alpha:1.0].CGColor;
    backGroundLayer.strokeColor = [UIColor colorWithRed:190/255.0 green:255/255.0 blue:167/255.0 alpha:1.0].CGColor;
  
}

#pragma mark -子控件约束
-(void)layoutSubviews {

    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    backGroundLayer.frame = self.bounds;


    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:0 endAngle:M_PI*2
                                                       clockwise:YES];
    backGroundLayer.path = backGroundBezierPath.CGPath;
    
    
    frontFillLayer.frame = self.bounds;

    //设置线宽
    frontFillLayer.lineWidth = 2.0;
    backGroundLayer.lineWidth = 2.0;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    
     progressValue = MAX( MIN(progressValue, 1.0), 0.0);
     _progressValue = progressValue;
     if (progressValue == 1) {
        
        if ([self.delegate respondsToSelector:@selector(progressViewOver:)]) {
            
            [self.delegate progressViewOver:self];
        }
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:-0.25*2*M_PI endAngle:(2*M_PI)*progressValue - 0.25*2*M_PI clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
}
- (CGFloat)progressValue
{
    return _progressValue;
}

@end
