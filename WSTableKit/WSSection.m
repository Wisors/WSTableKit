//
//  TableSection.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSection.h"

#import "UITableView+WSTableExtension.h"
#import "WSCellItem.h"
#import "WSDefaultCellsPrototyper.h"
#import "WSDefaultIdentifierConvention.h"

@interface WSSection()

@property (nonatomic, nonnull) UITableView *tableView;
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;

@end

@implementation WSSection {
    NSMutableArray<WSCellItem *> *_items;
    NSMutableDictionary *_cellHeights;
}
@synthesize adjustment = _adjustment;
@synthesize cellPrototyper = _cellPrototyper;

- (void)dealloc {
    if (_tableView.delegate == self) { // Because we retain tableView it may call scroll event to us even after release of object
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        _tableView = nil;
    }
}

+ (nonnull instancetype)sectionWithTableView:(nonnull UITableView *)tableView {
    return [[self alloc] initWithItems:nil scrollDelegate:nil tableView:tableView];
}

+ (nonnull instancetype)sectionWithItems:(nullable NSArray<WSCellItem *> *)cellItems tableView:(nonnull UITableView *)tableView {
    return [[self alloc] initWithItems:cellItems scrollDelegate:nil tableView:tableView];
}

+ (nonnull instancetype)sectionWithCellClass:(nonnull Class<WSCellClass>)cellClass
                                     objects:(nullable NSArray<WSCellItem *> *)objects
                                   tableView:(nonnull UITableView *)tableView {
    NSArray *cellItems = [WSCellItem itemsWithClass:cellClass objects:objects];
    return [[self alloc] initWithItems:cellItems scrollDelegate:nil tableView:tableView];
}

- (instancetype)init NS_UNAVAILABLE{
    return nil;
}

- (nonnull instancetype)initWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                       scrollDelegate:(nullable id<UIScrollViewDelegate>)delegate
                            tableView:(nonnull UITableView *)tableView {
    if ((self = [super init])) {
        _items              = ([cellItems count] > 0) ? [cellItems mutableCopy] : [NSMutableArray new];
        _cellPrototyper     = [[WSDefaultCellsPrototyper alloc] initWithTableView:tableView identifierConvention:[WSDefaultIdentifierConvention new]];
        _cellHeights        = [NSMutableDictionary new];
        _scrollDelegate     = delegate;
        _tableView          = tableView;
        tableView.delegate  = (tableView.delegate) ?: self;
        tableView.dataSource = (tableView.dataSource) ?: self;
        [self ws_registerItemsCells:cellItems];
    }
    
    return self;
}

- (nonnull instancetype)setAdjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    _adjustment = (adjustmentBlock) ? [WSAction actionWithType:WSActionAdjustment actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        adjustmentBlock(actionInfo.view, actionInfo.item, actionInfo.path);
    }] : nil;
    return self;
}

- (void)setSectionHeader:(WSSupplementaryItem *)sectionHeader {
    if (_sectionHeader != sectionHeader) {
        _sectionHeader = sectionHeader;
        [_cellPrototyper registerIfNeededHeaderFooterViewClass:sectionHeader.viewClass];
    }
}

- (void)setSectionFooter:(WSSupplementaryItem *)sectionFooter {
    if (_sectionFooter != sectionFooter) {
        _sectionFooter = sectionFooter;
        [_cellPrototyper registerIfNeededHeaderFooterViewClass:sectionFooter.viewClass];
    }
}

- (void)ws_registerItemsCells:(NSArray<WSCellItem *> *)items {
    NSMutableSet *set = [NSMutableSet set];
    [items enumerateObjectsUsingBlock:^(WSCellItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [set addObject:item.viewClass];
    }];
    [_cellPrototyper registerIfNeededCellClasses:[set copy]];
}

