//
//  SectionSupplementaryItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellItem.h"
#import "WSSortable.h"

@class WSSupplementaryItem;

typedef void (^WSSupplementaryClickBlock)(UITableViewHeaderFooterView<WSCellClass> * _Nonnull headerFooter, WSSupplementaryItem * _Nonnull item);

@interface WSSupplementaryItem : WSCellItem<WSSortable>

@property (nonatomic, nonnull) NSString *sortKey;
@property (nonatomic, assign) CGFloat customHeight;

+ (nonnull instancetype)itemWithTitle:(nullable NSString *)text;
+ (nonnull instancetype)itemWithTitle:(nullable NSString *)text height:(CGFloat)height;

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                               height:(CGFloat)height;

+ (nonnull instancetype)itemWithClass:(nonnull Class)viewClass
                               object:(nullable id)object
                              actions:(nullable NSArray<WSAction *> *)actions
                               height:(CGFloat)height;

- (nonnull instancetype)initWithHeaderFooterClass:(nonnull Class)headerFooterClass
                                           object:(nullable id)object
                                          actions:(nullable NSArray<WSAction *> *)actions
                                           height:(CGFloat)height;

- (nonnull instancetype)setClickBlock:(nullable WSSupplementaryClickBlock)block;

@end
