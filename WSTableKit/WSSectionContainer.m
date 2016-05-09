////
////  SectionContainer.m
////
////  Created by Alex Nikishin on 30/09/15.
////  Copyright © 2015 Alex Nikishin. All rights reserved.
////

#import "WSSectionContainer.h"

#import "NSArray+WSSortable.h"
#import "WSSortable.h"
#import "WSDefaultCellsPrototyper.h"
#import "WSDefaultIdentifierConvention.h"

@interface WSSectionContainer()

@property (nonatomic, nonnull) NSMutableArray<WSSection *> *sections;
@property (nonatomic, nonnull) UITableView *tableView;
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;

@end

@implementation WSSectionContainer
@synthesize adjustment = _adjustment;
@synthesize cellPrototyper = _cellPrototyper;

+ (nonnull instancetype)containerWithSections:(nullable NSArray *)sections tableView:(nullable UITableView *)tableView {
    return [[self alloc] initWithSections:sections tableView:tableView adjustmentBlock:nil scrollDelegate:nil];
}

+ (nonnull instancetype)containerWithSections:(nullable NSArray *)sections
                                    tableView:(nullable UITableView *)tableView
                              adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithSections:sections tableView:tableView adjustmentBlock:adjustmentBlock scrollDelegate:nil];
}

+ (nonnull instancetype)containerWithSections:(nullable NSArray *)sections
                                    tableView:(nullable UITableView *)tableView
                               scrollDelegate:(nullable id<UIScrollViewDelegate>)scrollDelegate {
    return [[self alloc] initWithSections:sections tableView:tableView adjustmentBlock:nil scrollDelegate:scrollDelegate];
}

- (nonnull instancetype)init {
    return [self initWithTableView:nil];
}

- (nonnull instancetype)initWithTableView:(UITableView *)tableView {
    return [self initWithSections:nil tableView:tableView adjustmentBlock:nil scrollDelegate:nil];
}

- (nonnull instancetype)initWithSection:(nonnull WSSection *)section tableView:(nullable UITableView *)tableView {
    return [self initWithSections:@[section] tableView:tableView adjustmentBlock:nil scrollDelegate:nil];
}

- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections tableView:(nullable UITableView *)tableView {
    return [self initWithSections:sections tableView:tableView adjustmentBlock:nil scrollDelegate:nil];
}

- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections
                               tableView:(nullable UITableView *)tableView
                         adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [self initWithSections:sections tableView:tableView adjustmentBlock:adjustmentBlock scrollDelegate:nil];
}

- (nonnull instancetype)initWithSections:(nullable NSArray<WSSection *> *)sections
                               tableView:(nullable UITableView *)tableView
                          scrollDelegate:(nullable id<UIScrollViewDelegate>)scrollDelegate {
    return [self initWithSections:sections tableView:tableView adjustmentBlock:nil scrollDelegate:nil];
}

- (nonnull instancetype)initWithSections:(nullable NSArray *)sections
                               tableView:(nullable UITableView *)tableView
                         adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock
                          scrollDelegate:(nullable id<UIScrollViewDelegate>)scrollDelegate {
    if ((self = [super init])) {
        _sections       = ([sections count] > 0) ? [sections mutableCopy] : [NSMutableArray new];
        _cellPrototyper = [[WSDefaultCellsPrototyper alloc] initWithTableView:tableView identifierConvention:[WSDefaultIdentifierConvention new]];
        [_sections makeObjectsPerformSelector:@selector(setCellPrototyper:) withObject:_cellPrototyper];
        _scrollDelegate = scrollDelegate;
        _tableView      = tableView;
        if (tableView) {
            tableView.delegate = self;
            tableView.dataSource = self;
        }
        [self setAdjustmentBlock:adjustmentBlock];
    }
    
    return self;
}

