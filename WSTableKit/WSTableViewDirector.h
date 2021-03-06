//
//  TableViewDirector.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WSCellsPrototyper.h"

@class WSAction, WSCellItem;

@protocol WSTableViewDirector <NSObject, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, nonnull, readonly) UITableView *tableView;
@property (nonatomic, nonnull) id<WSCellsPrototyper> cellPrototyper;
@property (nonatomic, nullable) WSAction *adjustment;

@end
