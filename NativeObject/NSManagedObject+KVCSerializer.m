//
//  NSManagedObject+KVCSerializer.m
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import "NSManagedObject+KVCSerializer.h"

@implementation NSManagedObject (KVCSerializer)

+(NSString *)getPrimaryKeyProperty {
    return nil;
}

+(NSManagedObject *)createOrUpdateManagedObjectWithJSONMap:(NSDictionary *)inputDict andPropertyMap:(NSDictionary *)propertyMap {
    
    NSManagedObject * kvcObject = nil;
    NSString * primaryKeyProperty = [[self class] getPrimaryKeyProperty];
    
    if (primaryKeyProperty.length == 0) {
        NSLog(@"No primary key specified - Creating %@",NSStringFromClass([self class]));
        kvcObject = [[self class] MR_createEntity];
    } else {
        NSString * jsonKey = nil;
        jsonKey = [[self class] getJsonKeyForPropertyName:primaryKeyProperty];
        if (jsonKey.length == 0) {
            NSLog(@"getJsonKeyForPropertyName for %@ is not implemented.Defaulting to %@",primaryKeyProperty,primaryKeyProperty);
            jsonKey = primaryKeyProperty;
        }
        NSString * jsonValue = [inputDict objectForKey:jsonKey];
        kvcObject = [[self class] MR_findFirstByAttribute:primaryKeyProperty withValue:jsonValue];
        if (!kvcObject) {
            kvcObject = [[self class] MR_createEntity];
            NSLog(@"No object found for %@ - Creating %@",jsonValue, NSStringFromClass([self class]));
        } else {
            NSLog(@"Object found for %@ - Updating %@",jsonValue, NSStringFromClass([self class]));
        }
    }
    
    return kvcObject;
}


@end
