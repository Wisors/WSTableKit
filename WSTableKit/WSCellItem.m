//
//  CellItem.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSCellItem.h"

@interface WSCellItem()

@property (nonatomic, assign) Class<WSCellClass> cellClass;
@property (nonatomic, strong) id item;
@property (nonatomic, strong) NSMutableArray *customActions;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation WSCellItem : NSObject

+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object {
    return [[self alloc] initWithCellClass:cellClass object:object actions:nil selectionBlock:nil adjustmentBlock:nil];
}

+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object customAction:(WSCellAction *)action {
    return [[self alloc] initWithCellClass:cellClass object:object actions:(action)? @[action] : nil selectionBlock:nil adjustmentBlock:nil];
}

+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object customActions:(NSArray *)actions {
    return [[self alloc] initWithCellClass:cellClass object:object actions:actions selectionBlock:nil adjustmentBlock:nil];
}

+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithCellClass:cellClass object:object actions:nil selectionBlock:nil adjustmentBlock:adjustmentBlock];
}

+ (instancetype)itemWithCellClass:(Class)cellClass object:(id)object selectionBlock:(WSCellSelectionBlock)selectionBlock {
    return [[self alloc] initWithCellClass:cellClass object:object actions:nil selectionBlock:selectionBlock adjustmentBlock:nil];
}

- (instancetype)initWithCellClass:(Class)cellClass object:(id)object {
    return [self initWithCellClass:cellClass object:object actions:nil selectionBlock:nil adjustmentBlock:nil];
}

- (instancetype)initWithCellClass:(Class)cellClass object:(id)object customActions:(NSArray *)actions {
    return [self initWithCellClass:cellClass object:object actions:actions selectionBlock:nil adjustmentBlock:nil];
}

- (instancetype)initWithCellClass:(Class)cellClass object:(id)object adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [self initWithCellClass:cellClass object:object actions:nil selectionBlock:nil adjustmentBlock:adjustmentBlock];
}

- (instancetype)initWithCellClass:(Class)cellClass object:(id)object selectionBlock:(WSCellSelectionBlock)selectionBlock {
    return [self initWithCellClass:cellClass object:object actions:nil selectionBlock:selectionBlock adjustmentBlock:nil];
}

- (instancetype)init {
    return [self initWithCellClass:nil object:nil actions:nil selectionBlock:nil adjustmentBlock:nil];
}

- (instancetype)initWithCellClass:(Class)cellClass
                           object:(id)object
                          actions:(NSArray *)actions
                   selectionBlock:(WSCellSelectionBlock)selectionBlock
                  adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    
    if ((self = [super init])) {
        
        NSAssert([cellClass conformsToProtocol:@protocol(WSCellClass)], @"Cell class must conform to CellClass protocol");
        _selectionBlock = selectionBlock;
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

- (void)addAction:(WSCellAction *)action {
    
    if (!action) {
        return;
    }
    
    [self removeActionForKey:action.key];
    [_lock lock];
    [_customActions addObject:action];
    [_lock unlock];
}

- (void)addActions:(NSArray *)actions {
    
    if ([actions count] == 0) {
        return;
    }
    
    if ([_customActions count] == 0) {
        _customActions = [actions mutableCopy];
    } else {
        for (WSCellAction *action in actions) {
            [self addAction:action];
        }
    }
}

- (void)removeActionForKey:(NSString *)key {
    
    if (!key || [_customActions count] == 0) {
        return;
    }
    
    [_lock lock];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [_customActions enumerateObjectsUsingBlock:^(WSCellAction *action, NSUInteger idx, BOOL *stop) {
        
        if ([action.key isEqualToString:key]) {
            [set addIndex:idx];
        }
    }];
    [_customActions removeObjectsAtIndexes:set];
    [_lock unlock];
}

- (WSCellAction *)actionForKey:(NSString *)key {
    
    __block WSCellAction *foundAction;
    [_lock lock];
    [_customActions enumerateObjectsUsingBlock:^(WSCellAction *action, NSUInteger idx, BOOL *stop) {
        if ([action.key isEqualToString:key]) {
            foundAction = action;
            *stop = YES;
        }
    }];
    [_lock unlock];
    
    return foundAction;
}

- (id)invokeActionForKey:(NSString *)key withCell:(WSTableViewCell *)cell {
    
    WSCellAction *action = [self actionForKey:key];
    return [action invokeActionWithCell:cell];
}
- (id)invokeActionForKey:(NSString *)key withCell:(WSTableViewCell *)cell userInfo:(NSDictionary *)userInfo {
    
    WSCellAction *action = [self actionForKey:key];
    return [action invokeActionWithCell:cell userInfo:userInfo];
}

@end

@implementation WSCellItem(Fabrics)

+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:nil selectionBlock:nil adjustmentBlock:nil];
}

+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects customActions:(NSArray *)actions {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:actions selectionBlock:nil adjustmentBlock:nil];
}

+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:nil selectionBlock:nil adjustmentBlock:adjustmentBlock];
}

+ (NSArray *)cellItemsWithClass:(Class)cellClass objects:(NSArray *)objects selectionBlock:(WSCellSelectionBlock)selectionBlock {
    return [WSCellItem cellItemsWithClass:cellClass objects:objects actions:nil selectionBlock:selectionBlock adjustmentBlock:nil];
}

+ (NSArray *)cellItemsWithClass:(Class)cellClass
                        objects:(NSArray *)objects
                        actions:(NSArray *)actions
                 selectionBlock:(WSCellSelectionBlock)selectionBlock
                adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    if (objects.count == 0) {
        return @[];
    }
    
    NSMutableArray *cellItems = [NSMutableArray new];
    for (id object in objects) {
        WSCellItem *item = [[WSCellItem alloc] initWithCellClass:cellClass object:object actions:actions selectionBlock:selectionBlock adjustmentBlock:adjustmentBlock];
        [cellItems addObject:item];
    }
    
    return [cellItems copy];
}

@end
