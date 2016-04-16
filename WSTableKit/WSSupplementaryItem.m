//
//  SectionSupplementaryItem.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSupplementaryItem.h"
#import "WSHeaderFooterView.h"

static CGFloat kSectionDefaultHeight = 22;

@implementation WSSupplementaryItem

+ (instancetype)itemWithTitle:(NSString *)text {
    return [[self alloc] initWithHeaderFooterClass:[WSHeaderFooterView class] object:text actions:nil height:kSectionDefaultHeight];
}

+ (instancetype)itemWithTitle:(NSString *)text height:(CGFloat)height {
    return [[self alloc] initWithHeaderFooterClass:[WSHeaderFooterView class] object:text actions:nil height:height];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                               height:(CGFloat)height {
    return [[self alloc] initWithHeaderFooterClass:viewClass object:object actions:nil height:height];
}

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                              actions:(nullable NSArray<WSAction *> *)actions
                               height:(CGFloat)height {
    return [[self alloc] initWithHeaderFooterClass:viewClass object:object actions:actions height:height];
}

- (nonnull instancetype)initWithHeaderFooterClass:(nonnull Class)headerFooterClass
                                           object:(nullable id)object
                                          actions:(nullable NSArray<WSAction *> *)actions
                                           height:(CGFloat)height {
    if (self = [super initWithViewClass:headerFooterClass object:object actions:actions adjustment:nil]) {
        _customHeight = height;
    }
    
    return self;
}

- (nonnull instancetype)setClickBlock:(WSSupplementaryClickBlock)block {
    if (!block) {
        return self;
    }
    __weak __typeof(self) weakSelf = self;
    [self.actionsHolder addAction:[WSAction actionWithType:WSActionClick actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        if (block) {
            block(actionInfo.headerFooter, weakSelf);
        }
    }]];
    
    return self;
}

- (NSString *)sortKey {
    if (_sortKey) {
        return _sortKey;
    }
    if ([self.object isKindOfClass:[NSString class]]) {
        return self.object;
    }
    if ([self.object conformsToProtocol:@protocol(WSSortable)]) {
        return [self.object sortKey];
    }
    
    return @"";
}

@end