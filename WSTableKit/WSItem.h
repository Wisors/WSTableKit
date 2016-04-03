//
//  WSItem.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"
#import "WSActionsHolder.h"

@protocol WSItem <NSObject>

@property (nonatomic, assign, nonnull, readonly) Class<WSCellClass> viewClass;
@property (nonatomic, nullable, readonly) id object;
@property (nonatomic, nonnull, readonly) WSActionsHolder *actionsHolder;
@property (nonatomic, nullable) WSAction *adjustment;

@end
