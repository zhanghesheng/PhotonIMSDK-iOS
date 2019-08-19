//
//  PhotonDBManager.m
//  PhotonIM
//
//  Created by Bruce on 2019/7/2.
//  Copyright © 2019 Bruce. All rights reserved.
//

#import "PhotonDBManager.h"
#import "PhotonMacros.h"
static PhotonDBManager *dbManager = nil;
@interface PhotonDBManager()
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end
@implementation PhotonDBManager
+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbManager = [[PhotonDBManager alloc] init];
    });
    return dbManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (FMDatabaseQueue *)dbQueue{
    return [PhotonDBManager defaultManager].dbQueue;
}

+ (void)openDB{
    [self closeDB];
    [[PhotonDBManager defaultManager] openDB];
}

+ (void)closeDB{
    [[PhotonDBManager defaultManager] closeDB];
}

- (void)openDB{
    if (!_dbQueue) {
       _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
    }
}

- (void)closeDB{
    if (_dbQueue) {
        [_dbQueue close];
        _dbQueue = nil;
    }
    
}

- (NSString *)dbPath
{
    NSString *path = [NSString stringWithFormat:@"%@/PhotonIM/User/%@/DB/", [NSFileManager documentsPath], [PhotonContent currentUser].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            PhotonLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"common.sqlite3"];
}
@end
