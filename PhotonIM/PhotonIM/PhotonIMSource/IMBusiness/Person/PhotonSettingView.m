//
//  PhotonSettingView.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/16.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonSettingView.h"
#import "PhotonMacros.h"
@interface PhotonSettingView()
@property(nonatomic, strong,nullable)UIDatePicker *datePicker;
@property(nonatomic, strong,nullable)UITextField *sizeFiled;
@property(nonatomic, strong,nullable)UILabel *beginTimeLable;
@property(nonatomic, strong,nullable)UILabel *endTimeLable;
@property(nonatomic, strong,nullable)UISwitch *onlyServiceSwitch;
@end
@implementation PhotonSettingView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self  initContent];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self  initContent];
    }
    return self;
}

- (void)initContent{
    self.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.sizeFiled];
    [self addSubview:self.beginTimeLable];
    [self addSubview:self.endTimeLable];
    [_sizeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(0);
    }];
    
    [_beginTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.sizeFiled.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
    }];
    
    
    [_endTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(self);
        make.top.mas_equalTo(self.beginTimeLable.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
    }];
}
- (UITextField *)sizeFiled{
    if (!_sizeFiled) {
        _sizeFiled = [[UITextField alloc] init];
        _sizeFiled.keyboardType = UIKeyboardTypeNumberPad;
        _sizeFiled.placeholder = @"每页拉取消息的条数";
        _sizeFiled.backgroundColor = [UIColor grayColor];
    }
    return _sizeFiled;
}

- (void)showViewInSuperView:(UIView *)superView{
    self.alpha = 0;
    [superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (UILabel *)beginTimeLable{
    if (!_beginTimeLable) {
        _beginTimeLable = [[UILabel alloc] init];
        _beginTimeLable.backgroundColor = [UIColor grayColor];
        _beginTimeLable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBeginTimeAction)];
        [_beginTimeLable addGestureRecognizer:tapG];
    }
    return _beginTimeLable;
}

- (UILabel *)endTimeLable{
    if (!_endTimeLable) {
        _endTimeLable = [[UILabel alloc] init];
        _endTimeLable.backgroundColor = [UIColor grayColor];
        _endTimeLable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEndTimeAction)];
        [_endTimeLable addGestureRecognizer:tapG];
    }
    return _endTimeLable;
}

- (void)selectBeginTimeAction{
    self.datePicker.alpha = 0;
    [self addSubview:self.datePicker];
    [UIView animateWithDuration:0.3 animations:^{
          self.datePicker.alpha = 1.0;
    }];
}

- (void)selectEndTimeAction{
    
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        // 创建 UIDatePicker 对象
        _datePicker = [[UIDatePicker alloc] initWithFrame:self.bounds];
        // 设置背景颜色
        _datePicker.backgroundColor = [UIColor whiteColor];
        // 设置日期选择器模式:日期模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.timeZone = [NSTimeZone systemTimeZone];
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
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    NSLog(@"%@",@(timeStamp));
}


@end
