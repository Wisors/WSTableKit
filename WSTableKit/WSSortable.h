//
//  Sortable.h
//
//  Created by Alex Nikishin on 30/09/15.
//  Copyright © 2015 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSSortable <NSObject>

/**
 *  Define a key that will be used for sorting collection of those objects.
 */
- (NSString *)sortKey;

@end


