//
//  WSActionInfoTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 16/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WSActionInfo.h"
#import "WSTableViewCell.h"

@interface WSActionInfoTests : XCTestCase

@end

@implementation WSActionInfoTests

- (void)testDesignatedInitializer {
    WSTableViewCell *cell = [WSTableViewCell new];
    WSCellItem *item = [WSCellItem itemWithClass:[WSTableViewCell class] object:nil];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSDictionary *userInfo = @{};
    WSActionInfo *actionInfo = [[WSActionInfo alloc] initWithView:cell item:item path:path userInfo:userInfo];
    
    XCTAssertTrue(actionInfo.cell == cell, @"Cell property assigned wrong");
    XCTAssertTrue(actionInfo.item == item, @"Item property assigned wrong");
    XCTAssertTrue(actionInfo.path == path, @"Path property assigned wrong");
    XCTAssertTrue(actionInfo.userInfo == userInfo, @"UserInfo property assigned wrong");
    
    XCTAssertTrue([actionInfo cell] == cell, @"Cell method return wrong view");
}

@end
