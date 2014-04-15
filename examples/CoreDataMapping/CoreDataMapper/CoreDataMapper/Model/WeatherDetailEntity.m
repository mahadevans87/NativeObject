//
//  WeatherDetailEntity.m
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import "WeatherDetailEntity.h"
#import "CoordinateEntity.h"
#import "InfoEntity.h"
#import "MainEntity.h"
#import "SystemEntity.h"


@implementation WeatherDetailEntity

@dynamic base;
@dynamic dt;
@dynamic placeName;
@dynamic uId;
@dynamic coord;
@dynamic info;
@dynamic main;
@dynamic sys;


+(NSString *)getPrimaryKeyProperty {
    return @"uId";
}

+(NSString *)getPropertyNameForJsonKey:(NSString *)jsonKey {
    if ([jsonKey isEqualToString:@"weather"]) {
        return @"info";
    } else if ([jsonKey isEqualToString:@"name"]) {
        return @"placeName";
    } else if ([jsonKey isEqualToString:@"id"]) {
        return @"uId";
    }
    return nil;
}

+(NSString *)getJsonKeyForPropertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"info"]) {
        return @"weather";
    } else if ([propertyName isEqualToString:@"placeName"]) {
        return @"name";
    }  else if ([propertyName isEqualToString:@"uId"]) {
        return @"id";
    }
    return nil;
}

+(NSString *)getComponentTypeForCollection:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"info"]) {
        return @"InfoEntity";
    }
    return nil;
}

@end
