//
//  CellItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSActionTypes.h"
#import "WSAction.h"
#import "WSCellClass.h"
#import "WSCellHandlingBlocks.h"

@interface WSCellItem : NSObject

@property (nonatomic, assign, nonnull, readonly) Class<WSCellClass> cellClass;
@property (nonatomic, nullable, readonly) id object;
@property (nonatomic, nullable, copy) WSCellAdjustmentBlock adjustmentBlock;

///-------------------------------------------------
/// @name Base initilizers
///-------------------------------------------------

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass object:(nullable id)object;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                             customAction:(nonnull WSAction *)action;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                            customActions:(nullable NSArray<WSAction *> *)actions;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                          adjustmentBlock:(nullable WSCellAdjustmentBlock)adjustmentBlock;

- (nonnull instancetype)initWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                          adjustmentBlock:(nullable WSCellAdjustmentBlock)adjustmentBlock NS_DESIGNATED_INITIALIZER;

// Autocompletion syntax helpers for XCode
- (void)setAdjustmentBlock:(nullable WSCellAdjustmentBlock)cellAdjustmentBlock;

- (nonnull instancetype)addAction:(WSActionType)type
                      actionBlock:(nullable WSCellActionShortBlock)block;

@end

@interface WSCellItem(Actions)

// Add
/**
 *  Add new custom action. If CellItem already contains action with the same key - it will override previous action with new one.
 *
 *  @param action Custom CellAction.
 */
- (void)addAction:(WSAction *)action;
- (void)addActions:(NSArray *)actions;

// Access
/**
 *  Get custom action for specific key. Return nil, if that kind of action is not exist.
 *
 *  @param key Action key.
 *
 *  @return Custom action object.
 */
- (WSAction *)actionForKey:(NSString *)key;

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
