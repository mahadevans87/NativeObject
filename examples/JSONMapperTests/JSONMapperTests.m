//
//  JSONMapperTests.m
//  JSONMapperTests
//
//  Created by Mahadevan Sreenivasan on 09/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParentObject.h"
#import "DateTest.h"

@interface JSONMapperTests : XCTestCase

@end

@implementation JSONMapperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGlossarySampleJSON {
    NSString * jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sample_json" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary * jDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];

    NSArray * resultArray = (NSArray *)[ParentObject jsonToObject:jsonString];
    ParentObject * parentObj = [resultArray objectAtIndex:0];
    NSLog(@"%@",[parentObj objectToJson]);
    XCTAssertEqualObjects(parentObj.glossary.title, [[jDict objectForKey:@"glossary"] objectForKey:@"title"], @"Title in glossary obj not same");
}

-(void)testwhetherAclientCanDefineItsOwnMappingForCertainACertainKeyValuePair {
    NSString * jsonString = @"{\"testDate\" : \"2015-02-04T17:33:30.732+0000\"}";
    NSArray * resultArray = (NSArray *)[DateTest jsonToObject:jsonString];
    DateTest * dateTest = [resultArray objectAtIndex:0];
    NSLog(@"%@",dateTest.testDate);
    XCTAssertTrue([dateTest.testDate isKindOfClass:[NSDate class]], @"test Date should be of type NSDate");
}

-(void)testThatAClientRollsoutItsOwnImplementationOfConvertingADateBacktoStringWhileConvertingToJson {
    NSString * jsonString = @"{\"testDate\" : \"2015-02-04T17:33:30.732+0000\"}";
    NSArray * resultArray = (NSArray *)[DateTest jsonToObject:jsonString];
    DateTest * dateTest = [resultArray objectAtIndex:0];
    NSLog(@"JSON reconversion back - result ------> %@",[dateTest objectToJson]);
    NSDictionary * jDict = [NSJSONSerialization JSONObjectWithData:[[dateTest objectToJson] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    XCTAssertTrue([[jDict objectForKey:@"testDate"] isKindOfClass:[NSString class]], @"JSON Date type should be NSString");
    
}

@end
