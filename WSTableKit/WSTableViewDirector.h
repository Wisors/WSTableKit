//
//  TableViewDirector.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WSCellHandlingBlocks.h"

@class WSCellItem;

@protocol WSTableViewDirector <NSObject, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, nullable, copy) WSAdjustmentBlock adjustmentBlock;

@end
