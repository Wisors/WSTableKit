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
#ifdef EMBEDDED_CONTENT_CONTAINS_SWIFT
    return [[NSStringFromClass(cellClass) componentsSeparatedByString:@"."] lastObject]; //For Swift Modules compatibility
#else
    return NSStringFromClass(cellClass);
#endif
}

@end
