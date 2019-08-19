//
//  PhotonAccountDataSource.m
//  PhotonIM
//
//  Created by Bruce on 2019/6/27.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonAccountDataSource.h"
#import "PhotonAccountItem.h"
#import "PhotonAccountCell.h"
@implementation PhotonAccountDataSource
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    if ([object isKindOfClass:[PhotonAccountItem class]]) {
        return [PhotonAccountCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}
@end
