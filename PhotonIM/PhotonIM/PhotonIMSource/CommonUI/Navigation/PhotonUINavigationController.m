//
//  PhotonUINavigationController.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/5.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonUINavigationController.h"
#import "UIColor+PhotonExtensions.h"
@interface PhotonUINavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation PhotonUINavigationController
+ (void)initialize {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBarTintColor:[UIColor whiteColor]];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [navigationBar setShadowImage:[self imageWithColor:[UIColor colorWithHex:0xB7B7B7] size:CGSizeMake(PhotoScreenWidth, 0.5)]];
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0]};
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count >= 1) {
        
        UIImage *image = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        BOOL havePop = [viewController respondsToSelector:@selector(pop)];
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:havePop?viewController:self action:@selector(pop)];
        viewController.navigationItem.leftBarButtonItem = back;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pop {
    [self popViewControllerAnimated:YES];
}

@end
