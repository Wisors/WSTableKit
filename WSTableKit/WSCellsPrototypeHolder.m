//
//  WSCellsPrototypeHolder.m
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSCellsPrototypeHolder.h"

@interface WSCellsPrototypeHolder()

@property (nonatomic) UITableView *tableView;

@end

@implementation WSCellsPrototypeHolder {
    NSMutableDictionary *_prototypes;
}

- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView {
    if ((self = [super init])) {
        _tableView = tableView;
        _prototypes = [NSMutableDictionary new];
    }
    
    return self;
}

- (nullable UITableViewHeaderFooterView<WSCellClass> *)headerFooterPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass {
    NSString *identifier = ws_className(cellClass);
    UITableViewHeaderFooterView<WSCellClass> *proto = [_prototypes objectForKey:identifier];
    if (!proto) {
        proto = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (proto) {
            [_prototypes setObject:proto forKey:identifier];
        }
    }
    
    return proto;
}

- (nullable UITableViewCell<WSCellClass> *)cellPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass {
    NSString *identifier = ws_className(cellClass);
    UITableViewCell<WSCellClass> *proto = [_prototypes objectForKey:identifier];
    if (!proto) {
        proto = [_tableView dequeueReusableCellWithIdentifier:identifier];
        proto.bounds = CGRectMake(0, 0, _tableView.frame.size.width, proto.frame.size.height);
        if (proto) {
            [_prototypes setObject:proto forKey:identifier];
        }
    }
    
    return proto;
}

@end
