//
//  WSViewController.m
//  WSTableKit
//
//  Created by Alex Nikishin on 09/29/2015.
//  Copyright (c) 2015 Alex Nikishin. All rights reserved.
//

#import "WSViewController.h"

#import "CellWithButton.h"
#import "WSHeaderFooterView.h"
#import "WSSectionContainer.h"

@interface WSViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WSSectionContainer *sections;

@end

@implementation WSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSAction *action = [WSAction actionWithKey:WSButtonClickedActionKey actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Button pressed");
    }];
    
    NSArray *cells = [WSCellItem itemsWithClass:[CellWithButton class] objects:@[@"One", @"Two", @"Three"] customActions:@[action]];

    WSSection *section = [[WSSection sectionWithItems:cells tableView:self.tableView] setAdjustmentBlock:^(CellWithButton *cell, WSCellItem * _Nonnull item, NSIndexPath * _Nonnull path) {
        cell.textLabel.text = item.object;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.bottomSeparatorHidden = cell.topSeparatorHidden = NO;
        cell.bottomSeparatorInsets = UIEdgeInsetsMake(0, 4, 1, 5);
        cell.topSeparatorInsets = UIEdgeInsetsMake(1, 4, 0, 5);
    }];
    section.sectionHeader = [WSSupplementaryItem itemWithTitle:@"Test" height:22];
    UILabel *label = [UILabel new];
    label.text = @"Footer";
    section.sectionFooter = [WSSupplementaryItem itemWithClass:[WSHeaderFooterView class] object:label height:40];
    [[section itemAtIndex:0] addAction:[WSAction actionWithType:WSActionWillDisplay actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        actionInfo.cell.contentView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:3.f animations:^{
            actionInfo.cell.contentView.backgroundColor = [UIColor blueColor];
        }];
    }]];
    [[section itemAtIndex:1] addAction:[WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Cell clicked");
    }]];
    [[section itemAtIndex:1] addAction:[WSAction actionWithType:WSActionWillSelect returnValueBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Cell will selected");
        return actionInfo.path;
    }]];
    [[section itemAtIndex:2] addAction:[WSAction actionWithType:WSActionSelect returnValueBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Cell selected");
        return actionInfo.path;
    }]];
    
    self.sections = [WSSectionContainer containerWithSections:@[section] tableView:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

@end
