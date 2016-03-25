//
//  UITableView+WSTableExtension.h
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSIdentifierConvention.h"

@interface UITableView (WSTableExtension)

- (void)ws_registerCellClass:(nonnull Class)cellClass identifierConvention:(nonnull id<WSIdentifierConvention>)convention;
- (void)ws_registerCellClasses:(nullable NSSet<Class> *)cellClasses identifierConvention:(nonnull id<WSIdentifierConvention>)convention;
- (void)ws_registerHeaderFooterClass:(nonnull Class)headerFooterClass identifierConvention:(nonnull id<WSIdentifierConvention>)convention;

@end
