//
//  PhotonAccountCell.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonAccountCell.h"
#import "PhotonAccountItem.h"
#import "PhotonTextField.h"
@interface PhotonAccountCell()
@property (nonatomic,strong, nonnull)PhotonTextField   *nickTextField;
@property (nonatomic,strong, nonnull)PhotonTextField   *pswTextField;
@property (nonatomic,strong, nonnull)UIButton      *accountBtn;
@property (nonatomic,strong, nonnull)UIButton      *tipBtn;
@end

@implementation PhotonAccountCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineLayer.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.nickTextField];
        [self.contentView addSubview:self.pswTextField];
        [self.contentView addSubview:self.accountBtn];
        [self.contentView addSubview:self.tipBtn];
    }
    return self;
}

- (void)accountAction:(id)sender{
    PhotonAccountItem *item = (PhotonAccountItem *)self.item;
    NSString *userid = self.nickTextField.text;
    NSString *pwd = self.pswTextField.text;
    if ([pwd isNotEmpty] && [userid isNotEmpty]) {
        item.userID = userid;
        item.password = pwd;
        if (item.accountType == PhotonAccountTypeRegister) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(registerAction:)]) {
                [self.delegate registerAction:item];
            }
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(loginAction:)]) {
                [self.delegate loginAction:item];
            }
        }
    }
}
- (void)tipAction:(id)sender{
    PhotonAccountItem *item = (PhotonAccountItem *)self.item;
    if (item.accountType == PhotonAccountTypeLogin && [self.delegate respondsToSelector:@selector(tipToRegister)]) {
        [self.delegate tipToRegister];
    }else if([self.delegate respondsToSelector:@selector(tipToLogin)]){
        [self.delegate tipToLogin];
    }
}

- (void)hiddenPsw:(id)sender{
    self.pswTextField.secureTextEntry = !self.pswTextField.secureTextEntry;
    if (self.pswTextField.secureTextEntry) {
        [(UIButton *)self.pswTextField.rightView setImage:[UIImage imageNamed:@"hidden_psw"] forState:UIControlStateNormal];
    }else{
         [(UIButton *)self.pswTextField.rightView setImage:[UIImage imageNamed:@"psw"] forState:UIControlStateNormal];
    }
}
#pragma mark -------- Getter ---------
- (PhotonTextField *)nickTextField{
    if (!_nickTextField) {
        _nickTextField = [[PhotonTextField alloc] init];
        _nickTextField.placeholder = @"请输入登录账号";
        _nickTextField.clipsToBounds = YES;
        _nickTextField.layer.cornerRadius = 4.5;
        _nickTextField.backgroundColor = [UIColor colorWithHex:0xF9F9F9];
        _nickTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    }
    return _nickTextField;
}

- (PhotonTextField *)pswTextField{
    if (!_pswTextField) {
        _pswTextField = [[PhotonTextField alloc] init];
        _pswTextField.placeholder = @"请输入登录密码";
        _pswTextField.clipsToBounds = YES;
        _pswTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _pswTextField.layer.cornerRadius = 4.5;
        _pswTextField.backgroundColor = [UIColor colorWithHex:0xF9F9F9];
        _pswTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _pswTextField.secureTextEntry = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 56, 26);
        btn.contentMode = UIViewContentModeCenter;
        [btn setImage:[UIImage imageNamed:@"hidden_psw"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 6);
        [btn addTarget:self action:@selector(hiddenPsw:) forControlEvents:UIControlEventTouchUpInside];
        [_pswTextField setRightView:btn];
        _pswTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return _pswTextField;
}

- (UIButton *)accountBtn{
    if (!_accountBtn) {
        _accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _accountBtn.clipsToBounds = YES;
        _accountBtn.layer.cornerRadius = 5.0;
        _accountBtn.backgroundColor = [UIColor blueColor];
        _accountBtn.titleLabel.textColor = [UIColor whiteColor];
        _accountBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_accountBtn addTarget:self action:@selector(accountAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountBtn;
}

- (UIButton *)tipBtn{
    if (!_tipBtn) {
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tipBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_tipBtn setTitleColor:[UIColor colorWithHex:0x1F90FF] forState:UIControlStateNormal];
        _tipBtn.backgroundColor = self.contentView.backgroundColor;
        _tipBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_tipBtn addTarget:self action:@selector(tipAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setObject:(id)object{
    [super setObject:object];
    PhotonAccountItem *item = (PhotonAccountItem *)object;
    if (item.accountType == PhotonAccountTypeRegister) {
        [self.accountBtn setImage:[UIImage imageWithColor:[UIColor colorWithHex:0xCECECE]] forState:UIControlStateNormal];
    }else{
        [self.accountBtn setImage:[UIImage imageWithColor:[UIColor colorWithHex:0x1F90FF]] forState:UIControlStateNormal];
    }
    if (item.accountType == PhotonAccountTypeRegister) {
        self.pswTextField.placeholder = @"请输入注册密码";
        self.pswTextField.placeholder = @"请输入注册密码";
        [self.accountBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.tipBtn setTitle:@"已有账号登录" forState:UIControlStateNormal];
    }else{
        self.pswTextField.placeholder = @"请输入登录密码";
        self.pswTextField.placeholder = @"请输入登录密码";
        [self.accountBtn setTitle: @"登录" forState:UIControlStateNormal];
        [self.tipBtn setTitle:@"新账号注册" forState:UIControlStateNormal];
    }
    
    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(50);
        make.left.mas_equalTo(self.contentView).mas_offset(35);
        make.right.mas_equalTo(self.contentView).mas_offset(-35);
        make.height.mas_equalTo(49);
    }];
    
    [self.pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickTextField.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.contentView).mas_offset(35);
        make.right.mas_equalTo(self.contentView).mas_offset(-35);
        make.height.mas_equalTo(49);
    }];
    
    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pswTextField.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.contentView).mas_offset(35);
        make.right.mas_equalTo(self.contentView).mas_offset(-35);
        make.height.mas_equalTo(49);
    }];
    
    [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountBtn.mas_bottom).mas_offset(22);
        make.centerX.mas_equalTo(self.accountBtn.mas_centerX);
        if (item.accountType == PhotonAccountTypeRegister) {
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }else{
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }
    }];
}

+ (NSString *)cellIdentifier{
    return @"PhotonAccountCell";
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    return 50 * 4 + 10 * 2 + 50;
}

- (void)resignFirst{
    [self.pswTextField resignFirstResponder];
    [self.nickTextField resignFirstResponder];
}
@end
