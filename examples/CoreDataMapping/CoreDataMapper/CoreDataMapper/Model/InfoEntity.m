//
//  InfoEntity.m
//  CoreDataMapper
//
//  Created by Mahadevan on 15/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import "InfoEntity.h"
#import "WeatherDetailEntity.h"


@implementation InfoEntity

@dynamic icon;
@dynamic main;
@dynamic uId;
@dynamic weatherDescription;
@dynamic weatherDetail;


+(NSString *)getPrimaryKeyProperty {
    return @"uId";
}


+(NSString *)getJsonKeyForPropertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"uId"]) {
        return @"id";
    }
    return nil;
}

+(NSString *)getPropertyNameForJsonKey:(NSString *)jsonKey {
    if ([jsonKey isEqualToString:@"description"]) {
        return @"weatherDescription";
    } else if ([jsonKey isEqualToString:@"id"]) {
        return @"uId";
    }
    return nil;
}

@end
