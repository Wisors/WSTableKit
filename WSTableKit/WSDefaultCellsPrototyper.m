//
//  WSCellsPrototypeHolder.m
//  WSTableKit
//
//  Created by Alex Nikishin on 23/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSDefaultCellsPrototyper.h"
#import "UITableView+WSTableExtension.h"

@interface WSDefaultCellsPrototyper()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) id<WSIdentifierConvention> identifierConvention;

@end

@implementation WSDefaultCellsPrototyper {
    NSMutableDictionary *_prototypes;
}

- (nonnull instancetype)initWithTableView:(nonnull UITableView *)tableView identifierConvention:(nonnull id<WSIdentifierConvention>)convention {
    if ((self = [super init])) {
        _tableView              = tableView;
        _prototypes             = [NSMutableDictionary new];
        _identifierConvention   = convention;
    }
    
    return self;
}

- (void)registerIfNeededCellClass:(Class<WSCellClass>)cellClass {
    
}

- (nullable UITableViewHeaderFooterView<WSCellClass> *)headerFooterPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass {
    NSString *identifier = [_identifierConvention identifierForClass:cellClass];
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
    NSString *identifier = [_identifierConvention identifierForClass:cellClass];
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
