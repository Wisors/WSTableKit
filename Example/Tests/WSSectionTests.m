//
//  WSSectionTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 09/05/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WSSection.h"
#import "WSTableViewCell.h"

@interface WSSectionTests_TableViewCell : WSTableViewCell

@property (nonatomic) BOOL applyItemMehtodCalled;

@end

@implementation WSSectionTests_TableViewCell

- (void)applyItem:(id<WSItem>)item heightCalculation:(BOOL)heightCalculation {
    self.applyItemMehtodCalled = YES;
}

@end

@interface WSSectionTests : XCTestCase

@property (nonatomic) UITableViewController *testController;
@property (nonatomic) UITableView *testTable;
@property (nonatomic) WSSection *testSection;

@end


@implementation WSSectionTests

- (void)setUp {
    [super setUp];
    
    self.testController = [UITableViewController new];
    self.testTable = [UITableView new];
    self.testTable.frame = CGRectMake(0, 0, 300, 300);
    self.testSection = [WSSection sectionWithTableView:self.testTable];
}

- (void)testSectionInitialization {
    XCTAssertEqual(self.testSection.tableView, self.testTable, @"UITableView is not stored");
    XCTAssertTrue(self.testSection.numberOfItems == 0, @"Expect empty section");
    
    WSSection *secondSection = [WSSection sectionWithItems:@[[WSCellItem itemWithClass:[WSTableViewCell class] object:@"Test"]]
                                                 tableView:self.testTable];
    XCTAssertEqual(secondSection.tableView, self.testTable, @"UITableView is not stored");
    XCTAssertTrue(secondSection.numberOfItems == 1, @"Test item stored");
    XCTAssertEqual([secondSection itemAtIndex:0].object, @"Test", @"Wrong object saved");
    
    WSSection *thirdSection = [WSSection sectionWithCellClass:[WSTableViewCell class] objects:@[@"Test"] tableView:self.testTable];
    XCTAssertEqual(thirdSection.tableView, self.testTable, @"UITableView is not stored");
    XCTAssertTrue(thirdSection.numberOfItems == 1, @"Test item stored");
    XCTAssertEqual([thirdSection itemAtIndex:0].object, @"Test", @"Wrong object saved");
}

- (void)testSetAdjustmentBlock {
    WSSection *section = [WSSection sectionWithTableView:self.testTable];
    XCTAssertNil(section.adjustment, @"Expect empty adjustment action");
    [section setAdjustmentBlock:^(WSTableViewCell *cell, WSCellItem *item, NSIndexPath *path) {
        return;
    }];
    XCTAssertNotNil(section.adjustment, @"Expect adjustment action");
}

- (void)testAddAction {
    XCTAssertTrue(self.testSection.numberOfItems == 0, @"There are no elements");
    WSCellItem *item = [WSCellItem itemWithClass:[WSTableViewCell class] object:@"Test"];
    [self.testSection addItem:item];
    XCTAssertTrue(self.testSection.numberOfItems == 1, @"Expect element was added");
    XCTAssertNotNil([self.testSection.cellPrototyper cellPrototypeForCellClass:[WSTableViewCell class]], @"There is a cell prototype created");
    XCTAssertNoThrow([self.testSection addItem:nil], @"Add method can handle nil object");
}

- (void)testAddActions {
    XCTAssertTrue(self.testSection.numberOfItems == 0, @"There are no elements");
    WSCellItem *item = [WSCellItem itemWithClass:[WSTableViewCell class] object:@"Test"];
    [self.testSection addItems:@[item]];
    XCTAssertTrue(self.testSection.numberOfItems == 1, @"Expect element was added");
    XCTAssertNotNil([self.testSection.cellPrototyper cellPrototypeForCellClass:[WSTableViewCell class]], @"There is a cell prototype created");
    XCTAssertNoThrow([self.testSection addItems:nil], @"Add method can handle nil object");
}

