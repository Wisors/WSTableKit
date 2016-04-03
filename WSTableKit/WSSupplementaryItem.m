//
//  SectionSupplementaryItem.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSupplementaryItem.h"

static CGFloat kSectionDefaultHeight = 22;

@implementation WSSupplementaryItem

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
        _object         = title;
        _customHeight   = height;
    }
    
    return self;
}

- (NSString *)sortKey {
    if (_sortKey) {
        return _sortKey;
    }
    if ([_object isKindOfClass:[NSString class]]) {
        return _object;
    }
    if ([_object conformsToProtocol:@protocol(WSSortable)]) {
        return [(id<WSSortable>)_object sortKey];
    }
    
    return @"";
}

@end