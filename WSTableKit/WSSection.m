//
//  TableSection.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSection.h"

#import "WSCellItem.h"

@interface WSSection()

@property (nonatomic, nonnull) NSMutableArray<WSCellItem *> *items;
@property (nonatomic, nonnull) NSMutableDictionary *cellPrototypes;
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic, weak, nullable) UITableView *tableView;

@end

@implementation WSSection
@synthesize adjustment = _adjustment;

+ (nonnull instancetype)sectionWithCellClass:(nonnull Class<WSCellClass>)cellClass
                                     objects:(nullable NSArray *)objects
                                   tableView:(nullable UITableView *)tableView {
    NSArray *cellItems = [WSCellItem cellItemsWithClass:cellClass objects:objects];
    return [[self alloc] initWithItems:cellItems tableView:tableView scrollDelegate:nil adjustmentBlock:nil];
}

+ (nonnull instancetype)sectionWithItems:(nullable NSArray<WSCellItem *> *)cellItems tableView:(nullable UITableView *)tableView {
    return [[self alloc] initWithItems:cellItems tableView:tableView scrollDelegate:nil adjustmentBlock:nil];
}

+ (nonnull instancetype)sectionWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                               tableView:(nullable UITableView *)tableView
                         adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithItems:cellItems tableView:tableView scrollDelegate:nil adjustmentBlock:adjustmentBlock];
}

- (instancetype)init {
    return [self initWithItems:nil tableView:nil scrollDelegate:nil adjustmentBlock:nil];
}

- (nonnull instancetype)initWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                            tableView:(nullable UITableView *)tableView
                       scrollDelegate:(nullable id<UIScrollViewDelegate>)delegate
                      adjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    if ((self = [super init])) {
        _items              = ([cellItems count] > 0) ? [cellItems mutableCopy] : [NSMutableArray new];;
        _cellPrototypes     = [NSMutableDictionary new];
        _scrollDelegate     = delegate;
        [self setAdjustmentBlock:adjustmentBlock];
    }
    
    return self;
}

