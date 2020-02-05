//
//  PhotonChatVideoMessageCell.m
//  PhotonIM
//
//  Created by Bruce on 2020/2/4.
//  Copyright © 2020 Bruce. All rights reserved.
//

#import "PhotonChatVideoMessageCell.h"
#import "PhotonChatVideoMessageItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotonMacros.h"
//
@interface PhotonChatVideoMessageCell()
@property(nonatomic,strong)UIImageView *playIconView;
@end
@implementation PhotonChatVideoMessageCell

- (void)dealloc
{
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    }
    return self;
}

- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
    PhotonChatVideoMessageItem *videoItem = (PhotonChatVideoMessageItem *)object;
    self.contentBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentBackgroundView addSubview:self.playIconView];
    NSURL *fileURL = nil;
    if (videoItem.coverURL) {
        if ([videoItem.coverURL hasPrefix:@"http"]) {
            fileURL = [NSURL URLWithString:videoItem.coverURL];
        }else{
            fileURL = [NSURL fileURLWithPath:videoItem.coverURL];
        }
    }
    if (fileURL) {
        [self.contentBackgroundView sd_setImageWithURL:fileURL placeholderImage:nil];
    }else{
        [self.contentBackgroundView setImage:videoItem.coverImage];
    }
}

- (void)p_layoutViews{
    PhotonChatBaseItem *item = (PhotonChatBaseItem *)self.item;
    CGRect contentBackgroundViewFrame = self.contentBackgroundView.frame;
    contentBackgroundViewFrame.size = CGSizeMake(item.contentSize.width + MSG_SPACE_RIGHT + MSG_SPACE_LEFT, item.contentSize.height + MSG_SPACE_TOP + MSG_SPACE_BTM);
    CGFloat contentBackgroundViewLeft = 0;
    if (item.fromType == PhotonChatMessageFromSelf) {
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x-contentBackgroundViewFrame.size.width;
    }else{
        contentBackgroundViewLeft = contentBackgroundViewFrame.origin.x;
    }
    contentBackgroundViewFrame.origin.x = contentBackgroundViewLeft;
    self.contentBackgroundView.frame = contentBackgroundViewFrame;
    
    CGRect playFrame = self.playIconView.frame;
    CGSize size = playFrame.size;
    CGPoint playOrigin = CGPointMake((contentBackgroundViewFrame.size.width - size.width)/2, (contentBackgroundViewFrame.size.height - size.height)/2);
    playFrame.origin = playOrigin;
    self.playIconView.frame = playFrame;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self p_layoutViews];
    [self subview_layout];
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (UIImageView *)playIconView{
    if (!_playIconView) {
        UIImage *image = [UIImage imageNamed:@"video_play"];
        CGFloat hwRatio = image.size.height/image.size.width;
        _playIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0*hwRatio)];
        _playIconView.image = image;
        _playIconView.userInteractionEnabled = NO;
        _playIconView.backgroundColor = [UIColor clearColor];
    }
    return _playIconView;
}

#pragma mark ----- Getter ---------
- (void)longPressBGView:(UIGestureRecognizer *)gestureRecognizer{
    [super longPressBGView:gestureRecognizer];
}

- (void)tapBackgroundView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCell:chatMessageCellTap:)]) {
        [self.delegate chatCell:self chatMessageCellTap:self.item];
    }
}

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    PhotonChatVideoMessageItem *item = (PhotonChatVideoMessageItem *)object;
    return item.itemHeight;
}

+ (NSString *)cellIdentifier{
    return @"PhotonChatVideoMessageCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end



