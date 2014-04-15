//
//  DateTest.m
//  JSONMapper
//
//  Created by Mahadevan on 10/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import "DateTest.h"

@implementation DateTest


-(id)getPropertyValueForName:(NSString *)propertyName withJsonKey:(NSString *)jsonKey andJsonValue:(NSString *)jsonValue {
    if ([propertyName isEqualToString:@"testDate"]) {
        return [NSDate date];
    }
    return nil;
}

-(id)getJsonValueForName:(NSString *)propertyName withJsonKey:(NSString *)jsonKey andPropertyValue:(id)propertyValue {
    if ([propertyName isEqualToString:@"testDate"]) {
        return @"12/2/2014";
    }
    return nil;
}
@end
