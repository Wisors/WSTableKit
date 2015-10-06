//
//  WSCellAction.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSCellAction.h"

@interface WSCellAction()

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSMutableArray *shortActions;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, copy) WSCellActionBlock actionBlock;

@end

@implementation WSCellAction

+ (instancetype)actionWithKey:(NSString *)key {
    return [[self alloc] initWithKey:key actionBlock:nil shortActionBlock:nil];
}

+ (instancetype)actionWithKey:(NSString *)key actionBlock:(WSCellActionBlock)actionBlock {
    return [[self alloc] initWithKey:key actionBlock:actionBlock shortActionBlock:nil];
}

+ (instancetype)actionWithKey:(NSString *)key shortActionBlock:(WSCellActionShortBlock)actionBlock {
    return [[self alloc] initWithKey:key actionBlock:nil shortActionBlock:actionBlock];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

- (instancetype)initWithKey:(NSString *)key {
    return [self initWithKey:key actionBlock:nil shortActionBlock:nil];
}

- (instancetype)initWithKey:(NSString *)key actionBlock:(WSCellActionBlock)actionBlock {
    return [self initWithKey:key actionBlock:actionBlock shortActionBlock:nil];
}

- (instancetype)initWithKey:(NSString *)key shortActionBlock:(WSCellActionShortBlock)actionBlock {
    return [self initWithKey:key actionBlock:nil shortActionBlock:actionBlock];
}

- (instancetype)initWithKey:(NSString *)key
                actionBlock:(WSCellActionBlock)actionBlock
           shortActionBlock:(WSCellActionShortBlock)shortActionBlock {
    
    NSAssert(key != nil, @"Action makes no sense without key");
    if ((self = [super init])) {
        _key = key;
        _actionBlock = actionBlock;
        _shortActions = [NSMutableArray new];
        _lock = [NSLock new];
        if (shortActionBlock) {
            [_shortActions addObject:shortActionBlock];
        }
    }
    
    return self;
}

- (void)addShortBlock:(WSCellActionShortBlock)shortBlock {
    
    if (!shortBlock) {
        return;
    }
    
    [_lock lock];
    if (![_shortActions containsObject:shortBlock]) {
        [_shortActions addObject:[shortBlock copy]];
    }
    [_lock unlock];
}

@end

@implementation WSCellAction(Invocation)

- (id)invokeActionWithCell:(WSTableViewCell *)cell {
    return [self invokeActionWithCell:cell userInfo:nil];
}

- (id)invokeActionWithCell:(WSTableViewCell *)cell userInfo:(NSDictionary *)userInfo {
    
    [_lock lock];
    for (WSCellActionShortBlock actionBlock in _shortActions) {
        actionBlock(cell);
    }
    [_lock unlock];
    
    return (self.actionBlock) ? self.actionBlock(cell, userInfo) : nil;
}

@end