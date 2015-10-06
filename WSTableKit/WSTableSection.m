//
//  TableSection.m
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import "WSTableSection.h"

#import "WSCellItem.h"
#import "WSTableViewCell.h"

@interface WSTableSection()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *cellPrototypes;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollDelegate;

@end

@implementation WSTableSection
@synthesize adjustmentBlock = _adjustmentBlock;
@synthesize displayBlock = _displayBlock;
@synthesize eventBlock = _eventBlock;

+ (instancetype)sectionWithCellClass:(Class<WSCellClass>)cellClass objects:(NSArray *)objects {
    NSArray *cellItems = [WSCellItem cellItemsWithClass:cellClass objects:objects];
    return [self sectionWithItems:cellItems];
}

+ (instancetype)sectionWithItems:(NSArray *)cellItems {
    return [[self alloc] initWithItems:cellItems adjustmentBlock:nil];
}

+ (instancetype)sectionWithItems:(NSArray *)cellItems adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [[self alloc] initWithItems:cellItems adjustmentBlock:adjustmentBlock];
}

- (instancetype)init {
    return [self initWithItems:@[] adjustmentBlock:nil];
}

- (instancetype)initWithItems:(NSArray *)cellItems adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock {
    return [self initWithItems:cellItems adjustmentBlock:adjustmentBlock scrollDelegate:nil];
}

- (instancetype)initWithItems:(NSArray *)cellItems adjustmentBlock:(WSCellAdjustmentBlock)adjustmentBlock scrollDelegate:(id<UIScrollViewDelegate>)delegate {
    
    if ((self = [super init])) {
        NSAssert(cellItems != nil, @"You can't initialize section with nil");
        _items              = [cellItems mutableCopy];;
        _adjustmentBlock    = adjustmentBlock;
        _cellPrototypes     = [NSMutableDictionary new];
        _lock               = [NSLock new];
        _scrollDelegate     = delegate;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (!_sectionHeader.customView && _sectionHeader.title.length > 0) ? _sectionHeader.title : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return (!_sectionFooter.customView && _sectionFooter.title.length > 0) ? _sectionFooter.title : nil;
}

- (WSTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WSCellItem *item = [self itemAtIndex:indexPath.row];
    WSTableViewCell *cell = (WSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[item.cellClass cellIdentifier]
                                                                       forIndexPath:indexPath];
    [cell applyItem:item];
    if (_adjustmentBlock) {
        _adjustmentBlock(cell, item, indexPath);
    }
    if (item.adjustmentBlock) {
        item.adjustmentBlock(cell, item, indexPath);
    }
    
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
    
    Class<WSCellClass> cellClass = [self itemAtIndex:indexPath.row].cellClass;
    if ([cellClass instancesRespondToSelector:@selector(heightWithItem:)]) {
        
        WSTableViewCell *proto = (WSTableViewCell *)[self ws_cellPrototypeInTableView:tableView withCellClass:cellClass];
        WSCellItem *item = [self itemAtIndex:indexPath.row];
        if (_adjustmentBlock) {
            _adjustmentBlock(proto, item, indexPath);
        }
        if (item.adjustmentBlock) {
            item.adjustmentBlock(proto, item, indexPath);
        }
        return [proto heightWithItem:item];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(WSTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_displayBlock) {
        _displayBlock(YES, cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(WSTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (WSTableViewCell *)ws_cellPrototypeInTableView:(UITableView *)tableView withCellClass:(Class<WSCellClass>)cellClass {
    
    NSString *identifier = [cellClass cellIdentifier];
    WSTableViewCell *cell = [_cellPrototypes objectForKey:identifier];
    if (!cell) {
        
        if ([[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"] != nil) {
            [tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        } else {
            [tableView registerClass:cellClass forCellReuseIdentifier:identifier];

        }
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.frame = CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.width);
        [_cellPrototypes setObject:cell forKey:identifier]; // If it crash, most likely you forgot to register your cell for table view.
    }
    
    return cell;
}

@end


@implementation WSTableSection(ItemAccess)

#pragma mark - Add & Insert & Update Items -

- (void)updateWithItems:(NSArray *)items {
    
    [self.lock lock];
    self.items = (items) ? [items mutableCopy] : [NSMutableArray new];;
    [self.lock unlock];
}

- (void)addItem:(WSCellItem *)item {
    
    if (item != nil) {
        
        [self.lock lock];
        [self.items addObject:item];
        [self.lock unlock];
    }
}

- (void)addItems:(NSArray *)items {
    
    if ([items count] == 0) {
        return;
    }
    
    [self.lock lock];
    [self.items addObjectsFromArray:items];
    [self.lock unlock];
}

- (void)insertItem:(WSCellItem *)item atIndex:(NSInteger)index {
    
    if (!item) {
        return;
    }
    
    [self.lock lock];
    if (index <= [self.items count]) {
        [self.items insertObject:item atIndex:index];
    }
    [self.lock unlock];
}

- (void)replaceItemAtIndex:(NSInteger)index withItem:(WSCellItem *)item {
    
    if (!item) {
        return;
    }
    
    [self.lock lock];
    if (index < [self.items count]) {
        [self.items replaceObjectAtIndex:index withObject:item];
    }
    [self.lock unlock];
}

#pragma mark - Remove Items -

- (void)removeItemAtIndex:(NSInteger)index {
    
    [self.lock lock];
    if (index < [self.items count]) {
        [self.items removeObjectAtIndex:index];
    }
    [self.lock unlock];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)set {
    
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self removeItemAtIndex:idx];
    }];
}

- (void)removeAllItems {
    
    [self.lock lock];
    self.items = [NSMutableArray new];
    [self.lock unlock];
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
