//
//  NSArray+WSAction.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 16/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellItem.h"

@interface NSArray(WSAction)

- (void)addAction:(nullable WSAction *)action;
- (void)addActions:(nullable NSArray<WSAction *> *)actions;
- (void)setClickBlock:(nullable WSClickBlock)block;

@end
