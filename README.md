`WSTableKit` is a simple framework that provide a block-based way of ruling your `UITableView`'s or `UITableViewController`'s. It's a good solution to create static or API-based tables.

### Key Features
 - Forget about delegate pattern and think about your table as what it is - collection of data(rows).
 - Block-based actions associated with particular data entity(row).
 - Build-in solution for top/bottom cell separators that can be well customizated.
 - WSTableKit supports static height cells as well as Autolayout cells.

### Requirements
- iOS 7.0

# Installation

### Cocoapods
The recommended way to install `WSTableKit` is via [Cocoapods](http://cocoapods.org) package manager.
```ruby
# Podfile example
platform :ios, '7.0'
pod 'WSTableKit'
```

# Usage

### Simple use cases

#### Table from array of some data

All you need to create simple table is create a `WSTableSection` section populated with `WSCellItem` cells and set it as tableView delegate and dataSource. You can use adjustmentBlock of section to populating your cell views with provided data or other tuning, but it's recommented to encopsulate this code inside your cell class(see next example).

```objective-c
// Some controller

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) WSTableSection *section;

...

- (void)viewDidLoad {
	[super viewDidLoad];

	// Your array of entities to show
	NSArray *data = @[@"One", @"Two", @"Three"]; 
	// Array of items that represents table cells
	NSArray *cells = [WSCellItem cellItemsWithClass:[WSTableViewCell class] objects:data]; 
	// Create section of cells with adjustment block that makes our data visible in cell.
	self.section = [WSTableSection sectionWithItems:cells adjustmentBlock:^(WSTableViewCell *cell, WSCellItem *item, NSIndexPath *path) {
	    cell.textLabel.text = item.object;
	}]; 
	// Make section ruler of your table
	self.tableView.dataSource = self.section;
	self.tableView.delegate = self.section;
}
```

#### Implement custom cell or subclass WSTableViewCell

Your can populate your custom/subclassed cell with provided entity or make some additional cell adjustment by implementing the `WSCellClass` protocol method `-(void)applyItem:(WSCellItem *)item`

```objective-c
// Custom cell
@implementation CustomTableViewCell

- (void)applyItem:(WSCellItem *)item {
    self.textLabel.text = item.object;
}

...

// Controller
NSArray *data = @[@"One", @"Two", @"Three"]; 
NSArray *cells = [WSCellItem cellItemsWithClass:[CustomTableViewCell class] objects:data]; 
self.section = [WSTableSection sectionWithItems:cells];
```

#### Selection handling

To handle selection event just set or init your cell items with `selectionBlock`. It is possible to rule selection per particular cells, just add it only if it necessary for cell to respond to selection events and forget about endless switch statements for tableView delegate selection methods. In any moment you can change selection behavior by assignement of new `selectiobBlock` on item(s).

```objective-c
// Per item selectionBlock
[WSCellItem itemWithCellClass:[WSTableViewCell class] object:@"One" selectionBlock:^(BOOL selected, WSCellItem *item, NSIndexPath *path) {
    if (selected) {
 		// select
	} else {
		// deselect
	}
}];

// Multiple items selectionBlock
NSArray *cells = [WSCellItem cellItemsWithClass:[WSTableViewCell class] objects:data selectionBlock:^(BOOL selected, WSCellItem *item, NSIndexPath *path) {
	// code here
}];
```

#### Cell with custom actions

Some of your table cells may have an ability to generate some events (button clicked, text input and etc) and you should properly response to it. `WSCellItem` provide mechanism of block-based actions that helps your handle such events. 


```objective-c
// Custom cell
static NSString* const WSButtonClickedActionKey = @"WSButtonClickedActionKey";

@interface CustomTableViewCell : UITableViewCell ()
@property (nonatomic, strong) WSCellItem *item; // keep cell item

...

@implementation CustomTableViewCell

- (IBAction)buttonClicked:(id)sender {
 	[self.item invokeActionForKey:WSButtonClickedActionKey withCell:self]; // Invoke action for key if it available
}

...

// Controller 

// Create action
WSCellAction *action = [WSCellAction actionWithKey:WSButtonClickedActionKey shortActionBlock:^(WSTableViewCell *cell) {
    NSLog(@"Button pressed");
}];

// Create another one with different action block.
WSCellAction *otherActionForSameKey = [WSCellAction actionWithKey:WSButtonClickedActionKey actionBlock:^id(WSTableViewCell *cell, NSDictionary *userInfo) {
    NSLog(@"Button pressed");
    return @(YES); // Success
];

// Init item with action or add it later 
WSCellItem *item = [WSCellItem itemWithCellClass:[CustomTableViewCell class] object:@"One" customAction:action];
[item addAction:otherActionForSameKey]; // CAUTION: cell item can have only one action per key and it will override previous one
```

Note, that `WSCellAction` may contain different action blocks, `WSCellActionShortBlock`(no return value) and `WSCellActionBlock`(return value as respond to event). As you may guess, each action instance can have variours blocks with no return value, but only one action block with return value. See deep understanding block for more information about `WSCellAction`.

# WSTableKit deep understanding

#### WSCellItem

```objective-c
@protocol WSCellClass <NSObject>

+ (NSString *)cellIdentifier;
- (void)applyItem:(WSCellItem *)item;

@optional
// WSTableKit use default UITableView rowHeight value in case of this method has not implemented by your cell. CAUTION: WSTableViewCell has default implementation that returns system default 44pt row height. 
- (CGFloat)heightWithItem:(WSCellItem *)item;

@end

@interface WSCellItem : NSObject

@property (nonatomic, assign, readonly) Class<WSCellClass> cellClass;
@property (nonatomic, strong, readonly) id object;
@property (nonatomic, copy) WSCellSelectionBlock selectionBlock;
@property (nonatomic, copy) WSCellAdjustmentBlock adjustmentBlock;
```

`WSCellItem` is representing a single row in the table. Any cell have to know it representation cell class, it's the only one required field to get your cell ready to use. But `WSCellItem` has a lot of additional functionality above that, like cell actions, selection event handling or final cell adjustment.

Your cell class have to conform to a simple `WSCellClass` protocol but it is recommended to use `WSTableViewCell` class or subclass it, because it has default implemetation of protocol methods.

#### In progress

## Author

Alex Nikishin

## License

WSTableKit is available under the MIT license. See the LICENSE file for more info.
