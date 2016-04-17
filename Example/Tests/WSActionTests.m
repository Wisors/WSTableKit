//
//  WSActionTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 16/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WSAction.h"
#import "WSTableViewCell.h"

@interface WSAction(Tests)

@property (nonatomic, nonnull) NSMutableArray<WSActionBlock> *actionBlocks;

@end

@interface WSActionTests : XCTestCase

@end

@implementation WSActionTests

- (WSActionInfo *)fakeInfo {
    return [WSActionInfo actionInfoWithView:[WSTableViewCell new] item:nil path:nil userInfo:nil];
}

- (void)testDesignatedInitializer {
    NSString *testkey = @"TestKey";
    XCTestExpectation *actionBlockExp = [self expectationWithDescription:@"wait for action block"];
    XCTestExpectation *returnValueBlockExp = [self expectationWithDescription:@"wait for return block"];
    WSActionBlock actionBlock = ^(WSActionInfo *actionInfo){
        [actionBlockExp fulfill];
    };
    WSReturnValueBlock returnValueBlock = ^id(WSActionInfo *actionInfo){
        [returnValueBlockExp fulfill];
        return nil;
    };
    
    WSAction *action = [[WSAction alloc] initWithKey:testkey
                                                 actionBlock:actionBlock
                                            returnValueBlock:returnValueBlock];
    XCTAssertTrue([testkey isEqual:action.key], @"Action initialized with wrong key");
    XCTAssertTrue([action.actionBlocks count] == 1, @"Action has one block");
    XCTAssertNotNil(action.returnValueBlock, @"Action has return block");
    
    action.returnValueBlock([self fakeInfo]);
    [action.actionBlocks firstObject]([self fakeInfo]);
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

- (void)testAddAction {
    WSAction *action = [[WSAction alloc] initWithKey:@"test" actionBlock:nil returnValueBlock:nil];
    XCTAssertNotNil(action.actionBlocks, @"There is an empty action blocks array");
    XCTAssertTrue(action.actionBlocks.count == 0, @"Actions blocks array is empty");
    
    XCTestExpectation *actionBlockExp = [self expectationWithDescription:@"wait for action block"];
    WSActionBlock actionBlock = ^(WSActionInfo *actionInfo){
        [actionBlockExp fulfill];
    };
    [action addActionBlock:actionBlock];
    
    XCTAssertTrue(action.actionBlocks.count == 1, @"Actions blocks array contains one new element");
    
    [action.actionBlocks firstObject]([self fakeInfo]);
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
    [action addActionBlock:^(WSActionInfo * _Nonnull actionInfo) {}];
    XCTAssertTrue(action.actionBlocks.count == 2, @"Actions blocks array may contain more than one element");
}

- (void)testRemoveAllActionBlocks {
    WSActionBlock actionBlock = ^(WSActionInfo *actionInfo){};
    WSAction *action = [[WSAction alloc] initWithKey:@"test" actionBlock:actionBlock returnValueBlock:nil];
    
    XCTAssertTrue(action.actionBlocks.count == 1, @"Actions blocks array contains one element");
    [action removeAllBlocks];
    XCTAssertTrue(action.actionBlocks.count == 0, @"Actions blocks array is empty now");
}

- (void)testActionTypeInits {
    WSAction *action1 = [WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {}];
    WSAction *action2 = [WSAction actionWithType:WSActionClick returnValueBlock:^id _Nonnull(WSActionInfo * _Nonnull actionInfo) {return nil;}];
    
    XCTAssertTrue([action1.key isEqual:ws_convertEnumTypeToString(WSActionClick)], @"Wrong key conversation");
    XCTAssertTrue([action2.key isEqual:ws_convertEnumTypeToString(WSActionClick)], @"Wrong key conversation");
}

- (void)testActionInvocation {
    XCTestExpectation *actionBlockExp = [self expectationWithDescription:@"wait for action block"];
    XCTestExpectation *returnValueBlockExp = [self expectationWithDescription:@"wait for return block"];
    WSActionBlock actionBlock = ^(WSActionInfo *actionInfo){
        [actionBlockExp fulfill];
    };
    WSReturnValueBlock returnValueBlock = ^id(WSActionInfo *actionInfo){
        [returnValueBlockExp fulfill];
        return nil;
    };
    
    WSAction *action = [[WSAction alloc] initWithKey:@"Test" actionBlock:actionBlock returnValueBlock:returnValueBlock];
    [action invokeActionWithInfo:[self fakeInfo]];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
}

@end
