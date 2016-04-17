//
//  WSTestClassHeaderFooterView.m
//  WSTableKit
//
//  Created by Alexandr Nikishin on 17/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSTestClassHeaderFooterView.h"

@implementation WSTestClassHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        _titleLabel = [UILabel new];
    }
    
    return self;
}

@end
