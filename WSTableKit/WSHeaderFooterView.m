//
//  WSHeaderFooterView.m
//  WSTableKit
//
//  Created by Alex Nikishin on 28/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSHeaderFooterView.h"

@implementation WSHeaderFooterView

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if ([self.item.object isKindOfClass:[UIView class]]) {
        [self.item.object removeFromSuperview];
    }
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
}

- (CGFloat)calculateHeightForAutolayoutCell {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
