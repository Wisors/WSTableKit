//
//  NSArray+WSSortable.h
//  WSTableKit
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSSortable.h"

@interface NSArray(WSSortable)

- (nonnull NSArray *)sortSortableObjects;
- (nonnull NSArray *)sortStingsAlphabeticaly;

@end
