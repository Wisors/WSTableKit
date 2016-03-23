//
//  WSViewController.m
//  WSTableKit
//
//  Created by Alex Nikishin on 09/29/2015.
//  Copyright (c) 2015 Alex Nikishin. All rights reserved.
//

#import "WSViewController.h"

#import "CellWithButton.h"
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
    
    NSArray *cells = [WSCellItem cellItemsWithClass:[CellWithButton class] objects:@[@"One", @"Two", @"Three"] customActions:@[action]];

    WSSection *section = [[WSSection sectionWithItems:cells tableView:self.tableView] setAdjustmentBlock:^(CellWithButton *cell, WSCellItem * _Nonnull item, NSIndexPath * _Nonnull path) {
        cell.textLabel.text = item.object;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.bottomSeparatorHidden = cell.topSeparatorHidden = NO;
        cell.bottomSeparatorInsets = UIEdgeInsetsMake(0, 4, 1, 5);
        cell.topSeparatorInsets = UIEdgeInsetsMake(1, 4, 0, 5);
    }];
//    section.sectionHeader = [WSSectionSupplementaryItem itemWithTitle:@"Some title"];
    [[section itemAtIndex:0] addAction:WSActionWillDisplay actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        actionInfo.cell.contentView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:3.f animations:^{
            actionInfo.cell.contentView.backgroundColor = [UIColor blueColor];
        }];
    }];
    [[section itemAtIndex:1] addAction:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Cell clicked");
    }];
    [[section itemAtIndex:1] addAction:WSActionWillSelect returnValueBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Cell will selected");
        return actionInfo.path;
    }];
    [[section itemAtIndex:2] addAction:WSActionSelect returnValueBlock:^(WSActionInfo * _Nonnull actionInfo) {
        NSLog(@"Cell selected");
        return actionInfo.path;
    }];
    
    self.sections = [WSSectionContainer containerWithSections:@[section] tableView:self.tableView];
}

@end
