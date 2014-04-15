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

+(id)SetupRelationshipsForObject:(id)kvcObject withJsonArray:(NSArray *)jArray componentType:(NSString *)componentType andPropertyName:(NSString *)propertyName {
    BOOL deletedPreviousConnections = NO;
    
    for (NSDictionary * item in jArray) {
        
        Class childClass = NSClassFromString(componentType);
        id kvcChild = [childClass dictionaryToObject:item];
        NSString * capitalisedPropertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                   withString:[[propertyName substringToIndex:1] capitalizedString]];
        
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // We need to remove existing connections to a relationship to avoid duplicates while updating. So remove existing connections
        // and then add new ones!
        if (!deletedPreviousConnections) {
            NSString * delSelName = [NSString stringWithFormat:@"remove%@:",capitalisedPropertyName];
            NSSet * collectionSet = [kvcObject valueForKey:propertyName];
            
            SEL deleteCoreDataAccessorSEL  = NSSelectorFromString(delSelName);
            [kvcObject performSelector:deleteCoreDataAccessorSEL withObject:collectionSet];
            deletedPreviousConnections = YES;
            
        }
        NSString * addSelName = [NSString stringWithFormat:@"add%@Object:",capitalisedPropertyName];
        SEL addCoreDataAccessorSEL  = NSSelectorFromString(addSelName);
        [kvcObject performSelector:addCoreDataAccessorSEL withObject:kvcChild];
#pragma clang diagnostic pop
        
    }
    return kvcObject;
}

@end
