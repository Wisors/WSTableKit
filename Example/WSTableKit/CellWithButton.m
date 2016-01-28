//
//  CellWithButton.m
//  WSTableKit
//
//  Created by Alex Nikishin on 28/01/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "CellWithButton.h"

@implementation CellWithButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addButton];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self addButton];
    }
    
    return self;
}

- (void)addButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 60, self.frame.size.height)];
    [button setTitle:@"Click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:button];
}

- (void)buttonClicked:(id)sender {
    [self.item invokeActionForKey:WSButtonClickedActionKey withCell:self];
}

@end
