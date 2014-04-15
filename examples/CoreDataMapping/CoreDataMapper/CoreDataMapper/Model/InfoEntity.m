//
//  InfoEntity.m
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
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

+(NSString *)getPrimaryKeyOfJsonObject {
    return @"id";
}


-(NSString *)getPropertyNameForJsonKey:(NSString *)jsonKey {
    if ([jsonKey isEqualToString:@"description"]) {
        return @"weatherDescription";
    }
    return nil;
}

@end
