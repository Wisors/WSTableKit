//
//  WSActionTypes.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 13/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

#ifndef WSActionTypes_h
#define WSActionTypes_h

typedef enum : NSUInteger {
    WSActionSelect,
    WSActionDeselect,
    WSActionClick,
    WSActionWillDisplay,
    
} WSActionType;

static inline NSString* ws_convertEnumTypeToString(WSActionType type) {
    switch (type) {
        case WSActionSelect:
            return @"WSActionSelect";
        case WSActionDeselect:
            return @"WSActionDeselect";
        case WSActionClick:
            return @"WSActionClick";
        case WSActionWillDisplay:
            return @"WSActionDisplay";
    }
}

#endif /* WSActionTypes_h */
