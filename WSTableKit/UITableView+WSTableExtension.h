//
//  UITableView+WSTableExtension.h
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (WSTableExtension)

- (void)ws_registerCellClass:(nonnull Class)cellClass forReuseIdentifier:(nonnull NSString *)identifier;
- (void)ws_registerHeaderFooterClass:(nonnull Class)headerFooterClass forReuseIdentifier:(nonnull NSString *)identifier;

@end
