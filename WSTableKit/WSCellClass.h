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
+ (nonnull NSString *)cellIdentifier;

/**
 *  Apply item to cell to proper configure it and make design adjustment.
 *
 *  @param item WSCellItem object for this cell.
 */
- (void)applyItem:(nullable WSCellItem *)item;

@optional

/**
 *  Apply item to cell to proper configure it and make design adjustment with possibility of performance optimization. No need to fully adjust your cell design for height calculation, just height dependent attributes.
 *
 *  @param item              WSCellItem object for this cell.
 *  @param heightCalculation YES means the cell is preparing for cell height calculation, NO - cell is preparing for showing in a tableview.
 */
- (void)applyItem:(nullable WSCellItem *)item heightCalculation:(BOOL)heightCalculation;

/**
 *  Calculate and return custom cell height.
 *
 *  @return Value of cell height to proper showing in tableview.
 */
- (CGFloat)cellHeight;

// All NSObject classes responds to this methods, but not expose it in a <NSObject> protocol
+ (BOOL)instancesRespondToSelector:(nonnull SEL)aSelector;
+ (BOOL)respondsToSelector:(nonnull SEL)selector;

@end
