//
//  SectionSupplementaryItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSItem.h"
#import "WSSortable.h"

@interface WSSupplementaryItem : NSObject <WSItem, WSSortable>

@property (nonatomic, assign, nonnull, readonly) Class<WSCellClass> cellClass;
@property (nonatomic, nullable, readonly) id object;
@property (nonatomic, nonnull) NSString *sortKey;
@property (nonatomic, assign) CGFloat customHeight;

+ (nonnull instancetype)itemWithTitle:(nullable NSString *)text;
+ (nonnull instancetype)itemWithTitle:(nullable NSString *)text height:(CGFloat)height;

- (nonnull instancetype)initWithTitle:(nullable NSString *)title;
- (nonnull instancetype)initWithTitle:(nullable NSString *)title height:(CGFloat)height;

@end
