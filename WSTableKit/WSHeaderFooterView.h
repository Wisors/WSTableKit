//
//  WSHeaderFooterView.h
//  WSTableKit
//
//  Created by Alex Nikishin on 28/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSCellClass.h"
#import <UIKit/UIKit.h>

@interface WSHeaderFooterView : UITableViewHeaderFooterView<WSCellClass>

@property (nonatomic, nullable) WSCellItem *item;
@property (nonatomic, assign) IBInspectable BOOL hasAutolayout;

@end
