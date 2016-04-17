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
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 60, self.frame.size.height)];
    [self.button setTitle:@"Click" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:self.button];
}

- (void)buttonClicked:(id)sender {
    [self.item invokeActionForKey:WSButtonClickedActionKey withCell:self];
}

@end
