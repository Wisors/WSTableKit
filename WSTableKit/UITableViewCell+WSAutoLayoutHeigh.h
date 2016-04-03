//
//  UITableViewCell+WSAutoLayoutHeigh.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (WSAutoLayoutHeigh)

/**
 *  Caclulate cell height using autolayot.
 *
 *  @return Cell height.
 */
- (CGFloat)calculateHeightForAutolayoutCell;

@end
