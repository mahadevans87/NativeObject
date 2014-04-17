NativeObject
============

A collection of NSObject Extensions which allows to map s JSON / XML ( NSDictionary ) to NSObject / NSManagedObject and vice versa. Say no more to boring manual parsing!


Lets assume there is a sample JSON as below

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

All you need to do is to create NSObjects / NSManagedObjects which map to the above JSON structure. You can of course leave out properties that are not 
relevant to you.




1. Convert a nested JSON / Dictionary to an NSObject / NSManagedObject automatically.



