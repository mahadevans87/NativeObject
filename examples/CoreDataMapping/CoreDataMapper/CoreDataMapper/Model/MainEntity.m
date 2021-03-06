//
//  MainEntity.m
//  CoreDataMapper
//
//  Created by Mahadevan on 15/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import "MainEntity.h"
#import "WeatherDetailEntity.h"


@implementation MainEntity

@dynamic humidity;
@dynamic pressure;
@dynamic temp;
@dynamic tempMax;
@dynamic tempMin;
@dynamic weatherDetail;


+(NSString*)getJsonKeyForPropertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"tempMax"]) {
        return @"temp_max";
    } else     if ([propertyName isEqualToString:@"tempMin"]) {
        return @"temp_min";
    }
    return nil;
}

+(NSString*)getPropertyNameForJsonKey:(NSString *)jsonKey {
    if ([jsonKey isEqualToString:@"temp_max"]) {
        return @"tempMax";
    } else     if ([jsonKey isEqualToString:@"temp_min"]) {
        return @"tempMin";
    }
    return nil;
}

@end
