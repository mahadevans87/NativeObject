//
//  NSObject+KVCSerializer.h
//
//  Created by Mahadevan Sreenivasan on 08/04/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "NSObject+KVCSerializer.h"

@implementation NSObject(KVCSerializer)

const char * property_getTypeString( objc_property_t property );



-(BOOL)traversed {
    NSNumber * tNumber = objc_getAssociatedObject(self, ObjectTagKey);
    return [tNumber boolValue];
}

-(void)setTraversed:(BOOL)bTraversed {
    objc_setAssociatedObject(self, ObjectTagKey, [NSNumber numberWithBool:bTraversed], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSString *) getJsonKeyForPropertyName:(NSString *)propertyName {
    
    return nil;
}

/*
 * Should be implemented by subclasses using NSArray types.
 */
- (NSString *)getComponentTypeForCollection:(NSString *)propertyName {
    return nil;
}

/*
 * Should be implemented by subclasses that will have a different propertyName for a json key.
 */
- (NSString *) getPropertyNameForJsonKey:(NSString *)jsonKey {
    return nil;
}


-(id) getPropertyValueForName:(NSString *)propertyName withJsonKey:(NSString *)jsonKey andJsonValue:(NSString *)jsonValue {
    return nil;
}

-(id) getJsonValueForName:(NSString *)propertyName withJsonKey:(NSString *)jsonKey andPropertyValue:(id)propertyValue {
    return nil;
}

/*
 * Primary method to convert an input JSON to an NSObject / NSManagedObject
 */

+ (id)jsonToObject:(NSString *) inputJSON {
    return [self jsonToObject:inputJSON fromPath:nil];
}

/*
 * Primary method to convert an input JSON to an NSObject / NSManagedObject. This method
 * will also allow the client to pass in a json path to a sub dictionary.
 * eg : parent : { child : { grandchild : { data we are interested in } }}
 * By specifiying "/child/grandchild" in the path, we can get the data we are interested in alone.
 */

+ (id)jsonToObject:(NSString *) inputJSON fromPath:(NSString *)path{
    
    
    id jObject = [NSJSONSerialization JSONObjectWithData:[inputJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    if ([jObject isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary * jDict = (NSDictionary *)jObject;
        if (path.length > 0) {
            NSArray * pathComponents = [path componentsSeparatedByString:@"/"];
            for (NSString * pathComponent in pathComponents) {
                id subObject = [jDict objectForKey:pathComponent];
                if (subObject == nil) {
                    continue;
                }
                if ([subObject isKindOfClass:[NSDictionary class]]){
                    jDict = (NSDictionary *)subObject;
                } else if ([subObject isKindOfClass:[NSArray class]]){
                    return [self arrayToObjectArray:(NSArray *)subObject];
                }
                
            }
        }
        return [NSArray arrayWithObject:[self dictionaryToObject:jDict]];
        
    } else if ([jObject isKindOfClass:[NSArray class]]) {
        return [self arrayToObjectArray:(NSArray *)jObject];
    } else {
        return nil;
    }
}


const char * property_getTypeString( objc_property_t property )
{
    const char * attrs = property_getAttributes( property );
    if ( attrs == NULL )
        return ( NULL );
    
    static char buffer[256];
    const char * e = strchr( attrs, ',' );
    if ( e == NULL )
        return ( NULL );
    
    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';
    
    return ( buffer );
}

+ (BOOL) hasPropertyNamed: (NSString *) name
{
    return ( class_getProperty(self, [name UTF8String]) != NULL );
}


+ (BOOL) hasPropertyForKVCKey: (NSString *) key
{
    if ( [self hasPropertyNamed: key] )
        return ( YES );
    
    return NO;
}

+ (char *) typeOfPropertyNamed: (const char *) rawPropType
{
    int k = 0;
    char * parsedPropertyType = malloc(sizeof(char*) * 16);
    if (*rawPropType == 'T') {
        rawPropType++;
    } else {
        rawPropType = NULL;
    }
    
    if (rawPropType == NULL) {
        free(parsedPropertyType);
        
        return NULL;
    }
    if (*rawPropType == '@') {
        rawPropType+=2;
        for (; *rawPropType != '\"';) {
            parsedPropertyType[k++] = *rawPropType;
            rawPropType++;
        }
        parsedPropertyType[k] = '\0';
        return parsedPropertyType;
        
    } else if (*rawPropType == 'i' || *rawPropType == 'q'){
        parsedPropertyType = strcpy(parsedPropertyType,"NSInteger\0");
        return parsedPropertyType;
    } else if (*rawPropType == 'd'){
        parsedPropertyType = strcpy(parsedPropertyType,"double\0");
        return parsedPropertyType;
    } else if (*rawPropType == 'f') {
        parsedPropertyType = strcpy(parsedPropertyType,"float\0");
        return parsedPropertyType;
    } else if (*rawPropType == 'c') {
        parsedPropertyType = strcpy(parsedPropertyType,"BOOL\0");
        return parsedPropertyType;
    }
    
    free(parsedPropertyType);
    
    return ( NULL );
}




+ (NSMutableDictionary *) getPropertiesAndTypesForClassName:(const char *)className {
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    id class = objc_getClass(className);
    if ( ([class superclass] != [NSObject class])) {
        //[dict release];
        dict = [NSObject getPropertiesAndTypesForClassName:class_getName([class superclass])]; //retain];
    }
    unsigned int outCount, i; objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char * propName = property_getName(property);
        NSString * propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
        const char * rawPropType = property_getTypeString(property);
        const char * objCType = [self typeOfPropertyNamed:rawPropType];
        if (objCType == NULL) {
            NSLog(@"Invalid property type for propertyName %@. Skip ", propertyName);
        } else {
            NSString * propertyType = [NSString stringWithCString:objCType encoding:NSUTF8StringEncoding];
            
            [dict setValue:propertyType forKey:propertyName];
        }
        if (objCType != NULL)
            free((char *)objCType);
        
    }
    free(properties);
    return dict; //autorelease];
}

+(BOOL) isPropertyTypeArray:(NSString *)propertyType {
    if ([propertyType isEqualToString:@"NSArray"] ||
        [propertyType isEqualToString:@"NSMutableArray"]) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL) isPropertyTypeSet:(NSString *)propertyType {
    if ([propertyType isEqualToString:@"NSSet"] ||
        [propertyType isEqualToString:@"NSMutableSet"]) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL) isPropertyTypeBasic:(NSString *)propertyType {
    if ([propertyType isEqualToString:@"NSString"] ||
        [propertyType isEqualToString:@"NSNumber"] ||
        [propertyType isEqualToString:@"NSInteger"] ||
        [propertyType isEqualToString:@"float"] ||
        [propertyType isEqualToString:@"double"] ||
        [propertyType isEqualToString:@"BOOL"]) {
        
        return YES;
    } else {
        return NO;
    }
}

+(BOOL) isPropertyTypeDate:(NSString *)propertyType {
    if ([propertyType isEqualToString:@"NSDate"]) {
        return YES;
    }
    return NO;
}

+(id) objectForPropertyKey:(NSString *)propertyType {
    id kvcObject = [[NSClassFromString(propertyType) alloc] init];
    return kvcObject; //autorelease];
}

+ (NSArray *)arrayForType:(NSString *)componentType withJSONArray:(NSArray *)jArray {
    if ([componentType isEqualToString:@"NSString"] ||
        [componentType isEqualToString:@"NSNumber"]) {
        return [NSArray arrayWithArray:jArray];
    }
    
    /*
     * Now for some good object mapping
     * with classic recursion!
     */
    
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * item in jArray) {
        Class childClass = NSClassFromString(componentType);
        id kvcChild = [childClass dictionaryToObject:item];
        [resultArray addObject:kvcChild];
    }
    
    return resultArray;// autorelease];
}

+ (id)dictionaryToObject:(NSDictionary *) inputDict {
    if ([inputDict isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    const char* className = class_getName([self class]);
    NSDictionary * propertyDict = [self getPropertiesAndTypesForClassName:className];
    NSArray * propertyKeys = [propertyDict allKeys];
    
    //Create our object
    id kvcObject = nil;
    Class classType =  NSClassFromString([NSString stringWithCString:className encoding:NSUTF8StringEncoding]);
    if ([[self class] isSubclassOfClass:[NSManagedObject class]]) {
        kvcObject = [[self class] MR_createEntity];
    } else {
        kvcObject = [[classType alloc] init];
    }
    
    for (NSString * key in [inputDict allKeys]) {
        //id propertyValue = [inputDict objectForKey:key];
        
        NSString * propertyName = key;
        if (![propertyKeys containsObject:key]) {
            propertyName = [kvcObject getPropertyNameForJsonKey:key];
        }
        if (propertyName) {
            NSString * propType = [propertyDict objectForKey:propertyName];
            /*
             * Sometimes an invalid property type can be used by the client object.
             * Gracefully ignore it.
             */
            if (propType == nil) {
                continue;
            }
            
            id propertyValue = [kvcObject getPropertyValueForName:propertyName withJsonKey:key andJsonValue:[inputDict objectForKey:key]];
            
            if (propertyValue != nil) {
                [kvcObject setValue:propertyValue forKey:propertyName];
                
            } else {
                propertyValue = [inputDict objectForKey:key];
                /*
                 * If the property type in an NSArray or NSMutable Array fill it with the component type
                 * NSManagedObjects usually has collections as NSSet's which is handled in the next case.
                 */
                if ([NSObject isPropertyTypeArray:propType]) {
                    NSString * componentType = [kvcObject getComponentTypeForCollection:propertyName];
                    NSArray  * jArray = (NSArray *)propertyValue;
                    
                    if ([[self class] isSubclassOfClass:[NSObject class]]) {
                        // If the object has specified a type, create objects of that type. else
                        // set the array as such.
                        if ([componentType length] > 1) {
                            NSArray * componentArray = [NSObject arrayForType:componentType withJSONArray:jArray];
                            [kvcObject setValue:componentArray forKey:propertyName];
                        } else {
                            [kvcObject setValue:jArray forKey:propertyName];
                        }
                    }
                    
                } /*
                   * If the collection is an NSSet and the object is an NSManagedObject, we cannot simply add the relationship object to the set.
                   * Instead we have to call the add'RelationshipEntity'Object: which is specified in the CoreDataAccessors for that entity.
                   */
                else if ([NSObject isPropertyTypeSet:propType]) {
                    NSString * componentType = [kvcObject getComponentTypeForCollection:propertyName];
                    NSArray  * jArray = (NSArray *)propertyValue;
                    
                    if ([[self class] isSubclassOfClass:[NSManagedObject class]]) {
                        for (NSDictionary * item in jArray) {
                            Class childClass = NSClassFromString(componentType);
                            id kvcChild = [childClass dictionaryToObject:item];
                            NSString * capitalisedPropertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                                       withString:[[propertyName substringToIndex:1] capitalizedString]];
                            
                            NSString * selName = [NSString stringWithFormat:@"add%@Object:",capitalisedPropertyName];
                            SEL coreDataAccessorSEL  = NSSelectorFromString(selName);
                            [kvcObject performSelector:coreDataAccessorSEL withObject:kvcChild];
                        }
                    }
                    
                } else if ([NSObject isPropertyTypeBasic:propType]) {
                    
                    [kvcObject setValue:propertyValue forKey:propertyName];
                    
                } else {
                    /*
                     * If the component is not any primitive type or array
                     * create a custom object of it and pass the dictionary to it.
                     */
                    Class childClass = NSClassFromString(propType);
                    if ([childClass isSubclassOfClass:[NSObject class]]) {
                        id kvcChild = [childClass dictionaryToObject:propertyValue];
                        [kvcObject setValue:kvcChild forKey:propertyName];
                    } else {
                        [kvcObject setValue:propertyValue forKey:propertyName];
                    }
                }
            }
            
        }
        
        
    }
    return kvcObject;// autorelease];
}

- (NSString *)customKeyForPropertyName:(NSString *)propertyName {
    NSString * customJsonKey = [self getJsonKeyForPropertyName:propertyName];
    if (customJsonKey == nil) {
        return propertyName;
    } else {
        return customJsonKey;
    }
}

- (NSDictionary *)objectToDictionary {
    
    [self setTraversed:YES];
    
    const char* className = class_getName([self class]);
    NSDictionary * propertyDict = [NSObject getPropertiesAndTypesForClassName:className];
    
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] init];
    for (NSString * currentProperty in propertyDict) {
        
        NSString * propType = [propertyDict objectForKey:currentProperty];
        
        /*
         
         * Gracefully ignore it.
         */
        if (propType == nil) {
            continue;
        }
        
        id propValue = [self valueForKey:currentProperty];
        
        id customValue = [self getJsonValueForName:currentProperty withJsonKey:[self customKeyForPropertyName:currentProperty] andPropertyValue:propValue];
        if (customValue != nil) {
            [resultDict setValue:customValue forKey:[self customKeyForPropertyName:currentProperty]];

        } else {
            
            if ([NSObject isPropertyTypeArray:propType]) {
                
                NSArray * objArray = [self valueForKey:currentProperty];
                if ([objArray count] > 0) {
                    id firstObject = [objArray objectAtIndex:0];
                    if ([firstObject isKindOfClass:[NSString class]] ||
                        [firstObject isKindOfClass:[NSNumber class]]) {
                        
                        [resultDict setValue:objArray forKey:[self customKeyForPropertyName:currentProperty]];
                        
                    } else {
                        
                        NSMutableArray * customObjArray = [[NSMutableArray alloc] init];
                        for (id arrayObj in objArray) {
                            if ([arrayObj isKindOfClass:[NSObject class]]){
                                NSDictionary * childDict = [arrayObj objectToDictionary];
                                [customObjArray addObject:childDict];
                            }
                        }
                        [resultDict setValue:customObjArray forKey:[self customKeyForPropertyName:currentProperty]];
                        //[customObjArray release];
                        
                    }
                } else {
                    NSArray * emptyArray = [[NSArray alloc] init];
                    [resultDict setValue:emptyArray forKey:[self customKeyForPropertyName:currentProperty]];
                    //[emptyArray release];
                }
                
            } else if ([NSObject isPropertyTypeSet:propType]) {
#warning Code Smell!
                /*
                 * if the collection is a set, why not convert it to an array :)
                 * The below part needs cleanup. Code smell. Repetitive code
                 */
                
                NSSet * objSet = [self valueForKey:currentProperty];
                if (objSet.count > 0) {
                    NSArray * objArray = [objSet allObjects];
                    if ([objArray count] > 0) {
                        id firstObject = [objArray objectAtIndex:0];
                        /*
                         * If the array is full of primitive elements, set it to the JSON as such
                         */
                        
                        if ([firstObject isKindOfClass:[NSString class]] ||
                            [firstObject isKindOfClass:[NSNumber class]]) {
                            
                            [resultDict setValue:objArray forKey:[self customKeyForPropertyName:currentProperty]];
                            
                        } else {
                            
                            /*
                             * If the array is made up of custom nsobjects, serialize them too
                             */
                            NSMutableArray * customObjArray = [[NSMutableArray alloc] init];
                            for (id arrayObj in objArray) {
                                if ([arrayObj isKindOfClass:[NSObject class]]){
                                    NSDictionary * childDict = [arrayObj objectToDictionary];
                                    [customObjArray addObject:childDict];
                                }
                            }
                            [resultDict setValue:customObjArray forKey:[self customKeyForPropertyName:currentProperty]];
                            //[customObjArray release];
                            
                        }
                    }
                    
                } else {
                    NSArray * emptyArray = [[NSArray alloc] init];
                    [resultDict setValue:emptyArray forKey:[self customKeyForPropertyName:currentProperty]];
                    //[emptyArray release];
                }
                
                
            } else if ([NSObject isPropertyTypeBasic:propType]) {
                
                id basicValue = [self valueForKey:currentProperty];
                if (basicValue == nil) {
                    basicValue = @"";
                }
                [resultDict setValue:basicValue forKey:[self customKeyForPropertyName:currentProperty]];
                
            } else {
                
                id kvcChild = [self valueForKey:currentProperty];
                if (kvcChild == nil) {
                    if ([[kvcChild class] isSubclassOfClass:[NSManagedObject class]]) {
                        kvcChild = [[kvcChild class] MR_createEntity];
                    } else if ([[kvcChild class] isSubclassOfClass:[NSObject class]]) {
                        kvcChild = [[NSObject alloc] init]; //autorelease];
                    }
                }
                if ([kvcChild isKindOfClass:[NSObject class]]) {
                    if (![kvcChild traversed]) {
                        NSDictionary * childDict = [kvcChild objectToDictionary];
                        [resultDict setValue:childDict forKey:[self customKeyForPropertyName:currentProperty]];
                    }
                }
                
            }

        }
        
        
    }
    return resultDict; //autorelease];
}

+(NSArray *)arrayToObjectArray:(NSArray *)inputArray  {
    NSMutableArray * resultArr = [[NSMutableArray alloc] initWithCapacity:inputArray.count];
    for (NSDictionary * dict in inputArray) {
        [resultArr addObject:[[self class] dictionaryToObject:dict]];
    }
    return resultArr;
}

- (NSString *)objectToJson {
    
    id objectToConvert = nil;
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray * objArray = (NSArray *)self;
        NSMutableArray * jArray = [[NSMutableArray alloc] initWithCapacity:objArray.count];
        for (NSObject * obj in objArray) {
            [jArray addObject:[obj objectToDictionary]];
        }
        
        objectToConvert = jArray;
    } else {
        objectToConvert = [self objectToDictionary];
    }
    
    NSError * error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objectToConvert
                                                       options:0
                                                         error:&error];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString; //autorelease];
}


@end
