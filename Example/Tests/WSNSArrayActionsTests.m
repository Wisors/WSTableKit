//
//  WSNSArrayActionsTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 16/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSArray+WSAction.h"
#import "WSCellItem.h"
#import "WSTableViewCell.h"

@interface WSNSArrayActionsTests : XCTestCase

@property (nonatomic) NSArray<WSCellItem *> *items;

@end

@implementation WSNSArrayActionsTests

- (void)setUp {
    [super setUp];
    
    WSCellItem *item1 = [WSCellItem itemWithClass:[WSTableViewCell class] object:nil];
    WSCellItem *item2 = [WSCellItem itemWithClass:[WSTableViewCell class] object:nil];
    self.items = @[item1, item2];
}

- (void)testAddAction {
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {}];
    [self.items addAction:action];
    
    [self.items enumerateObjectsUsingBlock:^(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertTrue([item.actionsHolder actionForType:WSActionClick] == action, @"Missing action");
    }];
}

- (void)testAddActions {
    WSAction *action1 = [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {}];
    WSAction *action2 = [WSAction actionWithType:WSActionWillDisplay actionBlock:^(WSActionInfo * _Nonnull actionInfo) {}];
    
    [self.items addActions:@[action1, action2]];
    
    [self.items enumerateObjectsUsingBlock:^(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertTrue([item.actionsHolder actionForType:WSActionClick] == action1, @"Missing action");
        XCTAssertTrue([item.actionsHolder actionForType:WSActionWillDisplay] == action2, @"Missing action");
    }];
}

- (void)testSetClickBlock {
    [self.items setClickBlock:^(id<WSCellClass>  _Nonnull cell, WSCellItem * _Nullable item, NSIndexPath * _Nonnull path) {}];
    
    [self.items enumerateObjectsUsingBlock:^(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        XCTAssertNotNil([item.actionsHolder actionForType:WSActionClick], @"Missing action");
    }];
}

@end
