//
//  WSHeaderFooterView.m
//  WSTableKit
//
//  Created by Alex Nikishin on 28/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSHeaderFooterView.h"

@interface WSHeaderFooterView()

@property (nonatomic) UITapGestureRecognizer *clickRecognizer;

@end

@implementation WSHeaderFooterView

#pragma mark - Click action -

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        [self ws_doInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self ws_doInit];
    }
    
    return self;
}

- (void)ws_doInit {
    _clickRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ws_headerClicked:)];
}

- (void)ws_headerClicked:(id)sender {
    WSAction *action = [self.item.actionsHolder actionForType:WSActionClick];
    [action invokeActionWithInfo:[WSActionInfo actionInfoWithView:self item:self.item path:nil userInfo:nil]];
}

#pragma mark - WSCellClass protocol -

- (CGFloat)cellHeight {
    return (self.item.customHeight > 0) ? self.item.customHeight : [self calculateHeightForAutolayoutCell];
}

- (void)applyItem:(WSSupplementaryItem *)item heightCalculation:(BOOL)heightCalculation {
    NSAssert([item isKindOfClass:[WSSupplementaryItem class]], @"Wrong object passed, expect WSSupplementaryItem");
    self.item = item;
    
    if ([self.item.object isKindOfClass:[NSString class]]) {
        self.textLabel.text = self.item.object;
    } else if ([self.item.object isKindOfClass:[UIView class]]) {
        UIView *view = (UIView *)self.item.object;
        view.translatesAutoresizingMaskIntoConstraints = false;
        [view removeFromSuperview];
        [self.contentView addSubview:view];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:@{@"view" : view}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view" : view}]];
    }
    self.clickRecognizer.enabled = ([self.item.actionsHolder actionForType:WSActionClick]) ? YES : NO;
}

- (CGFloat)calculateHeightForAutolayoutCell {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