#pragma mark - UIScrollViewDelegate forwarding -

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_scrollDelegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return ([_scrollDelegate respondsToSelector:aSelector]) ? _scrollDelegate : [super forwardingTargetForSelector:aSelector];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell<WSCellClass> *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    NSString *identifier = [[_cellPrototyper identifierConvention] identifierForClass:item.viewClass];
    UITableViewCell<WSCellClass> *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    WSActionInfo *actionInfo = [WSActionInfo actionInfoWithView:cell item:item path:indexPath userInfo:nil];
    [_adjustment invokeActionWithInfo:actionInfo];
    [item.adjustment invokeActionWithInfo:actionInfo];
    [cell applyItem:item heightCalculation:NO];
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_sectionHeader && ((_showSupplementaryInEmptySection) ? YES : [_items count] != 0)) {
        UITableViewHeaderFooterView<WSCellClass> *header = [_cellPrototyper headerFooterPrototypeForCellClass:_sectionHeader.viewClass];
        if (_sectionHeader.adjustment) {
            [_sectionHeader.adjustment invokeActionWithInfo:[WSActionInfo actionInfoWithView:header item:_sectionHeader path:nil userInfo:nil]];
        }
        [header applyItem:_sectionHeader heightCalculation:YES];
        return ([header respondsToSelector:@selector(cellHeight)]) ? [header cellHeight] : tableView.sectionHeaderHeight;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_sectionFooter && ((_showSupplementaryInEmptySection) ? YES : [_items count] != 0)) {
        UITableViewHeaderFooterView<WSCellClass> *footer = [_cellPrototyper headerFooterPrototypeForCellClass:_sectionFooter.viewClass];
        if (_sectionFooter.adjustment) {
            [_sectionFooter.adjustment invokeActionWithInfo:[WSActionInfo actionInfoWithView:footer item:_sectionFooter path:nil userInfo:nil]];
        }
        [footer applyItem:_sectionFooter heightCalculation:YES];
        return ([footer respondsToSelector:@selector(cellHeight)]) ? [footer cellHeight] : tableView.sectionFooterHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView<WSCellClass> *header;
    if (_sectionHeader) {
        NSString *identifier = [[_cellPrototyper identifierConvention] identifierForClass:_sectionHeader.viewClass];
        header = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (_sectionHeader.adjustment) {
            [_sectionHeader.adjustment invokeActionWithInfo:[WSActionInfo actionInfoWithView:header item:_sectionHeader path:nil userInfo:nil]];
        }
        [header applyItem:_sectionHeader heightCalculation:NO];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView<WSCellClass> *footer;
    if (_sectionFooter) {
        NSString *identifier = [[_cellPrototyper identifierConvention] identifierForClass:_sectionFooter.viewClass];
        footer = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (_sectionFooter.adjustment) {
            [_sectionFooter.adjustment invokeActionWithInfo:[WSActionInfo actionInfoWithView:footer item:_sectionFooter path:nil userInfo:nil]];
        }
        [footer applyItem:_sectionFooter heightCalculation:NO];
    }
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *cachedHeight = [_cellHeights objectForKey:@(indexPath.row)];
    if (cachedHeight) {
        return [cachedHeight floatValue];
    }
    
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    NSAssert(item, @"Something goes wrong, you have to have an item here.");

    CGFloat height = tableView.rowHeight;
    Class<WSCellClass> cellClass = item.viewClass;
    UITableViewCell<WSCellClass> *proto = [_cellPrototyper cellPrototypeForCellClass:cellClass];
    if ([cellClass instancesRespondToSelector:@selector(cellHeight)]) {
        WSActionInfo *actionInfo = [WSActionInfo actionInfoWithView:proto item:item path:indexPath userInfo:nil];
        [_adjustment invokeActionWithInfo:actionInfo];
        [item.adjustment invokeActionWithInfo:actionInfo];
        [proto applyItem:item heightCalculation:YES];
        height = [proto cellHeight];
    }
    [_cellHeights setObject:@(height) forKey:@(indexPath.row)];
    return height;
}

#pragma mark - UITableViewDelegate Selection -

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return ws_invokeIndexPathReturnActionWithType(WSActionWillSelect, tableView, indexPath, self);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    return ws_invokeIndexPathReturnActionWithType(WSActionWillDisplay, tableView, indexPath, self);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSAction *action = [item.actionsHolder actionForType:WSActionClick];
    if (action) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        action = [item.actionsHolder actionForType:WSActionSelect];
    }
    if (action) {
        ws_findCellAndinvokeAction(action, tableView, indexPath, item);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ws_invokeIndexPathReturnActionWithType(WSActionDeselect, tableView, indexPath, self);
}

#pragma mark - UITableViewDelegate Displaing -

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSAction *action = [item.actionsHolder actionForType:WSActionWillDisplay];
    ws_invokeAction(action, cell, indexPath, item);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSAction *action = [item.actionsHolder actionForType:WSActionEndDisplay];
    ws_invokeAction(action, cell, indexPath, item);
}

