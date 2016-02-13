//
//  SectionContainer.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSectionContainer.h"

#import "NSArray+WSSortable.h"
#import "WSSection.h"
#import "WSSortable.h"

@interface WSSectionContainer()

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollDelegate;

@end

@implementation WSSectionContainer
@synthesize adjustmentBlock = _adjustmentBlock;
@synthesize displayBlock = _displayBlock;
@synthesize eventBlock = _eventBlock;

+ (instancetype)containerWithSections:(NSArray *)sestions {
    return [[self alloc] initWithSections:sestions adjustmentBlock:nil scrollDelegate:nil];
}

+ (instancetype)containerWithSections:(NSArray *)sections adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithSections:sections adjustmentBlock:adjustmentBlock scrollDelegate:nil];
}

+ (instancetype)containerWithSections:(NSArray *)sections scrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate {
    return [[self alloc] initWithSections:sections adjustmentBlock:nil scrollDelegate:scrollDelegate];
}

- (instancetype)init {
    return [self initWithSections:@[]];
}

- (instancetype)initWithSection:(WSSection *)section {
    return [self initWithSections:@[section] adjustmentBlock:nil scrollDelegate:nil];
}

- (instancetype)initWithSections:(NSArray *)sections {
    return [self initWithSections:sections adjustmentBlock:nil scrollDelegate:nil];
}

- (instancetype)initWithSections:(NSArray *)sections adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [self initWithSections:sections adjustmentBlock:adjustmentBlock scrollDelegate:nil];
}

- (instancetype)initWithSections:(NSArray *)sections scrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate {
    return [self initWithSections:sections adjustmentBlock:nil scrollDelegate:scrollDelegate];
}

- (instancetype)initWithSections:(NSArray *)sections adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock scrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate {
    
    NSAssert(sections != nil, @"Can't be initialized with nil sections");
    if ((self = [super init])) {
        _sections           = [sections mutableCopy];
        _adjustmentBlock    = adjustmentBlock;
        _scrollDelegate     = scrollDelegate;
    }
    
    return self;
}

- (void)setAdjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    if (_adjustmentBlock != adjustmentBlock) {
        _adjustmentBlock = adjustmentBlock;
    }
}

- (void)setDisplayBlock:(WSCellDisplayBlock)displayBlock {
    if (_displayBlock != displayBlock) {
        _displayBlock = displayBlock;
    }
}

- (void)setEventBlock:(WSCellEventBlock)eventBlock {
    if (_eventBlock != eventBlock) {
        _eventBlock = eventBlock;
    }
}

#pragma mark - UIScrollViewDelegate forwarding -

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_scrollDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return ([_scrollDelegate respondsToSelector:aSelector]) ? _scrollDelegate : [super forwardingTargetForSelector:aSelector];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView titleForHeaderInSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (self.enableAlphabet) {
        
        NSMutableSet *set = [NSMutableSet set];
        [self enumerateObjectsUsingBlock:^(WSSection *section, NSUInteger idx, BOOL *stop) {
            
            WSSectionSupplementaryItem *header = section.sectionHeader;
            if ([header.title length] > 0) {
                [set addObject:[header.title substringToIndex:1]];
            }
        }];
        return [[set allObjects] sortStingsAlphabeticaly];
    }
    return @[];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if (self.enableAlphabet) {
        
        __block NSUInteger index = 0;
        [self enumerateObjectsUsingBlock:^(WSSection *section, NSUInteger idx, BOOL *stop) {
            
            WSSectionSupplementaryItem *header = section.sectionHeader;
            if ([header.title length] > 0 && [[header.title substringToIndex:1] isEqualToString:title]) {
                *stop = YES;
                index = idx;
            }
        }];
        return index;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView titleForFooterInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell<WSCellClass> *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WSSection *section = [self sectionAtIndex:indexPath.section];
    UITableViewCell<WSCellClass> *cell = (UITableViewCell<WSCellClass> *)[section tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.adjustmentBlock) {
        WSCellItem *item = [section itemAtIndex:indexPath.row];
        self.adjustmentBlock(cell, item, indexPath);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionAtIndex:indexPath.section] tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView viewForFooterInSection:section];
}

