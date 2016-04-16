//
//  NSArray+WSAction.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 16/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "NSArray+WSAction.h"

@implementation NSArray(WSAction)

- (void)addAction:(nullable WSAction *)action {
    if (action) {
        [self enumerateObjectsUsingBlock:^(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            NSAssert([item isKindOfClass:[WSCellItem class]], @"Iterated array contains none WSCellItem object");
            [item addAction:action];
        }];
    }
}

- (void)addActions:(nullable NSArray<WSAction *> *)actions {
    [actions enumerateObjectsUsingBlock:^(WSAction * _Nonnull action, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addAction:action];
    }];
}

- (void)setClickBlock:(nullable WSClickBlock)block {
    WSAction *click = (block) ? [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        block(actionInfo.cell, actionInfo.item, actionInfo.path);
    }] : nil;
    [self enumerateObjectsUsingBlock:^(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert([item isKindOfClass:[WSCellItem class]], @"Iterated array contains none WSCellItem object");
        (click) ? [item addAction:click] : [item removeAction:WSActionClick];
    }];
}

@end
