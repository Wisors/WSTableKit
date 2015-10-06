//
//  TableViewCell.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSTableViewCell.h"

@interface WSTableViewCell ()

@property (nonatomic, strong) WSCellItem *item;

@property (nonatomic, strong) CALayer *topBorderLayer;
@property (nonatomic, strong) CALayer *bottomBorderLayer;
@property (nonatomic, strong) UIColor *separatorColor;

@end

@implementation WSTableViewCell{
    CGFloat _baseSize;
    UIEdgeInsets _topSeparatorInsets;
    UIEdgeInsets _bottomSeparatorInsets;
}
@synthesize separatorColor = _mySeparatorColor; //UITableViewCell allready has ivar _separatorColor

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
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
    self.topBorderLayer.hidden = self.bottomBorderLayer.hidden = YES;
}

- (void)doInit {
    
    _baseSize = 1 / [UIScreen mainScreen].scale;
    [self setSeparatorsInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
    
    self.topBorderLayer = [[CALayer alloc] init];
    self.topBorderLayer.backgroundColor = self.separatorColor.CGColor;
    self.topBorderLayer.hidden = YES;
    
    self.bottomBorderLayer = [[CALayer alloc] init];
    self.bottomBorderLayer.backgroundColor = self.separatorColor.CGColor;
    self.bottomBorderLayer.hidden = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.layer addSublayer:self.topBorderLayer];
    [self.layer addSublayer:self.bottomBorderLayer];
}

#pragma mark - CellClass protocol -

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (CGFloat)heightWithItem:(WSCellItem *)item {
    return 44; //Default iOS UI
}

- (void)applyItem:(WSCellItem *)item {
    self.item = item;
}

- (CGFloat)calculateHeightForAutolayoutCell {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - Custom setters/getters -

- (void)setSeparatorColor:(UIColor *)separatorColor {
    
    if (_mySeparatorColor != separatorColor) {
        
        _mySeparatorColor = separatorColor;
        if (!self.customSeparatorColor) {
            
            self.topBorderLayer.backgroundColor = separatorColor.CGColor;
            self.bottomBorderLayer.backgroundColor = separatorColor.CGColor;
        }
    }
}

- (void)setCustomSeparatorColor:(UIColor *)customSeparatorColor {
    
    if (_customSeparatorColor != customSeparatorColor) {
        
        _customSeparatorColor = customSeparatorColor;
        self.topBorderLayer.backgroundColor = customSeparatorColor.CGColor;
        self.bottomBorderLayer.backgroundColor = customSeparatorColor.CGColor;
    }
}

#pragma mark - Layout -

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIEdgeInsets topInsets = self.topSeparatorInsets;
    CGFloat topWidth = self.frame.size.width - topInsets.left - topInsets.right;
    self.topBorderLayer.frame = CGRectMake(topInsets.left, topInsets.top, topWidth, _baseSize);
    
    UIEdgeInsets bottomInsets = self.bottomSeparatorInsets;
    CGFloat bottomWidth = self.frame.size.width - bottomInsets.left - bottomInsets.right;
    self.bottomBorderLayer.frame = CGRectMake(bottomInsets.left, self.frame.size.height - _baseSize - bottomInsets.bottom, bottomWidth, _baseSize);
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

@implementation WSTableViewCell (SeparatorsShowing)

- (BOOL)topSeparatorHidden {
    return self.topBorderLayer.hidden;
}

- (void)setTopSeparatorHidden:(BOOL)topSeparatorHidden {
    self.topBorderLayer.hidden = topSeparatorHidden;
}

- (BOOL)bottomSeparatorHidden {
    return self.bottomBorderLayer.hidden;
}

- (void)setBottomSeparatorHidden:(BOOL)bottomSeparatorHidden {
    self.bottomBorderLayer.hidden = bottomSeparatorHidden;
}

- (void)showBothSeparators:(BOOL)show {
    self.topBorderLayer.hidden = self.bottomBorderLayer.hidden = !show;
}

@end