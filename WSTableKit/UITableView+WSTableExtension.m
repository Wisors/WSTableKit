//
//  UITableView+WSTableExtension.m
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UITableView+WSTableExtension.h"

@implementation UITableView (WSTableExtension)

- (void)ws_registerCellClass:(nonnull Class)cellClass {
    NSString *identifier = ws_className(cellClass);
    NSBundle *bundle = [NSBundle bundleForClass:cellClass];
    if ([bundle pathForResource:identifier ofType:@"nib"] != nil) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:identifier]; // Xib cell
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:identifier]; // Code generated cell
    }
}

- (void)ws_registerCellClasses:(nullable NSSet<Class> *)cellClasses {
    [cellClasses enumerateObjectsUsingBlock:^(Class  _Nonnull cellClass, BOOL * _Nonnull stop) {
        [self ws_registerCellClass:cellClass];
    }];
}

- (void)ws_registerHeaderFooterClass:(nonnull Class)headerFooterClass {
    NSString *identifier = ws_className(headerFooterClass);
    NSBundle *bundle = [NSBundle bundleForClass:headerFooterClass];
    if ([bundle pathForResource:identifier ofType:@"nib"] != nil) {
        [self registerNib:[UINib nibWithNibName:identifier bundle:bundle] forHeaderFooterViewReuseIdentifier:identifier]; // Xib cell
    } else {
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:identifier]; // Code generated cell
    }
}

@end
