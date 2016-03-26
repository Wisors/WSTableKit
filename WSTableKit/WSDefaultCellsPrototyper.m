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
        NSAssert(convention, @"Convetion is required property");
        _tableView              = tableView;
        _prototypes             = [NSMutableDictionary new];
        _identifierConvention   = convention;
    }
    
    return self;
}

#pragma mark - Cell Registration -

- (void)registerIfNeededCellClass:(Class<WSCellClass>)cellClass {
    NSString *identifier = [_identifierConvention identifierForClass:cellClass];
    if ([_prototypes objectForKey:identifier]) {
        return;
    }
    
    UITableViewCell<WSCellClass> *proto = [_tableView dequeueReusableCellWithIdentifier:identifier]; //Storyboard cell
    if (!proto) {
        [_tableView ws_registerCellClass:cellClass forReuseIdentifier:identifier];
    } else {
        if (![_prototypes objectForKey:identifier]) {
            [_prototypes setObject:proto forKey:identifier];
        }
    }
}

- (void)registerIfNeededCellClasses:(nullable NSSet<WSCellClass> *)cellClasses {
    [cellClasses enumerateObjectsUsingBlock:^(Class<WSCellClass> _Nonnull cellClass, BOOL * _Nonnull stop) {
        [self registerIfNeededCellClass:cellClass];
    }];
}

- (void)registerIfNeededHeaderFooterViewClass:(nonnull Class<WSCellClass>)headerFooterViewClass {
    NSString *identifier = [_identifierConvention identifierForClass:headerFooterViewClass];
    if ([_prototypes objectForKey:identifier]) {
        return;
    }
    
    UITableViewHeaderFooterView<WSCellClass> *proto = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier]; //Storyboard view
    if (!proto) {
        [_tableView ws_registerHeaderFooterClass:headerFooterViewClass forReuseIdentifier:identifier];
    } else {
        if (![_prototypes objectForKey:identifier]) {
            [_prototypes setObject:proto forKey:identifier];
        }
    }
}

#pragma mark - Prototyping -

- (nullable UITableViewHeaderFooterView<WSCellClass> *)headerFooterPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass {
    NSString *identifier = [_identifierConvention identifierForClass:cellClass];
    UITableViewHeaderFooterView<WSCellClass> *proto = [_prototypes objectForKey:identifier];
    if (!proto) {
        proto = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (!proto) {
            [_tableView ws_registerHeaderFooterClass:cellClass forReuseIdentifier:identifier];
            proto = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        }
        NSAssert(proto, @"Some bad things occured. You have mess with cell identifiers and tableview can't create cell");
        [_prototypes setObject:proto forKey:identifier];
    }
    
    return proto;
}

- (nullable UITableViewCell<WSCellClass> *)cellPrototypeForCellClass:(nonnull Class<WSCellClass>)cellClass {
    NSString *identifier = [_identifierConvention identifierForClass:cellClass];
    UITableViewCell<WSCellClass> *proto = [_prototypes objectForKey:identifier];
    if (!proto) {
        proto = [_tableView dequeueReusableCellWithIdentifier:identifier];
        if (!proto) {
            [_tableView ws_registerCellClass:cellClass forReuseIdentifier:identifier];
            proto = [_tableView dequeueReusableCellWithIdentifier:identifier];
        }
        NSAssert(proto, @"Some bad things occured. You have mess with cell identifiers and tableview can't create cell");
        [_prototypes setObject:proto forKey:identifier];
        proto.bounds = CGRectMake(0, 0, _tableView.frame.size.width, proto.frame.size.height);
    }
    
    return proto;
}

@end
