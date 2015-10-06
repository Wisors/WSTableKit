//
//  SectionSupplementaryItem.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSSortable.h"

@interface WSSectionSupplementaryItem : NSObject <WSSortable>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIView *customView; // Choosed as preffered.

+ (instancetype)itemWithCustomView:(UIView *)customView;
+ (instancetype)itemWithTitle:(NSString *)text;
+ (instancetype)itemWithTitle:(NSString *)text height:(CGFloat)height;

/**
 *  Use this initializer with default system base section header(footer) and height that provided by tableView. Default height is 22pt.
 *
 *  @param title Supplementary view title.
 *
 *  @return SectionSupplementaryItem instance.
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 *  Use this initializer with default system base section header and custom height.
 *
 *  @param title    Supplementary view title.
 *  @param height   Section header height.
 *
 *  @return SectionSupplementaryItem instance.
 */
- (instancetype)initWithTitle:(NSString *)title height:(CGFloat)height;

/**
 *  Initialize section header item that define UITableView section header(footer) apearance by custom UIView subclass.
 *
 *  @param customView   Some custom UIView.
 *
 *  @return SectionSupplementaryItem instance.
 */
- (instancetype)initWithCustomView:(UIView *)customView;

- (void)setTitle:(NSString *)title height:(CGFloat)height;
- (CGFloat)itemHeight;

@end
