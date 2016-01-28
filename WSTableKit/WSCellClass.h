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
 *  Apply item to cell to proper configure it and make design adjustment if needed with additional flag of current applying behavior: design adjustment or adjustment for height calculation
 *
 *  @param item              WSCellItem object for this cell.
 *  @param heightCalculation YES means the cell is preparing for cell height calculation, NO - cell is preparing for showing in a tableview.
 */
- (void)applyItem:(nullable WSCellItem *)item heightCalculation:(BOOL)heightCalculation;

/**
 *  Calculated cell height for some item. It's will only called on prototype cells, so you might want to optimized this call and omit some adjustment, that will not cause cell to change it size.
 *
 *  @param item WSCellItem object for this cell.
 *
 *  @return Calculated height.
 */
- (CGFloat)heightWithItem:(nullable WSCellItem *)item __attribute__((deprecated("Use -cellHeight instead and implement -applyItem:heightCalculation: if you need performance oprimizations")));

/**
 *  Return proper cell height in current state
 *
 *  @return Value of cell height to proper showing in tableview.
 */
- (CGFloat)cellHeight;

// All NSObject classes responds to this methods, but not expose it in a <NSObject> protocol
+ (BOOL)instancesRespondToSelector:(nonnull SEL)aSelector;
+ (BOOL)respondsToSelector:(nonnull SEL)selector;

@end
