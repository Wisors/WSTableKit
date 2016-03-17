//
//  CellItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSAction.h"

typedef void (^WSAdjustmentBlock)(_Nonnull id<WSCellClass> cell, WSCellItem * _Nonnull item, NSIndexPath * _Nonnull path);

@interface WSCellItem : NSObject

@property (nonatomic, assign, nonnull, readonly) Class<WSCellClass> cellClass;
@property (nonatomic, nullable, readonly) id object;
@property (nonatomic, nullable) WSAction *adjustment;

///-------------------------------------------------
/// @name Base initilizers
///-------------------------------------------------

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass object:(nullable id)object;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                             customAction:(nullable WSAction *)action;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                            customActions:(nullable NSArray<WSAction *> *)actions;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                               adjustment:(nullable WSAction *)adjustment;

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                          adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

- (nonnull instancetype)initWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                          adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

- (nonnull instancetype)initWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                               adjustment:(nullable WSAction *)adjustment NS_DESIGNATED_INITIALIZER;

@end

@interface WSCellItem(Actions)

- (nullable NSArray<WSAction *> *)cellActions;

- (nonnull instancetype)addAction:(WSActionType)type
                      actionBlock:(nullable WSActionBlock)block;

- (nonnull instancetype)addAction:(WSActionType)type
                 returnValueBlock:(nullable WSReturnValueBlock)block;

/**
 *  Add new custom action. If CellItem already contains action with the same key - it will override previous action with new one.
 *
 *  @param action Custom CellAction.
 */
- (void)addAction:(nullable WSAction *)action;
- (void)addActions:(nullable NSArray<WSAction *> *)actions;

// Access
/**
 *  Get custom action for specific key. Return nil, if that kind of action is not exist.
 *
 *  @param key Action key.
 *
 *  @return Custom action object.
 */
- (nullable WSAction *)actionForKey:(nonnull NSString *)key;
- (nullable WSAction *)actionForType:(WSActionType)type;

// Remove
- (void)removeActionForKey:(nonnull NSString *)key;

// Invoke
/**
 *  Cell contains actions with specific keys. This method convert type to appropriet key and invoke action associated with key.
 *
 *  @param type Action type.
 *  @param cell Cell will be passed to executed action.
 *
 *  @return Result of action invocation or nil
 */
- (nullable id)invokeActionForType:(WSActionType)type withCell:(nonnull UITableViewCell<WSCellClass> *)cell;
/**
 *  Cell contains actions with specific keys. This method convert type to appropriet key and invoke action associated with key and pass additional information.
 *
 *  @param type     Action type.
 *  @param cell     Cell will be passed to executed action.
 *  @param userInfo You may pass an optional information for your custom cell action.
 *
 *  @return Result of action invocation or nil
 */
- (nullable id)invokeActionForType:(WSActionType)type
                          withCell:(nonnull UITableViewCell<WSCellClass> *)cell
                          userInfo:(nullable NSDictionary *)userInfo;

/**
 *  Cell contains actions with specific keys. This method invoke action associated with key.
 *
 *  @param type Action type.
 *  @param cell Cell will be passed to executed action.
 *
 *  @return Result of action invocation or nil
 */
- (nullable id)invokeActionForKey:(nonnull NSString *)key withCell:(nonnull UITableViewCell<WSCellClass> *)cell;
/**
 *  Cell contains actions with specific keys. This method invoke action associated with key and pass additional information.
 *
 *  @param type     Action type.
 *  @param cell     Cell will be passed to executed action.
 *  @param userInfo You may pass an optional information for your custom cell action.
 *
 *  @return Result of action invocation or nil
 */
- (nullable id)invokeActionForKey:(nonnull NSString *)key
                         withCell:(nonnull UITableViewCell<WSCellClass> *)cell
                         userInfo:(nullable NSDictionary *)userInfo;

@end

@interface WSCellItem(Fabrics)

///-------------------------------------------------
/// @name Fabric methods for mass cell item creation
///-------------------------------------------------
/// All methods are nil-save, so if you pass empty or nil objects it will return an empty array;
+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass objects:(nullable NSArray *)objects;

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                          customActions:(nullable NSArray *)actions;

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                        adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                                actions:(nullable NSArray *)actions
                        adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                             adjustment:(nullable WSAction *)adjustment;

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                                actions:(nullable NSArray *)actions
                             adjustment:(nullable WSAction *)adjustment;

@end
