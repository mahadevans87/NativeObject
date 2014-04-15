//
//  NSManagedObject+KVCSerializer.h
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (KVCSerializer)


+(NSString *)getPrimaryKeyProperty;

@end
