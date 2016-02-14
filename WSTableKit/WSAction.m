//
//  WSCellAction.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSAction.h"

@interface WSAction()

@property (nonatomic) NSString *key;
@property (nonatomic) NSMutableArray *actionBlocks;
@property (nonatomic, copy) WSReturnValueBlock returnValueBlock;

@end

@implementation WSAction

+ (nonnull instancetype)actionWithKey:(nonnull NSString *)key actionBlock:(nullable WSActionBlock)actionBlock {
    return [[self alloc] initWithKey:key actionBlock:actionBlock returnValueBlock:nil];
}

+ (nonnull instancetype)actionWithKey:(nonnull NSString *)key returnValueBlock:(nullable WSReturnValueBlock)returnValueBlock {
    return [[self alloc] initWithKey:key actionBlock:nil returnValueBlock:returnValueBlock];
}

+ (nonnull instancetype)actionWithType:(WSActionType)type actionBlock:(nullable WSActionBlock)actionBlock {
    return [[self alloc] initWithKey:ws_convertEnumTypeToString(type) actionBlock:actionBlock returnValueBlock:nil];
}

+ (nonnull instancetype)actionWithType:(WSActionType)type returnValueBlock:(nullable WSReturnValueBlock)returnValueBlock {
    return [[self alloc] initWithKey:ws_convertEnumTypeToString(type) actionBlock:nil returnValueBlock:returnValueBlock];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

- (nonnull instancetype)initWithKey:(nonnull NSString *)key
                        actionBlock:(nullable WSActionBlock)actionBlock
                   returnValueBlock:(nullable WSReturnValueBlock)returnValueBlock {
    NSAssert(key != nil, @"Action makes no sense without key");
    if ((self = [super init])) {
        _key = key;
        _returnValueBlock = returnValueBlock;
        _actionBlocks = [NSMutableArray new];
        if (actionBlock) {
            [_actionBlocks addObject:actionBlock];
        }
    }
    
    return self;
}

- (void)addActionBlock:(nullable WSActionBlock)actionBlock {
    if (!actionBlock) {
        return;
    }
    
    if (![_actionBlocks containsObject:actionBlock]) {
        [_actionBlocks addObject:[actionBlock copy]];
    }
}

@end

@implementation WSAction(Invocation)

- (nullable id)invokeActionWithCell:(nonnull id<WSCellClass>)cell actionInfo:(nonnull WSActionInfo *)actionInfo {
    for (WSActionBlock actionBlock in _actionBlocks) {
        actionBlock(actionInfo);
    }
    
    return (self.returnValueBlock) ? self.returnValueBlock(actionInfo) : nil;
}

@end