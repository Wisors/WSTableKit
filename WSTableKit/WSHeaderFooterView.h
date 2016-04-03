//
//  WSHeaderFooterView.h
//  WSTableKit
//
//  Created by Alex Nikishin on 28/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSSupplementaryItem.h"

@interface WSHeaderFooterView : UITableViewHeaderFooterView<WSCellClass>

@property (nonatomic, nullable) WSSupplementaryItem *item;

@end
