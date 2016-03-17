//
//  WSCellAction.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSActionInfo.h"
#import "WSActionTypes.h"

/**
 *  Action block. Should be invoked by some event inside cell (button click, textfield changes, etc.). It is possible to have only one block of this type per one action key.
 *
 *  @param actionInfo      Object, that agregate all the necessary info about invoked action.
 *
 *  @return Action result if you need it inside your cell object, may return nil as well.
 */
typedef _Nonnull id (^WSReturnValueBlock)(WSActionInfo *_Nonnull actionInfo);
/**
 *  Short version of previous block, for actions that don't require a return value. It is possible to have multiple blocks of this type per one action key.
 *
 *  @param actionInfo      Object, that agregate all the necessary info about invoked action.
 */
typedef void (^WSActionBlock)(WSActionInfo * _Nonnull actionInfo);

@interface WSAction : NSObject

@property (nonatomic, readonly, nonnull) NSString *key;

+ (nonnull instancetype)actionWithKey:(nonnull NSString *)key actionBlock:(nullable WSActionBlock)actionBlock;
+ (nonnull instancetype)actionWithKey:(nonnull NSString *)key returnValueBlock:(nullable WSReturnValueBlock)returnValueBlock;

+ (nonnull instancetype)actionWithType:(WSActionType)type actionBlock:(nullable WSActionBlock)actionBlock;
+ (nonnull instancetype)actionWithType:(WSActionType)type returnValueBlock:(nullable WSReturnValueBlock)returnValueBlock;

- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                        actionBlock:(nullable WSActionBlock)actionBlock
                   returnValueBlock:(nullable WSReturnValueBlock)returnValueBlock NS_DESIGNATED_INITIALIZER;

/**
 *  Add additional block to action.
 *
 *  @param actionBlock Will be invoked by particular event.
 */
- (void)addActionBlock:(nullable WSActionBlock)actionBlock;

/**
 *  Remove all actions blocks and return block from action intances.
 */
- (void)removeAllBlocks;

@end

@interface WSAction(Invocation)

- (nullable id)invokeActionWithInfo:(nonnull WSActionInfo *)actionInfo;

@end