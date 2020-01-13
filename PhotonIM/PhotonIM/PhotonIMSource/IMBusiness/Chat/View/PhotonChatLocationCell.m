//
//  PhotonChatLocationCell.m
//  PhotonIM
//
//  Created by Bruce on 2020/1/10.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatLocationCell.h"
#import "PhotonChatLocationItem.h"
@interface PhotonChatLocationCell()
@property(nonatomic, strong)UILabel  *addressLabel;
@property(nonatomic, strong)UILabel  *detailAddressLabel;
@property(nonatomic, strong)UILabel  *lntLabel;
@property(nonatomic, strong)UILabel  *latLabel;
@end

@implementation PhotonChatLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentBackgroundView addSubview:self.addressLabel];
        [self.contentBackgroundView addSubview:self.detailAddressLabel];
        [self.contentBackgroundView addSubview:self.lntLabel];
        [self.contentBackgroundView addSubview:self.latLabel];
      
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
    PhotonChatLocationItem *locationItem = (PhotonChatLocationItem *)object;
    self.addressLabel.text = locationItem.address;
    self.detailAddressLabel.text = locationItem.detailAddress;
    self.latLabel.text = [NSString stringWithFormat:@"经度:%.2f",locationItem.locationCoordinate.latitude];
    self.lntLabel.text = [NSString stringWithFormat:@"纬度:%.2f",locationItem.locationCoordinate.longitude];
    
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.addressLabel.text = nil;
    self.detailAddressLabel.text = nil;
    self.lntLabel.text = nil;
    self.latLabel.text = nil;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    PhotonChatLocationItem *item = (PhotonChatLocationItem *)self.item;
    CGFloat bgViewWidth = PhotoScreenWidth/2.0;
    PhotonChatMessageFromType fromType = item.fromType;
    CGSize bgViewSize = CGSizeMake(bgViewWidth, 80);
    CGRect contentBackgroundViewFrame = self.contentBackgroundView.frame;
    contentBackgroundViewFrame.size = bgViewSize;
    CGFloat contentBackgroundViewLeft = 0;
    if (fromType == PhotonChatMessageFromSelf) {
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x-contentBackgroundViewFrame.size.width;
    }else{
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x;
    }
    contentBackgroundViewFrame.origin.x = contentBackgroundViewLeft;
    self.contentBackgroundView.frame = contentBackgroundViewFrame;
    
    CGRect addressLabelFrame = self.addressLabel.frame;
    addressLabelFrame.size =CGSizeMake(bgViewWidth - 10, 20);
    
    CGRect detailAddressLabelFrame = self.detailAddressLabel.frame;
    detailAddressLabelFrame.size =CGSizeMake(bgViewWidth - 10, 15);
    
    CGFloat latWidth = (bgViewWidth - 10)/2;
    CGRect latLabelFrame = self.latLabel.frame;
    latLabelFrame.size =CGSizeMake(latWidth, 15);
    
    CGRect lntLabelFrame = self.lntLabel.frame;
    lntLabelFrame.size =CGSizeMake(latWidth, 15);
    
//    if (fromType == PhotonChatMessageFromSelf) {
        addressLabelFrame.origin = CGPointMake(5, 5);
        detailAddressLabelFrame.origin = CGPointMake(5, 27);
        latLabelFrame.origin = CGPointMake(5, 50);
        lntLabelFrame.origin = CGPointMake(5+latWidth, 50);
//       
//    }else if(fromType == PhotonChatMessageFromFriend){
//       
//    }
    self.addressLabel.frame = addressLabelFrame;
    self.detailAddressLabel.frame = detailAddressLabelFrame;
    self.latLabel.frame = latLabelFrame;
    self.lntLabel.frame = lntLabelFrame;
    
    [self subview_layout];
}

- (UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        [_addressLabel setFont:[UIFont systemFontOfSize:16.0]];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        [_addressLabel setNumberOfLines:0];
    }
    return _addressLabel;
}

- (UILabel *)detailAddressLabel{
    if (_detailAddressLabel == nil) {
        _detailAddressLabel = [[UILabel alloc] init];
        [_detailAddressLabel setFont:[UIFont systemFontOfSize:13.0]];
        _detailAddressLabel.textAlignment = NSTextAlignmentCenter;
        [_detailAddressLabel setNumberOfLines:0];
    }
    return _detailAddressLabel;
}
- (UILabel *)lntLabel{
    if (_lntLabel == nil) {
        _lntLabel = [[UILabel alloc] init];
        [_lntLabel setFont:[UIFont systemFontOfSize:13.0]];
        _lntLabel.textAlignment = NSTextAlignmentCenter;
        [_lntLabel setNumberOfLines:0];
    }
    return _lntLabel;
}

- (UILabel *)latLabel{
    if (_latLabel == nil) {
        _latLabel = [[UILabel alloc] init];
        [_latLabel setFont:[UIFont systemFontOfSize:13.0]];
        _latLabel.textAlignment = NSTextAlignmentCenter;
        [_latLabel setNumberOfLines:0];
    }
    return _latLabel;
}



@end
