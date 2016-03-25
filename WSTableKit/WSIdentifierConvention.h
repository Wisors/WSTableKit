//
//  WSIdentifierConvention.h
//  WSTableKit
//
//  Created by Alex Nikishin on 25/03/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSIdentifierConvention <NSObject>

- (nonnull NSString *)identifierForClass:(nonnull Class)cellClass;

@end
