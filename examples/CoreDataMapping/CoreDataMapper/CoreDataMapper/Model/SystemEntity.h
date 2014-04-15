//
//  SystemEntity.h
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherDetailEntity;

@interface SystemEntity : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * message;
@property (nonatomic, retain) NSNumber * sunrise;
@property (nonatomic, retain) NSNumber * sunset;
@property (nonatomic, retain) WeatherDetailEntity *weatherDetail;

@end
