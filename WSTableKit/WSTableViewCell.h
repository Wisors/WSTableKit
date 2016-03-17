//
//  TableViewCell.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WSCellItem.h"

@interface WSTableViewCell : UITableViewCell<WSCellClass>

@property (nonatomic, readonly, nullable) WSCellItem *item;
@property (nonatomic, assign) IBInspectable BOOL hasAutolayout; //Define the behavior of default implementation -cellHeigh method. Return default 44pt size or use autolayout.

/**
 *  Caclulate cell height using autolayot.
 *
 *  @return Cell height.
 */
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

@interface WSTableViewCell(SeparatorsAppearance)

// Both separators is hidden by default
@property (nonatomic, nonnull) UIColor *customSeparatorsColor; //As default behavior UITableView set separator color to cell. This property allow to ovveride color with per cell basis.
@property (nonatomic, assign) BOOL topSeparatorHidden;
@property (nonatomic, assign) BOOL bottomSeparatorHidden;

- (void)showBothSeparators:(BOOL)show;

@end