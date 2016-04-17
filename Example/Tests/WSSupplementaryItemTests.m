//
//  WSSupplementaryItemTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 17/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WSHeaderFooterView.h"
#import "WSSupplementaryItem.h"

@interface MocSortable : NSObject<WSSortable>

@property (strong, nonatomic) NSString *key;

@end

@implementation MocSortable

- (NSString *)sortKey {
    return _key;
}

@end

@interface WSSupplementaryItemTests : XCTestCase

@end

@implementation WSSupplementaryItemTests

- (void)testDesignatedInitializer {
    NSString *object = @"Test";
    WSAction *action = [WSAction actionWithType:WSActionClick actionBlock:nil];
    WSSupplementaryItem *item = [[WSSupplementaryItem alloc] initWithHeaderFooterClass:[WSHeaderFooterView class] object:object actions:@[action] height:44];
    
    XCTAssertNotNil(item, @"Expect item");
    XCTAssertEqual(44, item.customHeight, @"Expect inited height");
    XCTAssertTrue([item.object isEqual:object], @"Expect same object from initializer");
    XCTAssertEqual(item.viewClass, [WSHeaderFooterView class], @"Expect class from initializer");
    XCTAssertEqual([item.actionsHolder actionForType:WSActionClick], action, @"Expect click action");
}

- (void)testTextInitializers {
    WSSupplementaryItem *item1 = [WSSupplementaryItem itemWithTitle:@"Title"];
    XCTAssertTrue([item1.object isEqualToString:@"Title"], @"Wrong object value");
    XCTAssertEqual(item1.customHeight, kSectionDefaultHeight, @"Wrong header height");
    
    WSSupplementaryItem *item2 = [WSSupplementaryItem itemWithTitle:@"Title" height:50];
    XCTAssertTrue([item2.object isEqualToString:@"Title"], @"Wrong object value");
    XCTAssertEqual(item2.customHeight, 50, @"Wrong header height");
}

- (void)testSortKey {
    NSString *object = @"Test";
    WSSupplementaryItem *item = [[WSSupplementaryItem alloc] initWithHeaderFooterClass:[WSHeaderFooterView class] object:object actions:nil height:44];
    XCTAssertTrue([[item sortKey] isEqualToString:@"Test"], @"Expect passed string as sorted key");
    
    MocSortable *moc = [MocSortable new];
    moc.key = @"MocKey";
    WSSupplementaryItem *objectItem = [WSSupplementaryItem itemWithClass:[WSHeaderFooterView class] object:moc];
    XCTAssertTrue([[objectItem sortKey] isEqualToString:@"MocKey"], @"Expect protocol object -sortKey as sorted key");
    
    item.sortKey = @"ManualKey";
    objectItem.sortKey = @"ManualKey";
    XCTAssertTrue([[item sortKey] isEqualToString:@"ManualKey"], @"Expect manual key as preffered");
    XCTAssertTrue([[objectItem sortKey] isEqualToString:@"ManualKey"], @"Expect manual key as preffered");
}

- (void)testSetClickBlock {
    WSSupplementaryItem *item = [WSSupplementaryItem itemWithTitle:@"Test"];
    XCTAssertNil([item.actionsHolder actionForType:WSActionClick], @"Expect absence of action");
    [item setClickBlock:^(UITableViewHeaderFooterView<WSCellClass> * _Nonnull headerFooter, WSSupplementaryItem * _Nonnull item) {}];
    XCTAssertNotNil([item.actionsHolder actionForType:WSActionClick], @"Expect click action");
    [item setClickBlock:nil];
    XCTAssertNil([item.actionsHolder actionForType:WSActionClick], @"Expect absence of action");
}

@end
