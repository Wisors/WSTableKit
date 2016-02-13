//
//  TableSection.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSSection.h"

#import "WSCellItem.h"

@interface WSSection()

@property (nonatomic, strong, nonnull) NSMutableArray *items;
@property (nonatomic, strong, nonnull) NSMutableDictionary *cellPrototypes;
@property (nonatomic, weak, nullable) id<UIScrollViewDelegate> scrollDelegate;
@property (nonatomic, weak, nullable) UITableView *tableView;

@end

@implementation WSSection
@synthesize adjustmentBlock = _adjustmentBlock;
@synthesize displayBlock = _displayBlock;
@synthesize eventBlock = _eventBlock;

+ (nonnull instancetype)sectionWithCellClass:(nonnull Class<WSCellClass>)cellClass
                                     objects:(nullable NSArray *)objects {
    NSArray *cellItems = [WSCellItem cellItemsWithClass:cellClass objects:objects];
    return [self sectionWithItems:cellItems];
}

+ (nonnull instancetype)sectionWithItems:(nullable NSArray<WSCellItem *> *)cellItems {
    return [[self alloc] initWithItems:cellItems adjustmentBlock:nil];
}

+ (nonnull instancetype)sectionWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                         adjustmentBlock:(nullable WSCellAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithItems:cellItems adjustmentBlock:adjustmentBlock];
}

- (instancetype)init {
    return [self initWithItems:nil adjustmentBlock:nil];
}

- (nonnull instancetype)initWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                      adjustmentBlock:(nullable WSCellAdjustmentBlock)adjustmentBlock {
    return [self initWithItems:cellItems adjustmentBlock:adjustmentBlock scrollDelegate:nil];
}

- (nonnull instancetype)initWithItems:(nullable NSArray<WSCellItem *> *)cellItems
                      adjustmentBlock:(nullable WSCellAdjustmentBlock)adjustmentBlock
                       scrollDelegate:(nullable id<UIScrollViewDelegate>)delegate {
    if ((self = [super init])) {
        _items              = (cellItems) ? [cellItems mutableCopy] : [NSMutableArray new];;
        _adjustmentBlock    = adjustmentBlock;
        _cellPrototypes     = [NSMutableDictionary new];
        _scrollDelegate     = delegate;
    }
    
    return self;
}

- (void)setAdjustmentBlock:(nullable WSCellAdjustmentBlock)adjustmentBlock {
    if (_adjustmentBlock != adjustmentBlock) {
        _adjustmentBlock = adjustmentBlock;
    }
}

- (void)setDisplayBlock:(nullable WSCellDisplayBlock)displayBlock {
    if (_displayBlock != displayBlock) {
        _displayBlock = displayBlock;
    }
}

- (void)setEventBlock:(nullable WSCellEventBlock)eventBlock {
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
    if (_adjustmentBlock) {
        _adjustmentBlock(cell, item, indexPath);
    }
    if (item.adjustmentBlock) {
        item.adjustmentBlock(cell, item, indexPath);
    }
    [cell applyItem:item];
    
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
        if (_adjustmentBlock) {
            _adjustmentBlock(proto, item, indexPath);
        }
        if (item.adjustmentBlock) {
            item.adjustmentBlock(proto, item, indexPath);
        }
        if ([proto respondsToSelector:@selector(applyItem:heightCalculation:)]) {
            [proto applyItem:item heightCalculation:YES];
        } else {
            [proto applyItem:item];
        }
        
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

#pragma mark - UITableViewDelegate Editing -

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eventBlock) {
        _eventBlock(WSCellWillBeginEditing, indexPath, nil);
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (_eventBlock) {
        _eventBlock(WSCellDidEndEditing, indexPath, nil);
    }
}

#pragma mark - UITableViewDelegate Selection -

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eventBlock) {
        return _eventBlock(WSCellWillSelect, indexPath, indexPath);
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eventBlock) {
        return _eventBlock(WSCellWillDeselect, indexPath, indexPath);
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    if (item.selectionBlock) {
        item.selectionBlock(YES, item, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    if (item.selectionBlock) {
        item.selectionBlock(NO, item, indexPath);
    }
}

#pragma mark - UITableViewDelegate Displaing -

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_displayBlock) {
        _displayBlock(YES, cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell<WSCellClass> *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_displayBlock) {
        _displayBlock(NO, cell, indexPath);
    }
}

#pragma mark - UITableViewDelegate Higlighting -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eventBlock) {
        id result = _eventBlock(WSCellShouldHightlightBlock, indexPath, @(YES));
        if ([result isKindOfClass:[NSNumber class]]) {
            return [result boolValue];
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eventBlock) {
        _eventBlock(WSCellDidHighlight, indexPath, nil);
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_eventBlock) {
        _eventBlock(WSCellDidUnhighlight, indexPath, nil);
    }
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
        [_cellPrototypes setObject:cell forKey:identifier]; // If it crash, most likely you has some mess with your identifiers
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
