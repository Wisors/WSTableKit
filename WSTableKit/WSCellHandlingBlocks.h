//
//  WSCellAdjustmentBlock.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"
#import "WSActionTypes.h"

typedef void (^WSAdjustmentBlock)(_Nonnull id<WSCellClass> cell, WSCellItem * _Nonnull item, NSIndexPath * _Nonnull path);