- (void)testUpdateWithItems {
    WSSection *testSection = [WSSection sectionWithCellClass:[WSTableViewCell class] objects:@[@"one", @"two"] tableView:self.testTable];
    XCTAssertTrue(testSection.numberOfItems == 2, @"There are no elements");
    [testSection updateWithItems:@[[WSCellItem itemWithClass:[WSTableViewCell class] object:@"Test"]]];
    XCTAssertTrue(testSection.numberOfItems == 1, @"Expect element was added");
    XCTAssertNotNil([testSection.cellPrototyper cellPrototypeForCellClass:[WSTableViewCell class]], @"There is a cell prototype created");
    XCTAssertNoThrow([testSection updateWithItems:nil], @"Update method can handle nil object");
}

- (void)testRemoveAllItems {
    WSSection *testSection = [WSSection sectionWithCellClass:[WSTableViewCell class] objects:@[@"one", @"two"] tableView:self.testTable];
    XCTAssertTrue(testSection.numberOfItems == 2, @"There are no elements");
    [testSection removeAllItems];
    XCTAssertTrue(testSection.numberOfItems == 0, @"There are no elements");
}

- (void)testRemoveAtInexesSet {
    WSSection *testSection = [WSSection sectionWithCellClass:[WSTableViewCell class] objects:@[@"one", @"two", @"three", @"four"] tableView:self.testTable];
    XCTAssertTrue(testSection.numberOfItems == 4, @"There are no elements");
    NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:1];
    [set addIndex:3];
    XCTAssertNoThrow([testSection removeItemsAtIndexes:set], @"No exceptions expected");
    XCTAssertTrue(testSection.numberOfItems == 2, @"There are no elements");
    XCTAssertEqual([testSection itemAtIndex:0].object, @"one", @"Wrong object saved");
    XCTAssertEqual([testSection itemAtIndex:1].object, @"three", @"Wrong object saved");
}

- (void)testRemoveAtIndex {
    WSSection *testSection = [WSSection sectionWithCellClass:[WSTableViewCell class] objects:@[@"one", @"two", @"three", @"four"] tableView:self.testTable];
    XCTAssertTrue(testSection.numberOfItems == 4, @"There are no elements");
    XCTAssertThrows([testSection removeItemAtIndex:5], @"No exceptions expected if extends boundaries");
    XCTAssertTrue(testSection.numberOfItems == 4, @"There are no elements");
    XCTAssertNoThrow([testSection removeItemAtIndex:1], @"No exceptions expected if extends boundaries");
    XCTAssertEqual([testSection itemAtIndex:0].object, @"one", @"Wrong object saved");
    XCTAssertEqual([testSection itemAtIndex:1].object, @"three", @"Wrong object saved");
}

- (void)testTableDataSourceCellForRow {
    __block NSInteger sectionAdjustmentCalled = 0;
    __block NSInteger cellAdjustmentCalled = 0;
    
    WSSection *testSection = [WSSection sectionWithCellClass:[WSSectionTests_TableViewCell class] objects:@[@"one"] tableView:self.testController.tableView];
    self.testController.tableView.dataSource = testSection;
    self.testController.tableView.delegate = testSection;
    [testSection setAdjustmentBlock:^(id<WSCellClass>  _Nonnull cell, WSCellItem * _Nullable item, NSIndexPath * _Nonnull path) {
        sectionAdjustmentCalled++;
    }];
    [[testSection itemAtIndex:0] setAdjustment:[WSAction actionWithType:WSActionAdjustment actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        cellAdjustmentCalled++;
    }]];
    UITableViewCell *cell;
    XCTAssertNoThrow(cell = [testSection tableView:self.testController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], @"Expect success call");
    XCTAssertTrue([cell class] == [WSSectionTests_TableViewCell class], @"Expect WSTableViewCell instance");
    XCTAssertTrue(((WSSectionTests_TableViewCell *)cell).applyItemMehtodCalled, @"Expect item was applyed");
    XCTAssertTrue(sectionAdjustmentCalled == 2, @"Expect two calls to adjustment (heightForRow and cellForRow)");
    XCTAssertTrue(cellAdjustmentCalled == 2, @"Expect two calls to adjustment (heightForRow and cellForRow)");
}

@end
