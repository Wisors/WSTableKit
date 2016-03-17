//
//  WSActionInfo.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 13/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"

@class WSCellItem;

/**
 *  WSActionInfo class used overall by WSTableKit. It is agregating all the info provided for some cell action and associate it with cell.
 */
@interface WSActionInfo : NSObject

@property (nonatomic, readonly, nonnull) UITableViewCell<WSCellClass> *cell;
@property (nonatomic, readonly, nonnull) WSCellItem *item;
@property (nonatomic, readonly, nullable) NSIndexPath *path;
@property (nonatomic, readonly, nullable) NSDictionary *userInfo;

+ (nonnull instancetype)actionInfoWithCell:(nonnull UITableViewCell<WSCellClass> *)cell
                                      item:(nonnull WSCellItem *)item
                                      path:(nullable NSIndexPath *)path
                                  userInfo:(nullable NSDictionary *)userInfo;

- (nonnull instancetype)initWithCell:(nonnull UITableViewCell<WSCellClass> *)cell
                                item:(nonnull WSCellItem *)item
                                path:(nullable NSIndexPath *)path
                            userInfo:(nullable NSDictionary *)userInfo NS_DESIGNATED_INITIALIZER;

@end