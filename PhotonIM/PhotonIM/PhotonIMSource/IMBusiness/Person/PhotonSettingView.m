//
//  PhotonSettingView.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/16.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonSettingView.h"
#import "PhotonMacros.h"
typedef NS_ENUM(NSInteger,SelectDateType) {
    SelectDateTypeNO,
    SelectDateTypeStart,
    SelectDateTypeEnd,
};
@interface PhotonSettingView()
@property(nonatomic, strong,nullable)UIDatePicker *datePicker;
@property(nonatomic, strong,nullable)UITextField *sizeFiled;
@property(nonatomic, strong,nullable)UILabel *beginTimeLable;
@property(nonatomic, strong,nullable)UILabel *endTimeLable;
@property(nonatomic, strong,nullable)UISwitch *onlyServiceSwitch;

@property(nonatomic, strong, nullable)UIButton *selectBtn;

@property(nonatomic, assign)NSTimeInterval  selectStartDate;
@property(nonatomic, assign)NSTimeInterval  selectEndDate;
@property(nonatomic, assign)SelectDateType  selectType;
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
    self.selectType = SelectDateTypeNO;
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
        _beginTimeLable.text = @"dsadsa";
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
    self.selectType = SelectDateTypeStart;
    self.datePicker.alpha = 0;
    self.selectBtn.alpha = 0;
    [self addSubview:self.datePicker];
    [self addSubview:self.selectBtn];
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0;
        self.selectBtn.alpha = 1.0;
    }];
}

- (void)selectEndTimeAction{
    self.selectType = SelectDateTypeEnd;
    self.datePicker.alpha = 0;
    self.selectBtn.alpha = 0;
    [self addSubview:self.datePicker];
    [self addSubview:self.selectBtn];
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 1.0;
        self.selectBtn.alpha = 1.0;
    }];
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.tag = 1001;
        [_selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectBtn setBackgroundColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
        CGSize btnSize = CGSizeMake(50, 30);
        CGPoint btnPoint = CGPointMake((self.frame.size.width - 50)/2.0,self.frame.size.height - 30);
        CGRect btnFrame =CGRectZero;
        btnFrame.size = btnSize;
        btnFrame.origin = btnPoint;
        _selectBtn.frame = btnFrame;
    }
    return _selectBtn;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        // 创建 UIDatePicker 对象
        CGRect frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40);
        _datePicker = [[UIDatePicker alloc] initWithFrame:frame];
        // 设置背景颜色
        _datePicker.backgroundColor = [UIColor whiteColor];
        // 设置日期选择器模式:日期模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.timeZone = [NSTimeZone systemTimeZone];
        // 设置可供选择的最小时间：昨天
        NSTimeInterval time = 24 * 60 * 60 * 30; // 24H 的时间戳值
        _datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:- time];
        // 设置可供选择的最大时间：明天
        _datePicker.maximumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:time];
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    NSTimeInterval timeStamp = [date timeIntervalSince1970] * 1000;
   
    if (self.selectType == SelectDateTypeStart) {
        self.selectStartDate = timeStamp;
        self.beginTimeLable.text = currentDateString;
    }else if (self.selectType == SelectDateTypeEnd){
        self.selectEndDate = timeStamp;
        self.endTimeLable.text = currentDateString;
    }
}

- (void)okAction:(id)sender{
    self.selectType = SelectDateTypeEnd;
    self.selectEndDate = 0;
    self.selectStartDate = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.alpha = 0.0;
        [self.datePicker removeFromSuperview];
        self.selectBtn.alpha = 0.0;
        [self.selectBtn removeFromSuperview];
    }];
}


@end