#pragma mark - UITableViewDelegate Higlighting -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSAction *action = [item.actionsHolder actionForType:WSActionShouldHiglight];
    if (action) {
        id actionResult = ws_findCellAndinvokeAction(action, tableView, indexPath, item);
        NSAssert([actionResult respondsToSelector:@selector(boolValue)], @"Need to return boolean type");
        return [actionResult boolValue];
    }
    
    return YES;
} 

#pragma mark - Actions -

static inline id ws_findCellAndinvokeAction(WSAction *action, UITableView *tableView, NSIndexPath *indexPath, WSCellItem *item) {
    UITableViewCell<WSCellClass> *cell = [tableView cellForRowAtIndexPath:indexPath];
    return ws_invokeAction(action, cell, indexPath, item);
}

static inline id ws_invokeAction(WSAction *action, UITableViewCell<WSCellClass> *cell, NSIndexPath *indexPath, WSCellItem *item) {
    if (action) {
        WSActionInfo *actionInfo = [WSActionInfo actionInfoWithView:cell item:item path:indexPath userInfo:nil];
        return [action invokeActionWithInfo:actionInfo];
    }
    return nil;
}

static inline id ws_invokeIndexPathReturnActionWithType(WSActionType type, UITableView *tableView, NSIndexPath *indexPath, WSSection *section) {
    WSCellItem *item = [section itemAtIndex:indexPath.row];
    WSAction *action = [item.actionsHolder actionForType:type];
    if (action) {
        return ws_findCellAndinvokeAction(action, tableView, indexPath, item);
    }
    
    return indexPath;
}

@end


@implementation WSSection(ItemAccess)

- (void)cleanHeightsCache {
    [_cellHeights removeAllObjects];
}

- (void)removeCachedHeightsAboveIndex:(NSInteger)index {
    while (index < [_items count]) {
        [_cellHeights removeObjectForKey:@(index)];
        index++;
    }
}

#pragma mark - Add & Insert & Update Items -

- (void)updateWithItems:(NSArray *)items {
    _items = (items) ? [items mutableCopy] : [NSMutableArray new];
    [_cellHeights removeAllObjects];
    [self ws_registerItemsCells:items];
}

- (void)addItem:(WSCellItem *)item {
    if (item != nil) {
        [_items addObject:item];
        [_cellPrototyper registerIfNeededCellClass:item.viewClass];
    }
}

- (void)addItems:(NSArray *)items {
    if ([items count] == 0) {
        return;
    }
    [_items addObjectsFromArray:items];
    [self ws_registerItemsCells:items];
}

- (void)insertItem:(WSCellItem *)item atIndex:(NSInteger)index {
    if (!item) {
        return;
    }
    
    if (index <= [_items count]) {
        [self removeCachedHeightsAboveIndex:index];
        [_items insertObject:item atIndex:index];
        [_cellPrototyper registerIfNeededCellClass:item.viewClass];
    }
}

- (void)replaceItemAtIndex:(NSInteger)index withItem:(WSCellItem *)item {
    if (!item) {
        return;
    }
    
    if (index < [_items count]) {
        [_cellHeights removeObjectForKey:@(index)];
        [_items replaceObjectAtIndex:index withObject:item];
        [_cellPrototyper registerIfNeededCellClass:item.viewClass];
    }
}

#pragma mark - Remove Items -

- (void)removeItemAtIndex:(NSInteger)index {
    NSAssert(index < [_items count], @"Remove item beyond items range");
    if (index < [_items count]) {
        [self removeCachedHeightsAboveIndex:index];
        [_items removeObjectAtIndex:index];
    }
}

- (void)removeItemsAtIndexes:(NSIndexSet *)set {
    [_items removeObjectsAtIndexes:set];
    __block NSUInteger minIndex = NSUIntegerMax;
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < minIndex) {
            minIndex = idx;
        }
    }];
    if (minIndex != NSUIntegerMax) {
        [self removeCachedHeightsAboveIndex:minIndex];
    }
}

- (void)removeAllItems {
    _items = [NSMutableArray new];
    _cellHeights = [NSMutableDictionary new];
}

#pragma mark - Access Items -

- (void)enumerateObjectsUsingBlock:(void (^)(WSCellItem *item, NSUInteger idx, BOOL *stop))block {
    [_items enumerateObjectsUsingBlock:block];
}

- (WSCellItem *)itemAtIndex:(NSInteger)index {
    if ([_items count] > index) {
        return [_items objectAtIndex:index];
    }
    
    return nil;
}

- (NSInteger)indexOfItem:(WSCellItem *)item {
    return [_items indexOfObject:item];
}

- (NSUInteger)numberOfItems {
    return [_items count];
}

@end
