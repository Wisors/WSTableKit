//
//  SectionContainer.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSSection.h"

@interface WSSectionContainer : NSObject <WSTableViewDirector>

@property (nonatomic, assign) BOOL enableAlphabet;

+ (nonnull instancetype)containerWithSections:(nullable NSArray<WSSection *> *)sections tableView:(nullable UITableView *)tableView;
+ (nonnull instancetype)containerWithSections:(nullable NSArray<WSSection *> *)sections
                                    tableView:(nullable UITableView *)tableView
                              adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;
+ (nonnull instancetype)containerWithSections:(nullable NSArray<WSSection *> *)sections
                                    tableView:(nullable UITableView *)tableView
                               scrollDelegate:(nullable id<UIScrollViewDelegate>)scrollDelegate;

- (nonnull instancetype)initWithTableView:(nullable UITableView *)tableView;
- (nonnull instancetype)initWithSection:(nonnull WSSection *)section tableView:(nullable UITableView *)tableView;
- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections tableView:(nullable UITableView *)tableView;
- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections
                               tableView:(nullable UITableView *)tableView
                         adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;
- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections
                               tableView:(nullable UITableView *)tableView
                          scrollDelegate:(nullable id<UIScrollViewDelegate>)scrollDelegate;

- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections
                               tableView:(nullable UITableView *)tableView
                         adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock
                          scrollDelegate:(nullable id<UIScrollViewDelegate>)scrollDelegate NS_DESIGNATED_INITIALIZER;

// Xcode autocomplete helpers
- (nonnull instancetype)setAdjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock;

@end

@interface WSSectionContainer(SectionAccess)

/**
 *  Add section at the end of container.
 *
 *  @param section Section to insert.
 */
- (void)addSection:(nullable WSSection *)section;
/**
 *  Add section at specific index. If index is already occupied, the objects at index and beyond are shifted by adding 1 to their indices to make room.
 *
 *  @param section Section to insert.
 *  @param index Section index.
 */
- (void)addSection:(nullable WSSection *)section atIndex:(NSInteger)index;

- (void)replaceSectionAtIndex:(NSInteger)index withSection:(nonnull WSSection *)section;
- (void)updateSectionAtIndex:(NSInteger)index withItems:(nonnull NSArray<WSCellItem *> *)items;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (nullable WSSection *)sectionAtIndex:(NSInteger)index;
- (nullable WSCellItem *)itemAtIndexPath:(nonnull NSIndexPath *)path;
- (void)enumerateObjectsUsingBlock:(nullable void (^)(WSSection * _Nonnull section, NSUInteger idx, BOOL * _Nullable stop))block;
- (NSInteger)indexOfSection:(nonnull WSSection *)item;

- (void)removeSectionAtIndex:(NSInteger)index;
- (void)removeAllSections;

@end

@interface WSSectionContainer(AlphabetBuilder)

- (nonnull instancetype)initWithTableView:(nullable UITableView *)tableView
                          sortableObjects:(nonnull NSArray *)sortableObjects
                     andCellItemInitBlock:(nonnull WSCellItem * _Nonnull (^)(id _Nullable object))itemBlock;

@end
