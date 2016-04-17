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

- (void)ws_registerCellClass:(nonnull Class)cellClass forReuseIdentifier:(nonnull NSString *)identifier {
    NSBundle *bundle = [NSBundle bundleForClass:cellClass];
    NSString *className = NSStringFromClass(cellClass);
    if ([bundle pathForResource:className ofType:@"nib"] != nil) {
        [self registerNib:[UINib nibWithNibName:className bundle:bundle] forCellReuseIdentifier:identifier]; // Xib cell
    } else {
        [self registerClass:cellClass forCellReuseIdentifier:identifier]; // Code generated cell
    }
}

- (void)ws_registerHeaderFooterClass:(nonnull Class)headerFooterClass forReuseIdentifier:(nonnull NSString *)identifier {
    NSBundle *bundle = [NSBundle bundleForClass:headerFooterClass];
    NSString *className = NSStringFromClass(headerFooterClass);
    if ([bundle pathForResource:className ofType:@"nib"] != nil) {
        [self registerNib:[UINib nibWithNibName:className bundle:bundle] forHeaderFooterViewReuseIdentifier:identifier]; // Xib cell
    } else {
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:identifier]; // Code generated cell
    }
}

@end
