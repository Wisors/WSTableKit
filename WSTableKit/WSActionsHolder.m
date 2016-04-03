//
//  WSActionsStorage.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSActionsHolder.h"

@interface WSActionsHolder()

@property (nonatomic) NSMutableDictionary *actions;

@end

@implementation WSActionsHolder

- (instancetype)init {
    return [self initWithActions:nil];
}

- (nonnull instancetype)initWithActions:(nullable NSArray *)actions {
    if ((self = [super init])) {
        _actions = [NSMutableDictionary new];
        [self addActions:actions];
    }
    
    return self;
}

- (NSArray<WSAction*> *)cellActions {
    return [self.actions allValues];
}

- (void)addAction:(nullable WSAction *)action {
    if (action) {
        [self.actions setObject:action forKey:action.key];
    }
}

- (void)addActions:(nullable NSArray<WSAction *> *)actions {
    [actions enumerateObjectsUsingBlock:^(WSAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.actions setObject:action forKey:action.key];
    }];
}

- (nullable WSAction *)actionForKey:(nonnull NSString *)key {
    return [self.actions objectForKey:key];
}

- (nullable WSAction *)actionForType:(WSActionType)type {
    return [self.actions objectForKey:ws_convertEnumTypeToString(type)];
}

- (void)removeActionForKey:(nonnull NSString *)key {
    [self.actions removeObjectForKey:key];
}

- (void)removeActionForType:(WSActionType)type {
    return [self.actions removeObjectForKey:ws_convertEnumTypeToString(type)];
}

@end

@implementation WSActionsHolder(WSActionInvocation)

- (nullable id)invokeActionForType:(WSActionType)type withActionInfo:(nonnull WSActionInfo *)info {
    return [self invokeActionForKey:ws_convertEnumTypeToString(type) withActionInfo:info];
}

- (nullable id)invokeActionForKey:(nonnull NSString *)key withActionInfo:(nonnull WSActionInfo *)info {
    WSAction *action = [self actionForKey:key];
    return (action) ? [action invokeActionWithInfo:info] : nil;
}

@end