- (nonnull instancetype)setAdjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    _adjustment = (adjustmentBlock) ? [WSAction actionWithType:WSActionAdjustment actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        adjustmentBlock(actionInfo.view, actionInfo.item, actionInfo.path);
    }] : nil;
    
    return self;
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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.enableAlphabet) {
        NSMutableSet *set = [NSMutableSet set];
        [self enumerateObjectsUsingBlock:^(WSSection *section, NSUInteger idx, BOOL *stop) {
            WSSupplementaryItem *header = section.sectionHeader;
            if ([header.sortKey length] > 0) {
                [set addObject:[header.sortKey substringToIndex:1]];
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
            WSSupplementaryItem *header = section.sectionHeader;
            if ([header.sortKey length] > 0 && [[header.sortKey substringToIndex:1] isEqualToString:title]) {
                *stop = YES;
                index = idx;
            }
        }];
        return index;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell<WSCellClass> *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSSection *section = [self sectionAtIndex:indexPath.section];
    UITableViewCell<WSCellClass> *cell = (UITableViewCell<WSCellClass> *)[section tableView:tableView cellForRowAtIndexPath:indexPath];
    if (_adjustment) {
        WSCellItem *item = [section itemAtIndex:indexPath.row];
        WSActionInfo *actionInfo = [WSActionInfo actionInfoWithView:cell item:item path:indexPath userInfo:nil];
        [_adjustment invokeActionWithInfo:actionInfo];
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

#pragma mark - UITableViewDelegate Selection -

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionAtIndex:indexPath.section] tableView:tableView willSelectRowAtIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [[self sectionAtIndex:indexPath.section] tableView:tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self sectionAtIndex:indexPath.section] tableView:tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate Higlighting -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self sectionAtIndex:indexPath.section] tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
}

@end

@implementation WSSectionContainer(SectionAccess)

- (void)addSection:(nullable WSSection *)section {
    if (section) {
        section.cellPrototyper = self.cellPrototyper;
        [self.sections addObject:section];
    }
}

- (void)addSection:(nullable WSSection *)section atIndex:(NSInteger)index {
    if (section) {
        section.cellPrototyper = self.cellPrototyper;
        if (index >= [self.sections count]) {
            [self.sections addObject:section];
        } else {
            [self.sections insertObject:section atIndex:index];
        }
    }
}

- (void)replaceSectionAtIndex:(NSInteger)index withSection:(nonnull WSSection *)section {
    section.cellPrototyper = self.cellPrototyper;
    if ([self.sections count] > index) {
        [self.sections replaceObjectAtIndex:index withObject:section];
    }
}

- (void)updateSectionAtIndex:(NSInteger)index withItems:(nonnull NSArray<WSCellItem *> *)items {
    [[self sectionAtIndex:index] updateWithItems:items];
}

- (NSInteger)numberOfSections {
    return [self.sections count];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] numberOfItems];
}

- (nullable WSSection *)sectionAtIndex:(NSInteger)index {
    if ([self.sections count] > index) {
        return [self.sections objectAtIndex:index];
    }
    
    return nil;
}

- (nullable WSCellItem *)itemAtIndexPath:(nonnull NSIndexPath *)path {
    return [[self sectionAtIndex:path.section] itemAtIndex:path.row];
}

- (void)enumerateObjectsUsingBlock:(nullable void (^)(WSSection * _Nonnull section, NSUInteger idx, BOOL * _Nullable stop))block {
    [self.sections enumerateObjectsUsingBlock:block];
}

- (NSInteger)indexOfSection:(nonnull WSSection *)item {
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

@end

@implementation WSSectionContainer(AlphabetBuilder)

- (nonnull instancetype)initWithTableView:(nullable UITableView *)tableView
                          sortableObjects:(nonnull NSArray *)sortableObjects
                     andCellItemInitBlock:(nonnull WSCellItem * _Nonnull (^)(id _Nullable object))itemBlock {
    return [self initWithSections:[self splitCurrentItemsToSections:sortableObjects inTableView:tableView andCellItemInitBlock:itemBlock] tableView:tableView];
}

- (NSArray *)splitCurrentItemsToSections:(NSArray *)objects inTableView:(UITableView *)tableView andCellItemInitBlock:(WSCellItem * (^)(id object))itemBlock {
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
            currentSection = [WSSection sectionWithTableView:tableView];
            currentSection.sectionHeader = [WSSupplementaryItem itemWithTitle:[key uppercaseString]];
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
