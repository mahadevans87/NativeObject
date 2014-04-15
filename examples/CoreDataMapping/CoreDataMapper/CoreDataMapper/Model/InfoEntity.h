//
//  InfoEntity.h
//  CoreDataMapper
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherDetailEntity;

@interface InfoEntity : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSNumber * uId;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) WeatherDetailEntity *weatherDetail;

@end
