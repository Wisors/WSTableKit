//
//  WSHeaderFooterView.m
//  WSTableKit
//
//  Created by Alex Nikishin on 28/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSHeaderFooterView.h"

@implementation WSHeaderFooterView

#pragma mark - WSCellClass protocol -

- (CGFloat)cellHeight {
    return (_item.customHeight > 0) ? _item.customHeight : [self calculateHeightForAutolayoutCell];
}

- (void)applyItem:(WSSupplementaryItem *)item heightCalculation:(BOOL)heightCalculation {
    NSAssert([item isKindOfClass:[WSSupplementaryItem class]], @"Wrong object passed, expect WSSupplementaryItem");
    self.item = item;
}

- (CGFloat)calculateHeightForAutolayoutCell {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
