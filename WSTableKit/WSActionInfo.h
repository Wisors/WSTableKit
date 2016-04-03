//
//  WSActionInfo.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 13/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"

@protocol WSItem;

/**
 *  WSActionInfo class used overall by WSTableKit. It is agregating all the info provided for some cell action and associate it with cell or header/footer
 */
@interface WSActionInfo : NSObject

@property (nonatomic, readonly, nonnull) UIView<WSCellClass> *view;
@property (nonatomic, readonly, nonnull) id<WSItem> item;
@property (nonatomic, readonly, nullable) NSIndexPath *path;
@property (nonatomic, readonly, nullable) NSDictionary *userInfo;

+ (nonnull instancetype)actionInfoWithView:(nonnull UIView<WSCellClass> *)view
                                      item:(nonnull id<WSItem>)item
                                      path:(nullable NSIndexPath *)path
                                  userInfo:(nullable NSDictionary *)userInfo;

- (nonnull instancetype)initWithView:(nonnull UIView<WSCellClass> *)view
                                item:(nonnull id<WSItem>)item
                                path:(nullable NSIndexPath *)path
                            userInfo:(nullable NSDictionary *)userInfo NS_DESIGNATED_INITIALIZER;

// Casted view object;
- (nonnull UITableViewCell<WSCellClass> *)cell;
- (nonnull UITableViewHeaderFooterView<WSCellClass> *)headerFooter;

@end
