A collection of NSObject Extensions which allows to map s JSON / XML ( NSDictionary ) to NSObject / NSManagedObject and vice versa. Say no more to boring manual parsing!


Lets assume there is a sample JSON as below

```javascript
{
    "coord": {
        "lon": 80.28,
        "lat": 13.09
    },
    "sys": {
        "message": 0.0058,
        "country": "IN",
        "sunrise": 1396917015,
        "sunset": 1396961466
    },
    "weather": [
                {
                "id": 801,
                "main": "Clouds",
                "description": "few clouds",
                "icon": "02d"
                },
                {
                "id": 802,
                "main": "Rain",
                "description": "Heavy Rain",
                "icon": "x99"
                }
                ],
    "base": "cmc stations",
    "main": {
        "temp": 316.15,
        "pressure": 1012,
        "humidity": 55,
        "temp_min": 306.15,
        "temp_max": 306.15
    },
    "dt": 1396932000,
    "id": 1264527,
    "name": "MAS",
    "cod": 200
}
```


All you need to do is to create NSObjects / NSManagedObjects which map to the above JSON structure. You can of course leave out properties that are not relevant to you.

Our XCDataModel might look something like this

![Data Model Schema](https://github.com/mahadevans87/NativeObject/raw/master/resources/xcdatamodel_screenshot.png)

```objective-c
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
```
As you can see, several of the property names and JSON keys are similar. Native Object automatically takes care to map these properties. 

For those properties whose names differ from the JSON keys, we have to specify them in the implementation of the model object as below.

In WeatherDetailEntity.m

```objective-c
+(NSString *)getPropertyNameForJsonKey:(NSString *)jsonKey {
    if ([jsonKey isEqualToString:@"weather"]) {
        return @"info";
    } else if ([jsonKey isEqualToString:@"name"]) {
        return @"placeName";
    } else if ([jsonKey isEqualToString:@"id"]) {
        return @"uId";
    }
    return nil;
}
```

Similarly while transforming an object back to JSON, you might need to specify the JSON key for a property name.

```objective-c
+(NSString *)getJsonKeyForPropertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"info"]) {
        return @"weather";
    } else if ([propertyName isEqualToString:@"placeName"]) {
        return @"name";
    }  else if ([propertyName isEqualToString:@"uId"]) {
        return @"id";
    }
    return nil;
}
```

So far so good. If there is a JSON array that we want to map to an NSArray or NSSet (Core Data), we must specify the type of object that we are expecting inside the array. For example, in the sample json, the "weather" key provides us with an array. Ideally we want them to the populated inside InfoEntity objects. For this, lets go ahead and define an InfoEntity class.

```objective-c
@interface InfoEntity : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSNumber * uId;
@property (nonatomic, retain) NSString * weatherDescription;
@property (nonatomic, retain) WeatherDetailEntity *weatherDetail;
```

Now let's go back to the WeatherDetailEntity class and specify that whenever a "weather" object is encountered, fill the array with InfoEntities.

WeatherDetailEntity.m

```objective-c
+(NSString *)getComponentTypeForCollection:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"info"]) {
        return @"InfoEntity";
    }
    return nil;
}
```

Notice how we specified "info" instead of "weather" ? This is because, we mapped the "info" property to the "weather" object earlier in `getPropertyNameForJsonKey`

While working with core data, its always nice if there is a way to automatically insert or update a row. To facilitate this, Native Record has a method `+(NSString *)getPrimaryKeyProperty` which can be overriden by NSManagedObjects. 

WeatherDetailEntity.m

```objective-c
+(NSString *)getPrimaryKeyProperty {
    return @"uId";
}
```

Once you specify the primary key, Native object takes care of inserting or updating a record to the database.

Enough with the setup. To make all this work in your Controller classes takes only a couple of lines of code!

AppDelegate.m

```objective-c
    // Setup CoreData using MagicalRecord
    [MagicalRecord setupCoreDataStack];
    
    // Load the json string from local or a web service
    NSString * jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dummyweather" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    
    // You want the json to be mapped to the WeatherDetailEntity
    NSArray * results = (NSArray *)[WeatherDetailEntity jsonToObject:jsonString];
    WeatherDetailEntity * weatherEn = [results objectAtIndex:0];

    // Save to DB if required.
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    

    // Convert the object back to JSON.
    NSLog(@"%@",[weatherEn objectToJson]);

```

And that's it. There are other methods which will allow  you to start mapping a JSON from a specified path. But let's do that another time. This wiki will hopefully kick start your usage of NativeObject.
