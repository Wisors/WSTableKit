//
//  WSCellsPrototypeHolder.h
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSCellsPrototyper.h"

@interface WSCellsPrototypeHolder : NSObject<WSCellsPrototyper>

- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView;

@end
