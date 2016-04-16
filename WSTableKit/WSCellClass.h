//
//  WSCellClass.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSItem;

/**
 *  WSCellClass is an UITableViewCell extension protocol, that provides unified interface of cell configuration.
 */
@protocol WSCellClass <NSObject>

/**
 *  Apply item to cell to proper configure it and make design adjustment with possibility of performance optimization. No need to fully adjust your cell design for height calculation, only change height dependent attributes.
 *
 *  @param item              WSCellItem object for this cell.
 *  @param heightCalculation YES means that cell is preparing for height calculation and -cellHeight will be called as next method, NO - cell is preparing for showing in a tableview and requred full adjustment.
 */
- (void)applyItem:(nullable id<WSItem>)item heightCalculation:(BOOL)heightCalculation;

@optional

/**
 *  Calculate and return custom cell height.
 *
 *  @return Value of cell height to proper showing in tableview.
 */
- (CGFloat)cellHeight;

// All NSObject classes are responding to this methods, but are not exposing it in a <NSObject> protocol
+ (BOOL)instancesRespondToSelector:(nonnull SEL)aSelector;
+ (BOOL)respondsToSelector:(nonnull SEL)selector;

@end

