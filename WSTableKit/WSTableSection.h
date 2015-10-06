//
//  TableSection.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"
#import "WSSectionSupplementaryItem.h"
#import "WSTableViewDirector.h"

@class WSCellItem;

@interface WSTableSection : NSObject <WSTableViewDirector>

@property (nonatomic, strong) WSSectionSupplementaryItem *sectionHeader;
@property (nonatomic, strong) WSSectionSupplementaryItem *sectionFooter;

/**
 *  Fast factory method to create TableSection with specific CellClass and array of objects that fit this cell class.
 *
 *  @param cellClass TableViewCell CellClass
 *  @param objects   Array of custom objects that will be transformed to array of CellItems. nil safe parameter (method will return empty section).
 *
 *  @return Instance of TableSection class.
 */
+ (instancetype)sectionWithCellClass:(Class<WSCellClass>)cellClass objects:(NSArray *)objects;

/**
 *  Factory method with CellItem objects.
 *
 *  @param cellItems       Array if CellItem objects.
 *
 *  @return Instance of TableSection class.
 */
+ (instancetype)sectionWithItems:(NSArray *)cellItems;

/**
 *  Factory method with CellItem objects.
 *
 *  @param cellItems       Array if CellItem objects.
 *  @param adjustmentBlock CellAdjustmentBlock that will be invoked during cell preparating process. This is optional parameter, that can recieve nil.
 *
 *  @return Instance of TableSection class.
 */
+ (instancetype)sectionWithItems:(NSArray *)cellItems adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;

/**
 *  Init flat colletion of table view CellItem objects and cell adjustment block. This object may behave as UITableView dataSource and delegate(optionaly).
 *  @param cellItems       Array if CellItem objects.
 *  @param adjustmentBlock CellAdjustmentBlock that will be invoked during cell preparating process. This is optional parameter, that can recieve nil.
 *
 *  @return Instance of TableSection class.
 */
- (instancetype)initWithItems:(NSArray *)cellItems adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;

/**
 *  Call thit initializer if you with to forward UIScrollVideDelegate event forwarded to you custom delegate.
 */
- (instancetype)initWithItems:(NSArray *)cellItems adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock scrollDelegate:(id<UIScrollViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)setAdjustmentBlock:(WSCellAdjustmentBlock)cellAdjustmentBlock;
- (void)setDisplayBlock:(WSCellDisplayBlock)displayBlock;
- (void)setEventBlock:(WSCellEventBlock)eventBlock;

@end

@interface WSTableSection(ItemAccess)

/**
 *  Update section with completely new array of CellItem objects.
 *
 *  @param items Array if CellItem objects.
 */
- (void)updateWithItems:(NSArray *)items;
/**
 *  Add item at the end of section.
 *
 *  @param item CellItem object.
 */
- (void)addItem:(WSCellItem *)item;
/**
 *  Add items at the end of section.
 *
 *  @param items Array if CellItem objects.
 */
- (void)addItems:(NSArray *)items;
/**
 *  Add item at specific index. If index is already occupied, the objects at index and beyond are shifted by adding 1 to their indices to make room.
 *
 *  @param item  CellItem to insert.
 *  @param index Item index.
 */
- (void)insertItem:(WSCellItem *)item atIndex:(NSInteger)index;

- (void)replaceItemAtIndex:(NSInteger)index withItem:(WSCellItem *)item;

- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItemsAtIndexes:(NSIndexSet *)set;
- (void)removeAllItems;

- (void)enumerateObjectsUsingBlock:(void (^)(WSCellItem *item, NSUInteger idx, BOOL *stop))block;
- (WSCellItem *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(WSCellItem *)item;

- (NSUInteger)numberOfItems;

@end
