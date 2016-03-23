//
//  WSCellPrototyper.h
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSCellClass.h"

@protocol WSCellsPrototyper<NSObject>

@property (nonatomic, nonnull, readonly) UITableView *tableView;

- (nullable UITableViewHeaderFooterView<WSCellClass> *)headerFooterPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass;
- (nullable UITableViewCell<WSCellClass> *)cellPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass;

@end
