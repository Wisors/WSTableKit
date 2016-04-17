//
//  WSActionsHolderTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 16/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WSActionsHolder.h"
#import "WSTableViewCell.h"

@interface WSActionsHolder(Tests)

@property (nonatomic) NSMutableDictionary *actions;

@end

@interface WSActionsHolderTests : XCTestCase

@end

@implementation WSActionsHolderTests

- (WSAction *)mocAction {
    return [WSAction actionWithType:WSActionClick actionBlock:nil];
}

- (void)testInitializer {
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[[self mocAction]]];
    
    XCTAssertNotNil(holder.actions, @"Action holder miss actions");
    XCTAssertTrue([holder.actions objectForKey:ws_convertEnumTypeToString(WSActionClick)], @"Action holder miss actions");
}

- (void)testCellItemsGetter {
    WSAction *action = [self mocAction];
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[action]];
    
    NSArray *actions = [holder cellActions];
    XCTAssertTrue(actions.count == 1, @"Wrong actions count");
    XCTAssertTrue([actions firstObject] == action, @"Missing test action");
}

- (void)testAddAction {
    WSActionsHolder *holder = [WSActionsHolder new];
    XCTAssertTrue(holder.actions.count == 0, @"Actions is not empty");
    
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:nil];
    [holder addAction:action];
    XCTAssertTrue(holder.actions.count == 1, @"Wrong actions count");
    XCTAssertTrue([holder.actions objectForKey:ws_convertEnumTypeToString(WSActionClick)] == action, @"Missing test action");
}

- (void)testAddActions {
    WSActionsHolder *holder = [WSActionsHolder new];
    XCTAssertTrue(holder.actions.count == 0, @"Actions is not empty");
    
    WSAction *action1 = [WSAction actionWithType:WSActionClick actionBlock:nil];
    WSAction *action2 = [WSAction actionWithType:WSActionWillDisplay actionBlock:nil];

    [holder addActions:@[action1, action2]];
    XCTAssertTrue(holder.actions.count == 2, @"Wrong actions count");
    XCTAssertTrue([holder.actions objectForKey:ws_convertEnumTypeToString(WSActionClick)] == action1, @"Missing test action");
    XCTAssertTrue([holder.actions objectForKey:ws_convertEnumTypeToString(WSActionWillDisplay)] == action2, @"Missing test action");
}

- (void)testActionForKey {
    WSActionsHolder *holder = [WSActionsHolder new];
    WSAction *action1 = [WSAction actionWithType:WSActionClick actionBlock:nil];
    WSAction *action2 = [WSAction actionWithType:WSActionWillDisplay actionBlock:nil];
    NSString *key1 = ws_convertEnumTypeToString(WSActionClick);
    NSString *key2 = ws_convertEnumTypeToString(WSActionWillDisplay);
    holder.actions = [@{key1 : action1, key2 : action2} mutableCopy];
    
    XCTAssertTrue([holder actionForKey:key1] == action1, @"Miss or wrong action");
    XCTAssertTrue([holder actionForKey:key2] == action2, @"Miss or wrong action");
}

- (void)testActionForType {
    WSActionsHolder *holder = [WSActionsHolder new];
    WSAction *action1 = [WSAction actionWithType:WSActionClick actionBlock:nil];
    WSAction *action2 = [WSAction actionWithType:WSActionWillDisplay actionBlock:nil];
    NSString *key1 = ws_convertEnumTypeToString(WSActionClick);
    NSString *key2 = ws_convertEnumTypeToString(WSActionWillDisplay);
    holder.actions = [@{key1 : action1, key2 : action2} mutableCopy];
    
    XCTAssertTrue([holder actionForType:WSActionClick] == action1, @"Miss or wrong action");
    XCTAssertTrue([holder actionForType:WSActionWillDisplay] == action2, @"Miss or wrong action");
}

- (void)testRemoveActionForKey {
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:nil];
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[action]];
    XCTAssertTrue(holder.actions.count == 1, @"Actions is empty");
    
    [holder removeActionForKey:ws_convertEnumTypeToString(WSActionClick)];
    XCTAssertTrue(holder.actions.count == 0, @"Actions is not empty");
}


- (void)testRemoveActionForType {
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:nil];
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[action]];
    XCTAssertTrue(holder.actions.count == 1, @"Actions is empty");
    
    [holder removeActionForType:WSActionClick];
    XCTAssertTrue(holder.actions.count == 0, @"Actions is not empty");
}

- (void)testInvocationForKey {
    XCTestExpectation *invocationExp = [self expectationWithDescription:@"wait for invokation"];
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        [invocationExp fulfill];
    }];
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[action]];
    
    WSActionInfo *actionInfo = [WSActionInfo actionInfoWithView:[WSTableViewCell new] item:nil path:nil userInfo:nil];
    [holder invokeActionForKey:ws_convertEnumTypeToString(WSActionClick) withActionInfo:actionInfo];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testInvocationForType {
    XCTestExpectation *invocationExp = [self expectationWithDescription:@"wait for invokation"];
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        [invocationExp fulfill];
    }];
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[action]];
    
    WSActionInfo *actionInfo = [WSActionInfo actionInfoWithView:[WSTableViewCell new] item:nil path:nil userInfo:nil];
    [holder invokeActionForType:WSActionClick withActionInfo:actionInfo];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testActionWithSameKeyOverrideOldOne {
    WSAction *action = [self mocAction];
    WSActionsHolder *holder = [[WSActionsHolder alloc] initWithActions:@[action]];
    
    [holder addAction:[self mocAction]];
    XCTAssertNotEqual(action, [holder actionForType:WSActionClick], @"Action was not replaced");
}

@end
