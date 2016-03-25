//
//  WSCellPrototyper.h
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSCellClass.h"
#import "WSIdentifierConvention.h"

@protocol WSCellsPrototyper<NSObject>

@property (nonatomic, nonnull, readonly) UITableView *tableView;
@property (nonatomic, nonnull, readonly) id<WSIdentifierConvention> identifierConvention;

- (void)registerIfNeededCellClass:(nonnull Class<WSCellClass>)cellClass;
- (void)registerIfNeededCellClasses:(nullable NSSet<WSCellClass> *)cellClasses;
- (void)registerIfNeededHeaderFooterViewClass:(nonnull Class<WSCellClass>)headerFooterViewClass;

- (nullable UITableViewHeaderFooterView<WSCellClass> *)headerFooterPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass;
- (nullable UITableViewCell<WSCellClass> *)cellPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass;

@end
