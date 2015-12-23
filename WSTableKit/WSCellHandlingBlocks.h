//
//  WSCellAdjustmentBlock.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"

@class WSCellItem;

typedef void (^WSCellAdjustmentBlock)(id<WSCellClass> cell, WSCellItem *item, NSIndexPath *path);

typedef void (^WSCellDisplayBlock)(BOOL display, id<WSCellClass> cell, NSIndexPath *path);

typedef NS_ENUM(NSInteger, WSCellEvent) {
    WSCellShouldHightlightBlock = 0,
    WSCellWillSelect,
    WSCellWillDeselect,
    WSCellWillBeginEditing,
    WSCellDidEndEditing,
    WSCellDidHighlight,
    WSCellDidUnhighlight
};

/**
 *  Block for handling optional tableView delegate calls. Return defaultReturnValue as block result or your custom value for special events that you want to handle.
 *
 *  @param event                Delegate event correspond to specific delegate method call.
 *  @param path                 Cell path.
 *  @param defaultReturnValue   Default value for return result.
 
 *  @warning You should return defaultReturnValue for all unimplemented events.
 *
 *  @return Same actions require to return a value, like BOOL or NSIndexPath. If you want to handle event with custom result you should return your value instead of defaultReturnValue.
 */
typedef id (^WSCellEventBlock)(WSCellEvent event, NSIndexPath *path, id defaultReturnValue);


