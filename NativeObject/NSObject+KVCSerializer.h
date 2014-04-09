//
//  NSObject+KVCSerializer.h
//
//  Created by Mahadevan Sreenivasan on 08/04/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

static char const * const ObjectTagKey = "ObjectTag";


@interface NSObject (KVCSerializer)
{
    
}


- (NSString *) getComponentTypeForCollection:(NSString *)propertyName;
+ (NSMutableDictionary *) getPropertiesAndTypesForClassName:(const char *)className;

/*
 * In case you need to use a different property name for a json key, choose
 * from one of the two methods appropriately.
 */
- (NSString *) getPropertyNameForJsonKey:(NSString *)jsonKey;
- (NSString *) getJsonKeyForPropertyName:(NSString *)propertyName;

/*
 * Use the below two methods for deserializing to Objects
 */
+ (NSObject *)jsonToObject:(NSString *) inputJSON fromPath:(NSString *)path;
+ (NSObject *)jsonToObject:(NSString *) inputJSON;
+ (NSObject *)dictionaryToObject:(NSDictionary *) inputDict;
+ (NSArray *)arrayToObjectArray:(NSArray *)inputArray;

//- (NSString *) getJsonKeyForPropertyName:(NSString *)propertyName;
/*
 * Use the below two methods for serializing To JSON or NSDictionary
 */
- (NSDictionary *)objectToDictionary;
- (NSString *)objectToJson;

@end