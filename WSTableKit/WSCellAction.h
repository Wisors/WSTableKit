//
//  WSCellAction.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSTableViewCell;

/**
 *  Custom action block. Should be invoked by some event inside cell (button click, textfield changes, etc.). It is possible to have only one block of this type per one action key.
 *
 *  @param cell      Cell object that cause this action occured.
 *  @param userInfo  Some additional parameters, may be nil as well.
 *
 *  @return Action result if you need it inside your cell object, may return nil as well.
 */
typedef id (^WSCellActionBlock)(WSTableViewCell *cell, NSDictionary *userInfo);
/**
 *  Short version of previous block, for actions that don't require a return value. It is possible to have multiple blocks of this type per one action key.
 *
 *  @param cell Cell that cause action.
 */
typedef void (^WSCellActionShortBlock)(WSTableViewCell *cell);

@interface WSCellAction : NSObject

@property (nonatomic, strong, readonly) NSString *key;

+ (instancetype)actionWithKey:(NSString *)key;
+ (instancetype)actionWithKey:(NSString *)key actionBlock:(WSCellActionBlock)actionBlock;
+ (instancetype)actionWithKey:(NSString *)key shortActionBlock:(WSCellActionShortBlock)actionBlock;
- (instancetype)initWithKey:(NSString *)key;
- (instancetype)initWithKey:(NSString *)key actionBlock:(WSCellActionBlock)actionBlock;
- (instancetype)initWithKey:(NSString *)key shortActionBlock:(WSCellActionShortBlock)actionBlock;
- (instancetype)initWithKey:(NSString *)key
                actionBlock:(WSCellActionBlock)actionBlock
           shortActionBlock:(WSCellActionShortBlock)shortActionBlock NS_DESIGNATED_INITIALIZER;

/**
 *  Add additional short block to action.
 *
 *  @param shortBlock Will be invoked by particular event.
 */
- (void)addShortBlock:(WSCellActionShortBlock)shortBlock;

@end

@interface WSCellAction(Invocation)

- (id)invokeActionWithCell:(WSTableViewCell *)cell;
- (id)invokeActionWithCell:(WSTableViewCell *)cell userInfo:(NSDictionary *)userInfo;

@end