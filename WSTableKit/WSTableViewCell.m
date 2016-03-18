//
//  TableViewCell.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSTableViewCell.h"

@interface WSTableViewCell ()

@property (nonatomic) WSCellItem *item;

@end

@implementation WSTableViewCell{
    UIColor *_customSeparatorsColor;
    CALayer *_topBorderLayer;
    CALayer *_bottomBorderLayer;
    CGFloat _baseSize;
    UIEdgeInsets _topSeparatorInsets;
    UIEdgeInsets _bottomSeparatorInsets;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self doInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self doInit];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    //separators are hidden by default
    _topBorderLayer.hidden = _bottomBorderLayer.hidden = YES;
    [self setSeparatorsInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
}

- (void)doInit {
    _baseSize = 1 / [UIScreen mainScreen].scale;
    [self setSeparatorsInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    _topBorderLayer = [[CALayer alloc] init];
    _topBorderLayer.hidden = YES;
    
    _bottomBorderLayer = [[CALayer alloc] init];
    _bottomBorderLayer.hidden = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.layer addSublayer:_topBorderLayer];
    [self.layer addSublayer:_bottomBorderLayer];
}

#pragma mark - CellClass protocol -

+ (nonnull NSString *)cellIdentifier {
    return [[NSStringFromClass([self class]) componentsSeparatedByString:@"."] lastObject];
}

- (CGFloat)cellHeight {
    return (_hasAutolayout) ? [self calculateHeightForAutolayoutCell] : 44; // Autolayout or default table cell size.
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

#pragma mark - Layout -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets topInsets = self.topSeparatorInsets;
    CGFloat topWidth = self.frame.size.width - topInsets.left - topInsets.right;
    _topBorderLayer.frame = CGRectMake(topInsets.left, topInsets.top, topWidth, _baseSize);
    
    UIEdgeInsets bottomInsets = self.bottomSeparatorInsets;
    CGFloat bottomWidth = self.frame.size.width - bottomInsets.left - bottomInsets.right;
    _bottomBorderLayer.frame = CGRectMake(bottomInsets.left, self.frame.size.height - _baseSize - bottomInsets.bottom, bottomWidth, _baseSize);
}

@end

@implementation WSTableViewCell(SeparatorsInsets)

- (void)setTopSeparatorInsets:(UIEdgeInsets)topSeparatorInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_topSeparatorInsets, topSeparatorInsets)) {
        _topSeparatorInsets = topSeparatorInsets;
        [self setNeedsLayout];
    }
}

- (UIEdgeInsets)topSeparatorInsets {
    return _topSeparatorInsets;
}

- (void)setBottomSeparatorInsets:(UIEdgeInsets)bottomSeparatorInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_bottomSeparatorInsets, bottomSeparatorInsets)) {
        _bottomSeparatorInsets = bottomSeparatorInsets;
        [self setNeedsLayout];
    }
}

- (UIEdgeInsets)bottomSeparatorInsets {
    return _bottomSeparatorInsets;
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    [self setSeparatorsInsets:separatorInset];
}

- (void)setSeparatorsInsets:(UIEdgeInsets)separatorInsets {
    
    [self setTopSeparatorInsets:separatorInsets];
    [self setBottomSeparatorInsets:separatorInsets];
}

- (void)setLeftSeparatorsOffset:(CGFloat)leftSeparatorsOffset {
    UIEdgeInsets topInsets = UIEdgeInsetsMake(_topSeparatorInsets.top, leftSeparatorsOffset, _topSeparatorInsets.bottom, _topSeparatorInsets.right);
    UIEdgeInsets bottomInsets = UIEdgeInsetsMake(_bottomSeparatorInsets.top, leftSeparatorsOffset, _bottomSeparatorInsets.bottom, _bottomSeparatorInsets.right);
    [self setTopSeparatorInsets:topInsets];
    [self setBottomSeparatorInsets:bottomInsets];
}

- (void)setRightSeparatorsOffset:(CGFloat)rightSeparatorsOffset {
    UIEdgeInsets topInsets = UIEdgeInsetsMake(_topSeparatorInsets.top, _topSeparatorInsets.left, _topSeparatorInsets.bottom, rightSeparatorsOffset);
    UIEdgeInsets bottomInsets = UIEdgeInsetsMake(_bottomSeparatorInsets.top, _bottomSeparatorInsets.left, _bottomSeparatorInsets.bottom,rightSeparatorsOffset);
    [self setTopSeparatorInsets:topInsets];
    [self setBottomSeparatorInsets:bottomInsets];
}

@end

@implementation WSTableViewCell (SeparatorsAppearance)

#pragma mark - Custom setters/getters -

// UITableView set separator color during cell initialization process
- (void)setSeparatorColor:(UIColor *)separatorColor {
    if (!self.customSeparatorsColor) {
        _topBorderLayer.backgroundColor = separatorColor.CGColor;
        _bottomBorderLayer.backgroundColor = separatorColor.CGColor;
    }
}

- (UIColor *)customSeparatorsColor {
    return _customSeparatorsColor;
}

- (void)setCustomSeparatorsColor:(UIColor *)customSeparatorsColor {
    if (_customSeparatorsColor != customSeparatorsColor) {
        _customSeparatorsColor = customSeparatorsColor;
        _topBorderLayer.backgroundColor = customSeparatorsColor.CGColor;
        _bottomBorderLayer.backgroundColor = customSeparatorsColor.CGColor;
    }
}

- (BOOL)topSeparatorHidden {
    return _topBorderLayer.hidden;
}

- (void)setTopSeparatorHidden:(BOOL)topSeparatorHidden {
    _topBorderLayer.hidden = topSeparatorHidden;
}

- (BOOL)bottomSeparatorHidden {
    return _bottomBorderLayer.hidden;
}

- (void)setBottomSeparatorHidden:(BOOL)bottomSeparatorHidden {
    _bottomBorderLayer.hidden = bottomSeparatorHidden;
}

- (void)showBothSeparators:(BOOL)show {
    _topBorderLayer.hidden = _bottomBorderLayer.hidden = !show;
}

@end