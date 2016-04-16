//
//  WSBaseItem.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSCellItem.h"

@interface WSCellItem()

@property (nonatomic, assign, nonnull) Class<WSCellClass> viewClass;
@property (nonatomic, nullable) id object;
@property (nonatomic, nonnull) WSActionsHolder *actionsHolder;

@end

@implementation WSCellItem
@synthesize adjustment = _adjustment;

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass object:(nullable id)object {
    return [[self alloc] initWithViewClass:cellClass object:object actions:nil adjustment:nil];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass
                               object:(nullable id)object
                         customAction:(nullable WSAction *)action {
    return [[self alloc] initWithViewClass:cellClass
                                    object:object
                                   actions:(action) ? @[action] : nil
                                adjustment:nil];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass
                               object:(nullable id)object
                        customActions:(nullable NSArray<WSAction *> *)actions {
    return [[self alloc] initWithViewClass:cellClass object:object actions:actions adjustment:nil];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)cellClass
                               object:(nullable id)object
                           adjustment:(nullable WSAction *)adjustment {
    return [[self alloc] initWithViewClass:cellClass object:object actions:nil adjustment:adjustment];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                      adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithViewClass:viewClass object:object actions:nil adjustmentBlock:adjustmentBlock];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                              actions:(nullable NSArray<WSAction *> *)actions
                      adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithViewClass:viewClass object:object actions:actions adjustmentBlock:adjustmentBlock];
}

- (nonnull instancetype)initWithViewClass:(nonnull Class)viewClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                          adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    WSAction *adjustment = (adjustmentBlock) ? [WSAction actionWithType:WSActionAdjustment actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        adjustmentBlock(actionInfo.cell, actionInfo.item, actionInfo.path);
    }] : nil;
    return [self initWithViewClass:viewClass object:object actions:actions adjustment:adjustment];
}

- (instancetype)init NS_UNAVAILABLE {
    return nil;
}

- (nonnull instancetype)initWithViewClass:(nonnull Class<WSCellClass>)viewClass
                                   object:(nullable id)object
                                  actions:(nullable NSArray<WSAction *> *)actions
                               adjustment:(nullable WSAction *)adjustment {
    if ((self = [super init])) {
        NSAssert([(id)viewClass conformsToProtocol:@protocol(WSCellClass)], @"Cell class must conform to CellClass protocol");
        _adjustment     = adjustment;
        _viewClass      = viewClass;
        _object         = object;
        _actionsHolder  = [[WSActionsHolder alloc] initWithActions:actions];
    }
    
    return self;
}

@end

@implementation WSCellItem(Actions)

- (nonnull instancetype)setClickBlock:(nullable WSClickBlock)clickBlock {
    WSAction *click = (clickBlock) ? [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        clickBlock(actionInfo.cell, actionInfo.item, actionInfo.path);
    }] : nil;
    (click) ? [_actionsHolder addAction:click] : [_actionsHolder removeActionForType:WSActionClick];
    return self;
}

- (nonnull instancetype)addAction:(nullable WSAction *)action {
    [_actionsHolder addAction:action];
    return self;
}
- (nonnull instancetype)addActions:(nullable NSArray<WSAction *> *)actions {
    [_actionsHolder addActions:actions];
    return self;
}

- (nonnull instancetype)removeAction:(WSActionType)actionType {
    [_actionsHolder removeActionForType:actionType];
    return self;
}
- (nonnull instancetype)removeActionForKey:(nonnull NSString *)key {
    [_actionsHolder removeActionForKey:key];
    return self;
}

- (nullable id)invokeActionForKey:(nonnull NSString *)key withCell:(nonnull UITableViewCell<WSCellClass> *)cell {
    return [self invokeActionForKey:key withCell:cell userInfo:nil];
}

- (nullable id)invokeActionForKey:(nonnull NSString *)key
                         withCell:(nonnull UITableViewCell<WSCellClass> *)cell
                         userInfo:(nullable NSDictionary *)userInfo {
    return [_actionsHolder invokeActionForKey:key
                               withActionInfo:[WSActionInfo actionInfoWithView:cell
                                                                          item:self
                                                                          path:nil
                                                                      userInfo:userInfo]];
}

@end

@implementation WSCellItem(Fabrics)

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects {
    return [self itemsWithClass:viewClass objects:objects actions:nil adjustment:nil];
}

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects customActions:(nullable NSArray *)actions {
    return [self itemsWithClass:viewClass objects:objects actions:actions adjustment:nil];
}

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects adjustment:(nullable WSAction *)adjustment {
    return [self itemsWithClass:viewClass objects:objects actions:nil adjustment:adjustment];
}

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass objects:(nullable NSArray *)objects adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [self itemsWithClass:viewClass objects:objects actions:nil adjustmentBlock:adjustmentBlock];
}

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass
                            objects:(nullable NSArray *)objects
                            actions:(nullable NSArray *)actions
                    adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    WSAction *adjustment = (adjustmentBlock) ? [WSAction actionWithType:WSActionAdjustment actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        adjustmentBlock(actionInfo.cell, actionInfo.item, actionInfo.path);
    }] : nil;
    return [self itemsWithClass:viewClass objects:objects actions:actions adjustment:adjustment];
}

+ (nonnull NSArray *)itemsWithClass:(nonnull Class)viewClass
                            objects:(nullable NSArray *)objects
                            actions:(nullable NSArray *)actions
                         adjustment:(nullable WSAction *)adjustment {
    if (objects.count == 0) {
        return @[];
    }
    
    NSMutableArray *cellItems = [NSMutableArray new];
    for (id object in objects) {
        WSCellItem *item = [[self alloc] initWithViewClass:viewClass object:object actions:actions adjustment:adjustment];
        [cellItems addObject:item];
    }
    
    return [cellItems copy];
}

@end