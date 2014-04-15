//
//  WeatherDetailEntity.h
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CoordinateEntity, InfoEntity, MainEntity, SystemEntity;

@interface WeatherDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * base;
@property (nonatomic, retain) NSNumber * dt;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSNumber * uId;
@property (nonatomic, retain) CoordinateEntity *coord;
@property (nonatomic, retain) NSSet *info;
@property (nonatomic, retain) MainEntity *main;
@property (nonatomic, retain) SystemEntity *sys;
@end

@interface WeatherDetailEntity (CoreDataGeneratedAccessors)

- (void)addInfoObject:(InfoEntity *)value;
- (void)removeInfoObject:(InfoEntity *)value;
- (void)addInfo:(NSSet *)values;
- (void)removeInfo:(NSSet *)values;

@end
