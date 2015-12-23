//
//  TableViewCell.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSCellItem.h"

@interface WSTableViewCell : UITableViewCell<WSCellClass>

@property (nonatomic, strong, readonly) WSCellItem *item;
@property (nonatomic, strong) UIColor *customSeparatorColor;
@property (nonatomic, assign) IBInspectable BOOL hasAutolayout;

- (CGFloat)calculateHeightForAutolayoutCell;

@end

@interface WSTableViewCell(SeparatorsInsets)

@property (nonatomic, assign) UIEdgeInsets topSeparatorInsets;
@property (nonatomic, assign) UIEdgeInsets bottomSeparatorInsets;

/**
 *  Set insets for both separators
 *
 *  @param separatorInsets Separators insets
 */
- (void)setSeparatorsInsets:(UIEdgeInsets)separatorInsets;

/**
 *  Set left offset of both separators
 *
 *  @param leftSeparatorInsets Separators offset
 */
- (void)setLeftSeparatorsOffset:(CGFloat)leftSeparatorsOffset;
/**
 *  Set right offset of both separators
 *
 *  @param leftSeparatorInsets Separator offset
 */
- (void)setRightSeparatorsOffset:(CGFloat)rightSeparatorsOffset;

@end

@interface WSTableViewCell(SeparatorsShowing)

// Both separators is hidden by default
@property (nonatomic, assign) BOOL topSeparatorHidden;
@property (nonatomic, assign) BOOL bottomSeparatorHidden;

- (void)showBothSeparators:(BOOL)show;

@end