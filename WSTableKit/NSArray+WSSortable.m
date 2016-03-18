//
//  NSArray+WSSortable.m
//  WSTableKit
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "NSArray+WSSortable.h"

@implementation NSArray (WSSortable)

- (nonnull NSArray *)sortSortableObjects {
    return [self sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id<WSSortable> item1, id<WSSortable> item2) {
        NSString *firstKey = [[item1 sortKey] lowercaseString];
        NSString *secondKey = [[item2 sortKey] lowercaseString];
        return [firstKey compare:secondKey];
    }];
}

- (nonnull NSArray *)sortStingsAlphabeticaly {
    return [self sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSString *item1, NSString *item2) {
        return [item1 compare:item2];
    }];
}

@end
