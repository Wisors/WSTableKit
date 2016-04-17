//
//  UITableViewExtensionsTests.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 17/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CellWithButton.h"
#import "UITableView+WSTableExtension.h"
#import "WSTestXibTableViewCell.h"
#import "WSTestNibHeaderFooterView.h"
#import "WSTestClassHeaderFooterView.h"

@interface UITableViewExtensionsTests : XCTestCase

@end

@implementation UITableViewExtensionsTests

- (void)testRegisterCellClass {
    UITableView *tableView = [UITableView new];
    
    XCTAssertNil([tableView dequeueReusableCellWithIdentifier:@"WSTestXibTableViewCell"], @"Expect nil, cell is not registred yet");
    [tableView ws_registerCellClass:[WSTestXibTableViewCell class] forReuseIdentifier:@"WSTestXibTableViewCell"];
    XCTAssertNotNil([tableView dequeueReusableCellWithIdentifier:@"WSTestXibTableViewCell"], @"Cell must be registred now");
    WSTestXibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WSTestXibTableViewCell"];
    XCTAssertNotNil(cell.titleLabel, @"Cell outlet is nil, possible initialization through class, not nib");
    
    XCTAssertNil([tableView dequeueReusableCellWithIdentifier:@"CellWithButton"], @"Expect nil, cell is not registred yet");
    [tableView ws_registerCellClass:[CellWithButton class] forReuseIdentifier:@"cell"];
    XCTAssertNotNil([tableView dequeueReusableCellWithIdentifier:@"cell"], @"Cell must be registred now");
    CellWithButton *secondCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    XCTAssertNotNil(secondCell.button, @"Button is not created");
}

- (void)testRegisterHeaderFooterClass {
    UITableView *tableView = [UITableView new];
    
    XCTAssertNil([tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"], @"Expect nil, header is not registred yet");
    [tableView ws_registerHeaderFooterClass:[WSTestClassHeaderFooterView class] forReuseIdentifier:@"header"];
    XCTAssertNotNil([tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"], @"Header must be registred now");
    WSTestClassHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    XCTAssertNotNil(header.titleLabel, @"Header have to be initialized with title lable");
    
    XCTAssertNil([tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerNib"], @"Expect nil, header is not registred yet");
    [tableView ws_registerHeaderFooterClass:[WSTestNibHeaderFooterView class] forReuseIdentifier:@"headerNib"];
    XCTAssertNotNil([tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerNib"], @"Expect header, it is registred now");
    WSTestNibHeaderFooterView *headerNib = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerNib"];
    XCTAssertNotNil(headerNib.titleLabel, @"Expect title label");
}

@end