#pragma mark - UITableViewDelegate Editing -

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.eventBlock) {
        self.eventBlock(WSCellWillBeginEditing, indexPath, nil);
    }
    
    [[self sectionAtIndex:indexPath.section] tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (self.eventBlock) {
        self.eventBlock(WSCellDidEndEditing, indexPath, nil);
    }
    
    [[self sectionAtIndex:indexPath.section] tableView:tableView didEndEditingRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate Selection -

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.eventBlock) {
        return self.eventBlock(WSCellWillSelect, indexPath, indexPath);
    }
    
    return [[self sectionAtIndex:indexPath.section] tableView:tableView willSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.eventBlock) {
        return self.eventBlock(WSCellWillDeselect, indexPath, indexPath);
    }
    
    return [[self sectionAtIndex:indexPath.section] tableView:tableView willDeselectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self sectionAtIndex:indexPath.section] tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self sectionAtIndex:indexPath.section] tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate Displaing -

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayBlock) {
        self.displayBlock(YES, cell, indexPath);
    }
    
    [[self sectionAtIndex:indexPath.section] tableView:tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.displayBlock) {
        self.displayBlock(NO, cell, indexPath);
    }
    
    [[self sectionAtIndex:indexPath.section] tableView:tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate Higlighting -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_eventBlock) {
        id result = _eventBlock(WSCellShouldHightlightBlock, indexPath, @(YES));
        if ([result isKindOfClass:[NSNumber class]]) {
            return [result boolValue];
        }
    }
    
    return [[self sectionAtIndex:indexPath.section] tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.eventBlock) {
        self.eventBlock(WSCellDidHighlight, indexPath, nil);
    }
    
    [[self sectionAtIndex:indexPath.section] tableView:tableView didHighlightRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.eventBlock) {
        self.eventBlock(WSCellDidUnhighlight, indexPath, nil);
    }
    
    [[self sectionAtIndex:indexPath.section] tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
}

@end

@implementation WSSectionContainer(SectionAccess)

- (void)replaceSectionAtIndex:(NSInteger)index withSection:(WSSection *)section {
    if ([self.sections count] > index) {
        [self.sections replaceObjectAtIndex:index withObject:section];
    }
}

- (void)updateSectionAtIndex:(NSInteger)index withItems:(NSArray *)items {
    [[self sectionAtIndex:index] updateWithItems:items];
}

- (void)addSection:(WSSection *)section {
    [self.sections addObject:section];
}

- (void)addSection:(WSSection *)section atIndex:(NSInteger)index {
    if (index >= [self.sections count]) {
        [self.sections addObject:section];
    } else {
        [self.sections insertObject:section atIndex:index];
    }
}

- (NSInteger)numberOfSections {
    return [self.sections count];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] numberOfItems];
}

- (WSSection *)sectionAtIndex:(NSInteger)index {
    if ([self.sections count] > index) {
        return [self.sections objectAtIndex:index];
    }
    
    return nil;
}

- (void)enumerateObjectsUsingBlock:(void (^)(WSSection *section, NSUInteger idx, BOOL *stop))block {
    [self.sections enumerateObjectsUsingBlock:block];
}

- (NSInteger)indexOfSection:(WSSection *)item {
    return [self.sections indexOfObject:item];
}

- (void)removeSectionAtIndex:(NSInteger)index {
    if (index < [self.sections count]) {
        [self.sections removeObjectAtIndex:index];
    }
}

- (void)removeAllSections {
    [self.sections removeAllObjects];
}

- (WSCellItem *)itemAtIndexPath:(NSIndexPath *)path {
    return [[self sectionAtIndex:path.section] itemAtIndex:path.row];
}

@end

@implementation WSSectionContainer(AlphabetBuilder)

- (instancetype)initWithSortableObjects:(NSArray *)sortableObjects andCellItemInitBlock:(WSCellItem * (^)(id object))itemBlock {
    return [self initWithSections:[self splitCurrentItemsToSections:sortableObjects andCellItemInitBlock:itemBlock]];
}

- (NSArray *)splitCurrentItemsToSections:(NSArray *)objects andCellItemInitBlock:(WSCellItem * (^)(id object))itemBlock {
    
    NSAssert((![objects firstObject] || [[objects firstObject] conformsToProtocol:@protocol(WSSortable)]), @"Objects have to conform to Sortable protocol");
    NSAssert(itemBlock, @"You must pass an cellitem initialization block");
    
    NSMutableArray *sections = [NSMutableArray array];
    
    NSString *lastKey;
    WSSection *currentSection;
    for (id<WSSortable> item in [objects sortSortableObjects]) {
        
        NSString *key = [self itemKeyForSection:item];
        if (key.length == 0) {
            continue;
        }
        
        if (![lastKey isEqualToString:key]) {

            currentSection = [WSSection new];
            currentSection.sectionHeader = [[WSSectionSupplementaryItem alloc] initWithTitle:[key uppercaseString]];
            [sections addObject:currentSection];
        }
        
        WSCellItem *cellItem = itemBlock(item);
        [currentSection addItem:cellItem];
        lastKey = key;
    }

    return [sections copy];
}

- (NSMutableArray *)currentSectionAfterAddingIt:(NSMutableArray *)currentSection toSectionArray:(NSMutableArray *)sections {
    
    if ([currentSection count] > 0) {
        [sections addObject:[currentSection copy]];
        currentSection = [NSMutableArray array];
    }
    
    return currentSection;
}

- (NSString *)itemKeyForSection:(id<WSSortable>)item {
    
    NSString *key = [item sortKey];
    if (key.length >= 1) {
        key = [[key substringToIndex:1] uppercaseString];
    }
    
    return (key) ? : @"";
}

@end
