//
//  SectionSupplementaryItem.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSectionSupplementaryItem.h"

static CGFloat kSectionDefaultHeight = 22;

@interface WSSectionSupplementaryItem()

@property (nonatomic, assign) CGFloat customHeight;

@end

@implementation WSSectionSupplementaryItem

+ (instancetype)itemWithCustomView:(UIView *)customView {
    return [[self alloc] initWithCustomView:customView];
}

+ (instancetype)itemWithTitle:(NSString *)text {
    return [[self alloc] initWithTitle:text height:kSectionDefaultHeight];
}

+ (instancetype)itemWithTitle:(NSString *)text height:(CGFloat)height {
    return [[self alloc] initWithTitle:text height:height];
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title height:kSectionDefaultHeight];
}

- (instancetype)initWithTitle:(NSString *)title height:(CGFloat)height {
    if ((self = [super init])) {
        _title          = title;
        _customHeight   = height;
    }
    
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView {
    if ((self = [super init])) {
        _customView = customView;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        _title = title;
        _customHeight = kSectionDefaultHeight;
        _customView = nil;
    }
}

- (void)setTitle:(NSString *)title height:(CGFloat)height {
    [self setTitle:title];
    _customHeight = height;
}

- (void)setCustomView:(UIView *)customView {
    if (_customView != customView) {
        _customView = customView;
        _title = nil;
        _customHeight = kSectionDefaultHeight;
    }
}

- (NSString *)sortKey {
    
    if (self.title) {
        return self.title;
    }
    if ([self.customView conformsToProtocol:@protocol(WSSortable)]) {
        return [(id<WSSortable>)self.customView sortKey];
    }
    
    return @"";
}

- (CGFloat)itemHeight {
    if (self.customView) {
        return self.customView.frame.size.height;
    } else {
        return self.customHeight;
    }
}

@end