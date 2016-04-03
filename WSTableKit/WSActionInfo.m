//
//  WSActionInfo.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 13/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSActionInfo.h"

@interface WSActionInfo()

@property (nonatomic, nonnull) UIView<WSCellClass> *view;
@property (nonatomic, nonnull) id<WSItem> item;
@property (nonatomic, nullable) NSIndexPath *path;
@property (nonatomic, nullable) NSDictionary *userInfo;

@end

@implementation WSActionInfo

+ (nonnull instancetype)actionInfoWithView:(nonnull UIView<WSCellClass> *)view
                                      item:(nonnull id<WSItem>)item
                                      path:(nullable NSIndexPath *)path
                                  userInfo:(nullable NSDictionary *)userInfo {
    return [[self alloc] initWithView:view item:item path:path userInfo:userInfo];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

- (nonnull instancetype)initWithView:(nonnull UIView<WSCellClass> *)view
                                item:(nonnull id<WSItem>)item
                                path:(nullable NSIndexPath *)path
                            userInfo:(nullable NSDictionary *)userInfo {
    
    if ((self = [super init])) {
        _view = view;
        _path = path;
        _item = item;
        _userInfo = userInfo;
    }
    
    return self;
}

- (nonnull UITableViewCell *)cell {
    return (UITableViewCell *)_view;
}

- (nonnull UITableViewHeaderFooterView *)headerFooter {
    return (UITableViewHeaderFooterView *)_view;
}

@end
