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
    return (_hasAutolayout) ? [self calculateHeightForAutolayoutCell] : 22; // Autolayout or default table cell size.
}

- (void)applyItem:(WSCellItem *)item heightCalculation:(BOOL)heightCalculation {
    self.item = item;
}

- (CGFloat)calculateHeightForAutolayoutCell {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
