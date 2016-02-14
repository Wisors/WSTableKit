//
//  WSViewController.m
//  WSTableKit
//
//  Created by Alex Nikishin on 09/29/2015.
//  Copyright (c) 2015 Alex Nikishin. All rights reserved.
//

#import "WSViewController.h"

#import "CellWithButton.h"
#import "WSTableKit.h"

@interface WSViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) WSSection *section;

@end

@implementation WSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WSAction *action = [WSAction actionWithKey:WSButtonClickedActionKey shortActionBlock:^(WSTableViewCell *cell) {
        NSLog(@"Button pressed");
    }];
    
    NSArray *cells = [WSCellItem cellItemsWithClass:[CellWithButton class] objects:@[@"One", @"Two", @"Three"] customActions:@[action]];
    self.section = [WSSection sectionWithItems:cells adjustmentBlock:^(WSTableViewCell *cell, WSCellItem *item, NSIndexPath *path) {
        cell.textLabel.text = item.object;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.bottomSeparatorHidden = cell.topSeparatorHidden = NO;
        cell.bottomSeparatorInsets = UIEdgeInsetsMake(0, 4, 1, 5);
        cell.topSeparatorInsets = UIEdgeInsetsMake(1, 4, 0, 5);
    }];

    WSCellItem *item = [[[WSCellItem itemWithCellClass:[CellWithButton class] object:@"one"]
    addAction:WSActionSelect actionBlock:^(WSTableViewCell *cell) {
        
    }]
    addAction:WSActionDeselect actionBlock:^(WSTableViewCell *cell) {
        
    }];
    
    self.tableView.dataSource = self.section;
    self.tableView.delegate = self.section;
    self.tableView.sectionFooterHeight = self.tableView.sectionHeaderHeight = 0;
}

@end
