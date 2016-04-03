//
//  WSActionTypes.h
//  WSTableKit
//
//  Created by Alexandr Nikishin on 13/02/16.
//  Copyright © 2016 Alex Nikishin. All rights reserved.
//

typedef enum : NSUInteger {
    WSActionAdjustment,
    WSActionSelect,
    WSActionDeselect,
    WSActionWillSelect,
    WSActionWillDeselect,
    WSActionClick,
    WSActionWillDisplay,
    WSActionEndDisplay,
    WSActionShouldHiglight
} WSActionType;

static inline NSString* ws_convertEnumTypeToString(WSActionType type) {
    switch (type) {
        case WSActionAdjustment:
            return @"WSActionAdjustment"; //Special type
        case WSActionSelect:
            return @"WSActionSelect";
        case WSActionDeselect:
            return @"WSActionDeselect";
        case WSActionWillSelect:
            return @"WSActionWillSelect";
        case WSActionWillDeselect:
            return @"WSActionWillDeselect";
        case WSActionClick:
            return @"WSActionClick";
        case WSActionWillDisplay:
            return @"WSActionDisplay";
        case WSActionEndDisplay:
            return @"WSActionEndDisplay";
        case WSActionShouldHiglight:
            return @"WSActionShouldHiglight";
    }
}
