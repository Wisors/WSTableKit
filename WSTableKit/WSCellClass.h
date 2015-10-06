//
//  WSCellClass.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSCellItem;

/**
 *  CellClass is an UITableViewCell extension protocol, that helps you work with different UITableViewCell classes as abstract objects.
 */
@protocol WSCellClass <NSObject>

/**
 *  Cell Identifier, that will be used for UITableView dequeue. It's good practice to name your identifier as your cell Class name, so you can use it as registerNib parameter as well.
 *
 *  @return Cell identifier.
 */
+ (NSString *)cellIdentifier;

/**
 *  Apply item to cell to proper configure it and make design adjustment.
 *
 *  @param item WSCellItem object for this cell.
 */
- (void)applyItem:(WSCellItem *)item;

@optional

/**
 *  Calculated cell height for some item. It's will only called on prototype cells, so you might want to optimized this call and omit some adjustment, that will not cause cell to change it size.
 *
 *  @param item WSCellItem object for this cell.
 *
 *  @return Calculated height.
 */
- (CGFloat)heightWithItem:(WSCellItem *)item;

// All NSObject classes responds to this methods, but not expose it in a <NSObject> protocol
+ (BOOL)instancesRespondToSelector:(SEL)aSelector;
+ (BOOL)respondsToSelector:(SEL)selector;

@end
