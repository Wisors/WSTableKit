//
//  WSDefaultIdentifierConvention.m
//  WSTableKit
//
//  Created by Alex Nikishin on 25/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import "WSDefaultIdentifierConvention.h"

@implementation WSDefaultIdentifierConvention

- (NSString *)identifierForClass:(Class)cellClass {
#ifdef STRICT_OBJC
    return NSStringFromClass(cellClass);
#else
    return [[NSStringFromClass(cellClass) componentsSeparatedByString:@"."] lastObject]; //For Swift Modules compatibility
#endif
}

@end