- (nonnull instancetype)setAdjustmentBlock:(nullable WSAdjustmentBlock)adjustmentBlock {
    _adjustment = (adjustmentBlock) ? [WSAction actionWithType:WSActionAdjustment actionBlock:^(WSActionInfo * _Nonnull actionInfo) {
        adjustmentBlock(actionInfo.cell, actionInfo.item, actionInfo.path);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (!_sectionHeader.customView && _sectionHeader.title.length > 0) ? _sectionHeader.title : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return (!_sectionFooter.customView && _sectionFooter.title.length > 0) ? _sectionFooter.title : nil;
}

- (UITableViewCell<WSCellClass> *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    UITableViewCell<WSCellClass> *cell = [tableView dequeueReusableCellWithIdentifier:[item.cellClass cellIdentifier]
                                                                         forIndexPath:indexPath];
    WSActionInfo *actionInfo = [WSActionInfo actionInfoWithCell:cell item:item path:indexPath userInfo:nil];
    [_adjustment invokeActionWithInfo:actionInfo];
    [item.adjustment invokeActionWithInfo:actionInfo];
    [cell applyItem:item heightCalculation:NO];
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([_items count] == 0) {
        return 0;
    } else {
        return _sectionHeader ? [_sectionHeader itemHeight] : tableView.sectionHeaderHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([_items count] == 0) {
        return 0;
    } else {
        return (_sectionFooter) ? [_sectionFooter itemHeight] : tableView.sectionFooterHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    NSAssert(item, @"Something goes wrong, you have to have an item here.");

    Class<WSCellClass> cellClass = item.cellClass;
    UITableViewCell<WSCellClass> *proto = [self ws_cellPrototypeInTableView:tableView withCellClass:cellClass]; //Need to register cell
    if ([cellClass instancesRespondToSelector:@selector(cellHeight)]) {
        WSActionInfo *actionInfo = [WSActionInfo actionInfoWithCell:proto item:item path:indexPath userInfo:nil];
        [_adjustment invokeActionWithInfo:actionInfo];
        [item.adjustment invokeActionWithInfo:actionInfo];
        [proto applyItem:item heightCalculation:YES];
        
        return [proto cellHeight];
    } else {
        return tableView.rowHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _sectionHeader.customView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return _sectionFooter.customView;
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
    WSAction *action = [item actionForType:WSActionClick];
    if (action) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        action = [item actionForType:WSActionSelect];
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
    WSAction *action = [item actionForType:WSActionWillDisplay];
    ws_invokeAction(action, cell, indexPath, item);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSAction *action = [item actionForType:WSActionEndDisplay];
    ws_invokeAction(action, cell, indexPath, item);
}

#pragma mark - UITableViewDelegate Higlighting -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSAction *action = [item actionForType:WSActionShouldHiglight];
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
        WSActionInfo *actionInfo = [WSActionInfo actionInfoWithCell:cell item:item path:indexPath userInfo:nil];
        return [action invokeActionWithInfo:actionInfo];
    }
    return nil;
}

static inline id ws_invokeIndexPathReturnActionWithType(WSActionType type, UITableView *tableView, NSIndexPath *indexPath, WSSection *section) {
    WSCellItem *item = [section itemAtIndex:indexPath.row];
    WSAction *action = [item actionForType:type];
    if (action) {
        return ws_findCellAndinvokeAction(action, tableView, indexPath, item);
    }
    
    return indexPath;
}

#pragma mark - Prototyping -

- (nonnull UITableViewCell<WSCellClass> *)ws_cellPrototypeInTableView:(nonnull UITableView *)tableView withCellClass:(nonnull Class<WSCellClass>)cellClass {
    NSString *identifier = [cellClass cellIdentifier];
    UITableViewCell<WSCellClass> *cell = [_cellPrototypes objectForKey:identifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier]; // Deque from Storyboard
        if (!cell) {
            [self ws_registerCell:identifier tableView:tableView cellClass:cellClass];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) { // Last resort case
                cell = [[(Class)cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
        }
        NSAssert(cell, @"Most likely you have a mistake with your cell's identifier");
        [_cellPrototypes setObject:cell forKey:identifier];
        cell.bounds = CGRectMake(0, 0, tableView.bounds.size.width, cell.bounds.size.height);
    }
    
    return cell;
}

- (void)ws_registerCell:(NSString *)identifier tableView:(UITableView *)tableView cellClass:(Class<WSCellClass>)cellClass {
    NSBundle *bundle = [NSBundle bundleForClass:cellClass];
    if ([bundle pathForResource:identifier ofType:@"nib"] != nil) {// Xib
        [tableView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:identifier];
    } else {
        [tableView registerClass:cellClass forCellReuseIdentifier:identifier]; // Code generated cell
    }
}

@end


@implementation WSSection(ItemAccess)

#pragma mark - Add & Insert & Update Items -

- (void)updateWithItems:(NSArray *)items {
    self.items = (items) ? [items mutableCopy] : [NSMutableArray new];;
}

- (void)addItem:(WSCellItem *)item {
    if (item != nil) {
        [self.items addObject:item];
    }
}

- (void)addItems:(NSArray *)items {
    if ([items count] == 0) {
        return;
    }
    [self.items addObjectsFromArray:items];
}

- (void)insertItem:(WSCellItem *)item atIndex:(NSInteger)index {
    if (!item) {
        return;
    }
    
    if (index <= [self.items count]) {
        [self.items insertObject:item atIndex:index];
    }
}

- (void)replaceItemAtIndex:(NSInteger)index withItem:(WSCellItem *)item {
    if (!item) {
        return;
    }
    
    if (index < [self.items count]) {
        [self.items replaceObjectAtIndex:index withObject:item];
    }
}

#pragma mark - Remove Items -

- (void)removeItemAtIndex:(NSInteger)index {
    if (index < [self.items count]) {
        [self.items removeObjectAtIndex:index];
    }
}

- (void)removeItemsAtIndexes:(NSIndexSet *)set {
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self removeItemAtIndex:idx];
    }];
}

- (void)removeAllItems {
    self.items = [NSMutableArray new];
}

#pragma mark - Access Items -

- (void)enumerateObjectsUsingBlock:(void (^)(WSCellItem *item, NSUInteger idx, BOOL *stop))block {
    [self.items enumerateObjectsUsingBlock:block];
}

- (WSCellItem *)itemAtIndex:(NSInteger)index {
    if ([self.items count] > index) {
        return [self.items objectAtIndex:index];
    }
    
    return nil;
}

- (NSInteger)indexOfItem:(WSCellItem *)item {
    return [self.items indexOfObject:item];
}

- (NSUInteger)numberOfItems {
    return [self.items count];
}

@end
