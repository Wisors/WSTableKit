//
//  CellWithButton.h
//  WSTableKit
//
//  Created by Alex Nikishin on 28/01/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSTableViewCell.h"

static NSString * const WSButtonClickedActionKey = @"WSButtonClickedActionKey";

@interface CellWithButton : WSTableViewCell

@property (strong) UIButton *button;

@end
