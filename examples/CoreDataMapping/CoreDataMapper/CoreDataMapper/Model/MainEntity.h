//
//  MainEntity.h
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherDetailEntity;

@interface MainEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSNumber * tempMax;
@property (nonatomic, retain) NSNumber * tempMin;
@property (nonatomic, retain) WeatherDetailEntity *weatherDetail;

@end
