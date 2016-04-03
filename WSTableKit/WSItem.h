//
//  WSItem.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 03/04/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WSCellClass.h"

@protocol WSItem <NSObject>

@property (nonatomic, assign, nonnull, readonly) Class<WSCellClass> cellClass;
@property (nonatomic, nullable, readonly) id object;

@end
