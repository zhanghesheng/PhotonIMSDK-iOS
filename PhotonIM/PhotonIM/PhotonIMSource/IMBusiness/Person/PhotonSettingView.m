//
//  PhotonSettingView.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/16.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonSettingView.h"

@interface PhotonSettingView()
@property(nonatomic, strong,nullable)UIDatePicker *datePicker;
@end
@implementation PhotonSettingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initContent{
    
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        // 创建 UIDatePicker 对象
        _datePicker = [[UIDatePicker alloc] init];
        // 设置背景颜色
        _datePicker.backgroundColor = [UIColor whiteColor];
        // 设置日期选择器模式:日期模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置可供选择的最小时间：昨天
        NSTimeInterval time = 24 * 60 * 60; // 24H 的时间戳值
        _datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:- time];
        // 设置可供选择的最大时间：明天
        _datePicker.maximumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
        // 添加 Target-Action
        [_datePicker addTarget:self
                        action:@selector(datePickerValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (void)datePickerValueChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    NSLog(@"%@",@(timeStamp));
}


@end
