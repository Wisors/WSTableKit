//
//  WSActionsStorage.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSAction.h"

@interface WSActionsHolder : NSObject

- (nonnull instancetype)initWithActions:(nullable NSArray *)actions;

/**
 *  Return all actions stored by holder.
 *
 *  @param action Array of actions. The order of actions is not defined.
 */
- (nonnull NSArray<WSAction *> *)cellActions;

/**
 *  Add new action. It will ovveride existed action with same key.
 *
 *  @param action Your WSCellAction. In case of nil do nothing.
 */
- (void)addAction:(nullable WSAction *)action;
/**
 *  Add new actions. It will ovveride existed actions with same key by the last one in array.
 *
 *  @param action Your actions. In case of nil do nothing.
 */
- (void)addActions:(nullable NSArray<WSAction *> *)actions;

// Access
/**
 *  Get action for specific key. Return nil, if action with provided key not exists.
 *
 *  @param key Action key.
 *
 *  @return Action object.
 */
- (nullable WSAction *)actionForKey:(nonnull NSString *)key;
/**
 *  Get action with specific type. Return nil, if action with provided key not exists.
 *
 *  @param key Action type.
 *
 *  @return Action object.
 */
- (nullable WSAction *)actionForType:(WSActionType)type;

// Remove
/**
 *  Delete action with provided key.
 *
 *  @param action Action key.
 */
- (void)removeActionForKey:(nonnull NSString *)key;
/**
 *  Delete action with provided type.
 *
 *  @param action Action key.
 */
- (void)removeActionForType:(WSActionType)type;

@end

@interface WSActionsHolder(WSActionInvocation)

/**
 *  Holder contains actions with specific keys. This method convert provided type to an appropriet key and invoke action associated with the key.
 *
 *  @param type Action type.
 *  @param info Acion's information
 *
 *  @return Result of action invocation or nil
 */
- (nullable id)invokeActionForType:(WSActionType)type withActionInfo:(nonnull WSActionInfo *)info;

/**
 *  Holder contains actions with specific keys. This method invoke action associated with the provided key.
 *
 *  @param type Action type.
 *  @param info Acion's information
 *
 *  @return Result of action invocation or nil
 */
- (nullable id)invokeActionForKey:(nonnull NSString *)key withActionInfo:(nonnull WSActionInfo *)info;

@end
