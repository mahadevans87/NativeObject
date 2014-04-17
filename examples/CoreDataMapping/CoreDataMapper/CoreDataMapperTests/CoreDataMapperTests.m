//
//  CoreDataMapperTests.m
//  CoreDataMapperTests
//
//  Created by Mahadevan on 14/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherDetailEntity.h"
#import "MainEntity.h"
#import "InfoEntity.h"

@interface CoreDataMapperTests : XCTestCase
{
    NSString * jsonString;
}
@end

@implementation CoreDataMapperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dummyweather" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testThatASubPathCanBeParsed {
    NSArray * results = (NSArray *)[MainEntity jsonToObject:jsonString fromPath:@"/main"];
    MainEntity * mainEn = [results objectAtIndex:0];
    XCTAssertEqualObjects(mainEn.temp, [NSNumber numberWithFloat:316.15], @"Temp value not same");
    XCTAssertEqualObjects(mainEn.pressure, [NSNumber numberWithInt:1012], @"pressure value not same");
    XCTAssertEqualObjects(mainEn.tempMax, [NSNumber numberWithFloat:306.15], @"Max Temp value not same");
    XCTAssertEqualObjects(mainEn.tempMin, [NSNumber numberWithFloat:306.15], @"Min value not same");

}

-(void)testThatASubArrayCanBeParsed {
    NSArray * results = (NSArray *)[InfoEntity jsonToObject:jsonString fromPath:@"/weather"];
    XCTAssertTrue(results.count == 2, @"Results count must be 2");
    
    InfoEntity * infoEn = [results objectAtIndex:0];
    XCTAssertEqualObjects(infoEn.icon, @"02d", @"");
    XCTAssertEqualObjects(infoEn.main, @"Clouds", @"");
    XCTAssertEqualObjects(infoEn.uId, [NSNumber numberWithInt:801], @"");
    XCTAssertEqualObjects(infoEn.weatherDescription, @"few clouds", @"Weather desc not same");

    InfoEntity * infoEn1 = [results objectAtIndex:1];
    XCTAssertEqualObjects(infoEn1.icon, @"x99", @"");
    XCTAssertEqualObjects(infoEn1.main, @"Rain", @"");
    XCTAssertEqualObjects(infoEn1.uId, [NSNumber numberWithInt:802], @"");
    XCTAssertEqualObjects(infoEn1.weatherDescription, @"Heavy Rain", @"Weather desc not same");

}



@end
