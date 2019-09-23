//
//  PhotonGroupContactCell.m
//  PhotonIM
//
//  Created by Bruce on 2019/9/23.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonGroupContactCell.h"
#import "PhotonGroupContactItem.h"
@implementation PhotonGroupContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
      
    }
    return self;
}
- (void)setObject:(id)object{
    [super setObject:object];
    if (!self.item) {
        return;
    }
    PhotonGroupContactItem *item = (PhotonGroupContactItem *)object;

}





+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object{
    PhotonGroupContactItem *item = (PhotonGroupContactItem *)object;
    return item.itemHeight;
}

+ (NSString *)cellIdentifier{
    return @"PhotonGroupContactCell";
}
@end
