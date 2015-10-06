//
//  CellItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellAction.h"
#import "WSCellClass.h"
#import "WSCellHandlingBlocks.h"

/**
 *  Cell selection block invoked during tableview default selection/deselection proccess.
 *
 *  @param selected Selection state, YES - selected.
 *  @param item     WSCellItem associated with selected/deselected cell.
 *  @param path     IndexPath of selected/deselected cell.
 */
typedef void (^WSCellSelectionBlock)(BOOL selected, WSCellItem *item, NSIndexPath *path);

@interface WSCellItem : NSObject

@property (nonatomic, assign, readonly) Class<WSCellClass> cellClass;
@property (nonatomic, strong, readonly) id object;
@property (nonatomic, copy) WSCellSelectionBlock selectionBlock;
@property (nonatomic, copy) WSCellAdjustmentBlock adjustmentBlock;

///-------------------------------------------------
/// @name Base initilizers
///-------------------------------------------------

+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object;
+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object customAction:(WSCellAction *)action;
+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object customActions:(NSArray *)actions;
+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;
+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object selectionBlock:(WSCellSelectionBlock)selectionBlock;

- (instancetype)initWithCellClass:(Class)cellClass object:(id)object;
- (instancetype)initWithCellClass:(Class)cellClass object:(id)object customActions:(NSArray *)actions;
- (instancetype)initWithCellClass:(Class)cellClass object:(id)object adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;
- (instancetype)initWithCellClass:(Class)cellClass object:(id)object selectionBlock:(WSCellSelectionBlock)selectionBlock;

- (instancetype)initWithCellClass:(Class)cellClass
                           object:(id)object
                          actions:(NSArray *)actions
                   selectionBlock:(WSCellSelectionBlock)selectionBlock
                  adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock NS_DESIGNATED_INITIALIZER;

// Autocompletion syntax helpers for XCode
- (void)setSelectionBlock:(WSCellSelectionBlock)selectionBlock;
- (void)setAdjustmentBlock:(WSCellAdjustmentBlock)cellAdjustmentBlock;

@end

@interface WSCellItem(Actions)

// Add
/**
 *  Add new custom action. If CellItem already contains action with the same key - it will override previous action with new one.
 *
 *  @param action Custom CellAction.
 */
- (void)addAction:(WSCellAction *)action;
- (void)addActions:(NSArray *)actions;

// Access
/**
 *  Get custom action for specific key. Return nil, if that kind of action is not exist.
 *
 *  @param key Action key.
 *
 *  @return Custom action object.
 */
- (WSCellAction *)actionForKey:(NSString *)key;

// Remove
- (void)removeActionForKey:(NSString *)key;

// Invoke
/**
 *  Invoke custom action for specific key. Does nothing if action is not exist.
 *
 *  @param key  Action key.
 *
 *  @return Result of action invocation.
 */
- (id)invokeActionForKey:(NSString *)key withCell:(WSTableViewCell *)cell;
- (id)invokeActionForKey:(NSString *)key withCell:(WSTableViewCell *)cell userInfo:(NSDictionary *)userInfo;

@end

@interface WSCellItem(Fabrics)

///-------------------------------------------------
/// @name Fabric methods for mass cell item creation
///-------------------------------------------------
/// All methods are nil-save, so if you pass empty or nil objects it will return an empty array;
+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects;
+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects customActions:(NSArray *)actions;
+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects selectionBlock:(WSCellSelectionBlock)selectionBlock;
+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;
+ (NSArray *)cellItemsWithClass:(Class)cellClass
                        objects:(NSArray *)objects
                        actions:(NSArray *)actions
                 selectionBlock:(WSCellSelectionBlock)selectionBlock
                adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;

@end
