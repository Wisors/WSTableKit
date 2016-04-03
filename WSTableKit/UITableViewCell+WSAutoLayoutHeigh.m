//
//  UITableViewCell+WSAutoLayoutHeigh.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "UITableViewCell+WSAutoLayoutHeigh.h"

@implementation UITableViewCell (WSAutoLayoutHeigh)

- (CGFloat)calculateHeightForAutolayoutCell {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
