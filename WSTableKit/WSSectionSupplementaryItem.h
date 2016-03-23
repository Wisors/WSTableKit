//
//  SectionSupplementaryItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSSortable.h"

@interface WSSectionSupplementaryItem : NSObject <WSSortable>

@property (nonatomic, nullable, readonly) UIView *customView; // Choosed as preffered.
@property (nonatomic, nullable) NSString *title;

+ (nonnull instancetype)itemWithCustomView:(nullable UIView *)customView;
+ (nonnull instancetype)itemWithTitle:(nullable NSString *)text;
+ (nonnull instancetype)itemWithTitle:(nullable NSString *)text height:(CGFloat)height;

/**
 *  Use this initializer with default system base section header(footer) and height that provided by tableView. Default height is 22pt.
 *
 *  @param title Supplementary view title.
 *
 *  @return SectionSupplementaryItem instance.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title;

/**
 *  Use this initializer with default system base section header and custom height.
 *
 *  @param title    Supplementary view title.
 *  @param height   Section header height.
 *
 *  @return SectionSupplementaryItem instance.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title height:(CGFloat)height;

/**
 *  Initialize section header item that define UITableView section header(footer) apearance by custom UIView subclass.
 *
 *  @param customView   Some custom UIView.
 *
 *  @return SectionSupplementaryItem instance.
 */
- (nonnull instancetype)initWithCustomView:(nullable UIView *)customView;

- (void)setTitle:(nullable NSString *)title height:(CGFloat)height;
- (CGFloat)itemHeight;

@end
