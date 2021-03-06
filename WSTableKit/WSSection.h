//
//  TableSection.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellItem.h"
#import "WSSupplementaryItem.h"
#import "WSTableViewDirector.h"

@class WSCellItem;

@interface WSSection : NSObject <WSTableViewDirector>

/**
 *  Supplementary items of section.
 */
@property (nonatomic, nullable) WSSupplementaryItem *sectionHeader;
@property (nonatomic, nullable) WSSupplementaryItem *sectionFooter;

/**
 *  Define either show or not sectionHeader/sectionFooter even if sections contains no cells.
 */
@property (nonatomic, assign) BOOL showSupplementaryInEmptySection; // Default - NO

+ (nonnull instancetype)sectionWithTableView:(nonnull UITableView *)tableView;

/**
 *  Factory method with CellItem objects.
 *
 *  @param cellItems       Array if CellItem objects.
 *  @param tableView       Provide your table view to make fast initialization of delegates and preheated registration of prototype cells.
 *
 *  @return Instance of WSTableSection class.
 */
+ (nonnull instancetype)sectionWithItems:(nullable NSArray<WSCellItem *> *)cellItems tableView:(nonnull UITableView *)tableView;

/**
 *  Fast factory method to create TableSection with specific CellClass and array of objects that fit this cell class.
 *
 *  @param cellClass TableViewCell CellClass
 *  @param objects   Array of custom objects that will be transformed to array of CellItems. nil safe parameter (method will return empty section).
 *  @param tableView       Provide your table view to make fast initialization of delegates and preheated registration of prototype cells.
 *
 *  @return Instance of WSTableSection class.
 */
+ (nonnull instancetype)sectionWithCellClass:(nonnull Class<WSCellClass>)cellClass
                                     objects:(nullable NSArray<WSCellItem *> *)objects
                                   tableView:(nonnull UITableView *)tableView;

/**
 *  Use this initializer if you wish to forward UIScrollVideDelegate events to you custom delegate.
 */
- (nonnull instancetype)initWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                       scrollDelegate:(nullable id<UIScrollViewDelegate>)delegate
                            tableView:(nonnull UITableView *)tableView NS_DESIGNATED_INITIALIZER;

/**
 *  Block that will be invoked during cell preparating process. This block will be called right before cell adjustment action. Passing nil will remove previously assigned block.
 *
 *  @param adjustmentBlock  Customization block
 *
 *  @return Return current section.
 */
- (nonnull instancetype)setAdjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

@end

@interface WSSection(ItemAccess)

- (void)cleanHeightsCache;

/**
 *  Update section with completely new array of CellItem objects.
 *
 *  @param items Array if CellItem objects.
 */
- (void)updateWithItems:(nullable NSArray<WSCellItem *> *)items;
/**
 *  Add item at the end of section.
 *
 *  @param item CellItem object.
 */
- (void)addItem:(nullable WSCellItem *)item;
/**
 *  Add items at the end of section.
 *
 *  @param items Array if CellItem objects.
 */
- (void)addItems:(nullable NSArray<WSCellItem *> *)items;
/**
 *  Add item at specific index. If index is already occupied, the objects at index and beyond are shifted by adding 1 to their indices to make room.
 *
 *  @param item  CellItem to insert.
 *  @param index Item index.
 */
- (void)insertItem:(nullable WSCellItem *)item atIndex:(NSInteger)index;

- (void)replaceItemAtIndex:(NSInteger)index withItem:(nullable WSCellItem *)item;

- (void)removeItemAtIndex:(NSInteger)index;
- (void)removeItemsAtIndexes:(nullable NSIndexSet *)set;
- (void)removeAllItems;

- (void)enumerateObjectsUsingBlock:(nullable void (^)(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nullable stop))block;
- (nullable WSCellItem *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(nullable WSCellItem *)item;

- (NSUInteger)numberOfItems;

@end
