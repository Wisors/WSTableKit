//
//  CellItem.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSCellItem.h"

@interface WSCellItem()

@property (nonatomic, assign) Class<WSCellClass> cellClass;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSMutableArray *customActions;

@end

@implementation WSCellItem : NSObject

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass object:(nullable id)object {
    return [[self alloc] initWithCellClass:cellClass object:object actions:nil adjustmentBlock:nil];
}

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                             customAction:(nullable WSAction *)action {
    return [[self alloc] initWithCellClass:cellClass
                                    object:object
                                   actions:(action) ? @[action] : nil
                           adjustmentBlock:nil];
}

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                            customActions:(nullable NSArray<WSAction *> *)actions {
    return [[self alloc] initWithCellClass:cellClass object:object actions:actions adjustmentBlock:nil];
}

+ (nonnull instancetype)itemWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                          adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithCellClass:cellClass object:object actions:nil adjustmentBlock:adjustmentBlock];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

- (nonnull instancetype)initWithCellClass:(nonnull Class)cellClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                          adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    
    if ((self = [super init])) {
        NSAssert([cellClass conformsToProtocol:@protocol(WSCellClass)], @"Cell class must conform to CellClass protocol");
        _adjustmentBlock= adjustmentBlock;
        _cellClass      = cellClass;
        _object         = object;
        _customActions  = [NSMutableArray new];
        if ([actions count] > 0 ) {
            [self addActions:actions];
        }
    }
    
    return self;
}

@end

@implementation WSCellItem(Actions)

- (nullable NSArray<WSAction *> *)cellActions {
    return [_customActions copy];
}

- (nonnull instancetype)addAction:(WSActionType)type actionBlock:(nullable WSActionBlock)block {
    [self addAction:[WSAction actionWithType:type actionBlock:block]];
    return self;
}

- (nonnull instancetype)addAction:(WSActionType)type returnValueBlock:(nullable WSReturnValueBlock)block {
    [self addAction:[WSAction actionWithType:type returnValueBlock:block]];
    return self;
}

- (void)addAction:(nullable WSAction *)action {
    if (!action) {
        return;
    }
    
    [self removeActionForKey:action.key];
    [_customActions addObject:action];
}

- (void)addActions:(nullable NSArray<WSAction *> *)actions {
    if ([actions count] == 0) {
        return;
    }
    
    if ([_customActions count] == 0) {
        _customActions = [actions mutableCopy];
    } else {
        for (WSAction *action in actions) {
            [self addAction:action];
        }
    }
}

- (nullable WSAction *)actionForKey:(nonnull NSString *)key {
    __block WSAction *foundAction;
    [_customActions enumerateObjectsUsingBlock:^(WSAction *action, NSUInteger idx, BOOL *stop) {
        if ([action.key isEqualToString:key]) {
            foundAction = action;
            *stop = YES;
        }
    }];
    
    return foundAction;
}

- (nullable WSAction *)actionForType:(WSActionType)type {
    return [self actionForKey:ws_convertEnumTypeToString(type)];
}

- (void)removeActionForKey:(nonnull NSString *)key {
    if (!key || [_customActions count] == 0) {
        return;
    }
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [_customActions enumerateObjectsUsingBlock:^(WSAction *action, NSUInteger idx, BOOL *stop) {
        if ([action.key isEqualToString:key]) {
            [set addIndex:idx];
        }
    }];
    [_customActions removeObjectsAtIndexes:set];
}

- (nullable id)invokeActionForType:(WSActionType)type withCell:(nonnull UITableViewCell<WSCellClass> *)cell {
    return [self invokeActionForKey:ws_convertEnumTypeToString(type) withCell:cell userInfo:nil];
}

- (nullable id)invokeActionForType:(WSActionType)type
                          withCell:(nonnull UITableViewCell<WSCellClass> *)cell
                          userInfo:(nullable NSDictionary *)userInfo {
    return [self invokeActionForKey:ws_convertEnumTypeToString(type) withCell:cell userInfo:userInfo];
}

- (nullable id)invokeActionForKey:(nonnull NSString *)key withCell:(nonnull UITableViewCell<WSCellClass> *)cell {
    return [self invokeActionForKey:key withCell:cell userInfo:nil];
}

- (nullable id)invokeActionForKey:(nonnull NSString *)key
                         withCell:(nonnull UITableViewCell<WSCellClass> *)cell
                         userInfo:(nullable NSDictionary *)userInfo {
    
    WSAction *action = [self actionForKey:key];
    if (action) {
        WSActionInfo *actionInfo = [WSActionInfo actionInfoWithCell:cell path:nil item:self userInfo:userInfo];
        return [action invokeActionWithInfo:actionInfo];
    }
    return nil;
}

@end

@implementation WSCellItem(Fabrics)

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass objects:(nullable NSArray *)objects {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:nil adjustmentBlock:nil];
}

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                          customActions:(nullable NSArray *)actions {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:actions adjustmentBlock:nil];
}

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                        adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:nil adjustmentBlock:adjustmentBlock];
}

+ (nonnull NSArray *)cellItemsWithClass:(nonnull Class)cellClass
                                objects:(nullable NSArray *)objects
                                actions:(nullable NSArray *)actions
                        adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    if (objects.count == 0) {
        return @[];
    }
    
    NSMutableArray *cellItems = [NSMutableArray new];
    for (id object in objects) {
        WSCellItem *item = [[WSCellItem alloc] initWithCellClass:cellClass object:object actions:actions adjustmentBlock:adjustmentBlock];
        [cellItems addObject:item];
    }
    
    return [cellItems copy];
}

@end
