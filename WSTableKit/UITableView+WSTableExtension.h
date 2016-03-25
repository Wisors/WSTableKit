//
//  UITableView+WSTableExtension.h
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline  NSString * _Nonnull  ws_className(_Nonnull Class classObject) {
    return [[NSStringFromClass(classObject) componentsSeparatedByString:@"."] lastObject]; //For Swift Modules compatibility
}

@interface UITableView (WSTableExtension)

- (void)ws_registerCellClass:(nonnull Class)cellClass;
- (void)ws_registerCellClasses:(nullable NSSet<Class> *)cellClasses;
- (void)ws_registerHeaderFooterClass:(nonnull Class)headerFooterClass;

@end
