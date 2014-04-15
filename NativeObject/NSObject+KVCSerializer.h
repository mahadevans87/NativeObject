//
//  NSObject+KVCSerializer.h
//
//  Created by Mahadevan Sreenivasan on 08/04/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"
#import "NSManagedObject+KVCSerializer.h"

static char const * const ObjectTagKey = "ObjectTag";


@interface NSObject (KVCSerializer)
{
    
}


+ (NSString *) getComponentTypeForCollection:(NSString *)propertyName;
+ (NSMutableDictionary *) getPropertiesAndTypesForClassName:(const char *)className;

/*
 * In case you need to use a different property name for a json key, choose
 * from one of the two methods appropriately.
 */
+ (NSString *) getPropertyNameForJsonKey:(NSString *)jsonKey;
+ (NSString *) getJsonKeyForPropertyName:(NSString *)propertyName;

/*
 * In case you need to process a JSON key before assigning it to a property use the below method.
 * Let's say you get a JSON key as { "timeStamp" : "015-02-04T17:33:30.732+0000" } 
 * Poor NativeObject does not know how to map the above String to an NSDate ( since the format is not specified )
 * In such cases, you might want to roll out your own implementation by overriding the below method, set a date formatter to the json value 
 * and return the computed propertyValue back.
 */
+ (id) getPropertyValueForName:(NSString *)propertyName withJsonKey:(NSString *)jsonKey andJsonValue:(NSString *)jsonValue;


/*
 * In case you need to process a property balue before assigning it to a JSON key use the below method.
 * Let's say you have a property NSDate * timeStamp = <NSDate* object>.  You might want to transform this date
 * to a  NSString like this { "timeStamp" : "015-02-04T17:33:30.732+0000" }
 * Poor NativeObject does not know how to map the above NSDate to a String ( since the format is not specified )
 * In such cases, you might want to roll out your own implementation by overriding the below method, set a date formatter to the property Values
 * and return the computed JSONValue back.
 */

+ (id) getJsonValueForName:(NSString *)propertyName withJsonKey:(NSString *)jsonKey andPropertyValue:(id)propertyValue;


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