//
//  WSActionInfo.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 13/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSActionInfo.h"

@interface WSActionInfo()

@property (nonatomic, nonnull) UITableViewCell<WSCellClass> *cell;
@property (nonatomic, nonnull) WSCellItem *item;
@property (nonatomic, nullable) NSIndexPath *path;
@property (nonatomic, nullable) NSDictionary *userInfo;

@end

@implementation WSActionInfo

+ (nonnull instancetype)actionInfoWithCell:(nonnull UITableViewCell<WSCellClass> *)cell
                                      item:(nonnull WSCellItem *)item
                                      path:(nullable NSIndexPath *)path
                                  userInfo:(nullable NSDictionary *)userInfo {
    return [[self alloc] initWithCell:cell item:item path:path userInfo:userInfo];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

- (nonnull instancetype)initWithCell:(nonnull UITableViewCell<WSCellClass> *)cell
                                item:(nonnull WSCellItem *)item
                                path:(nullable NSIndexPath *)path
                            userInfo:(nullable NSDictionary *)userInfo {
    
    if ((self = [super init])) {
        _cell = cell;
        _path = path;
        _item = item;
        _userInfo = userInfo;
    }
    
    return self;
}

@end
