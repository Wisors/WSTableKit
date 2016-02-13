//
//  SectionContainer.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSTableViewDirector.h"

@class WSSection;

@interface WSSectionContainer : NSObject <WSTableViewDirector>

@property (nonatomic, assign) BOOL enableAlphabet;

+ (instancetype)containerWithSections:(NSArray *)sestions;
+ (instancetype)containerWithSections:(NSArray *)sections adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;
+ (instancetype)containerWithSections:(NSArray *)sections scrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate;


- (instancetype)initWithSection:(WSSection *)section;
- (instancetype)initWithSections:(NSArray *)sections;
- (instancetype)initWithSections:(NSArray *)sections adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock;
- (instancetype)initWithSections:(NSArray *)sections scrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate;

- (void)setAdjustmentBlock:(WSCellAdjustmentBlock)cellAdjustmentBlock;
- (void)setDisplayBlock:(WSCellDisplayBlock)displayBlock;
- (void)setEventBlock:(WSCellEventBlock)eventBlock;

@end

@interface WSSectionContainer(SectionAccess)

/**
 *  Add section at the end of container.
 *
 *  @param section Section to insert.
 */
- (void)addSection:(WSSection *)section;
/**
 *  Add section at specific index. If index is already occupied, the objects at index and beyond are shifted by adding 1 to their indices to make room.
 *
 *  @param section Section to insert.
 *  @param index Section index.
 */
- (void)addSection:(WSSection *)section atIndex:(NSInteger)index;

- (void)replaceSectionAtIndex:(NSInteger)index withSection:(WSSection *)section;
- (void)updateSectionAtIndex:(NSInteger)index withItems:(NSArray *)items;


- (WSSection *)sectionAtIndex:(NSInteger)index;
- (void)enumerateObjectsUsingBlock:(void (^)(WSSection *section, NSUInteger idx, BOOL *stop))block;
- (WSCellItem *)itemAtIndexPath:(NSIndexPath *)path;
- (NSInteger)indexOfSection:(WSSection *)item;

- (void)removeSectionAtIndex:(NSInteger)index;
- (void)removeAllSections;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

@end

@interface WSSectionContainer(AlphabetBuilder)

- (instancetype)initWithSortableObjects:(NSArray *)sortableObjects andCellItemInitBlock:(WSCellItem * (^)(id object))itemBlock;

@end
