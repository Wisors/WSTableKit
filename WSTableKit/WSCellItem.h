//
//  WSBaseItem.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSItem.h"

@class WSCellItem;

typedef void (^WSAdjustmentBlock)(_Nonnull id<WSCellClass> cell, WSCellItem * _Nullable item, NSIndexPath * _Nonnull path);
typedef void (^WSClickBlock)(_Nonnull id<WSCellClass> cell, WSCellItem * _Nullable item, NSIndexPath * _Nonnull path);

@interface WSCellItem : NSObject<WSItem>
///-------------------------------------------------
/// @name Base initilizers
///-------------------------------------------------

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass object:(nullable id)object;

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass
                               object:(nullable id)object
                         customAction:(nullable WSAction *)action;

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass
                               object:(nullable id)object
                        customActions:(nullable NSArray<WSAction *> *)actions;

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass
                               object:(nullable id)object
                           adjustment:(nullable WSAction *)adjustment;

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                      adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                              actions:(nullable NSArray<WSAction *> *)actions
                      adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

- (nonnull instancetype)initWithViewClass:(nonnull Class)viewClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                          adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;


- (nonnull instancetype)initWithViewClass:(nonnull Class<WSCellClass>)viewClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                               adjustment:(nullable WSAction *)adjustment NS_DESIGNATED_INITIALIZER;

@end


@interface WSCellItem(Actions)

- (nonnull instancetype)setClickBlock:(nullable WSClickBlock)clickBlock;

/**
 *  Add new custom action. If CellItem already contains action with the same key - it will override previous action with new one.
 *
 *  @param action Custom CellAction.
 *
 *  @return Return self for chaing.
 */
- (nonnull instancetype)addAction:(nullable WSAction *)action;
- (nonnull instancetype)addActions:(nullable NSArray<WSAction *> *)actions;

- (nonnull instancetype)removeAction:(WSActionType)actionType;
- (nonnull instancetype)removeActionForKey:(nonnull NSString *)key;

// Invoke

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

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects;
+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects customActions:(nullable NSArray *)actions;
+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects adjustment:(nullable WSAction *)adjustment;
+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass
                            objects:(nullable NSArray *)objects
                            actions:(nullable NSArray *)actions
                    adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass
                            objects:(nullable NSArray *)objects
                            actions:(nullable NSArray *)actions
                         adjustment:(nullable WSAction *)adjustment;

@end
