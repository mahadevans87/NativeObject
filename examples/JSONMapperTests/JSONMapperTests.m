//
//  JSONMapperTests.m
//  JSONMapperTests
//
//  Created by Mahadevan Sreenivasan on 09/04/14.
//  Copyright (c) 2014 Mahadevan Sreenivasan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ParentObject.h"

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
    XCTAssertEqualObjects(parentObj.glossary.title, [[jDict objectForKey:@"glossary"] objectForKey:@"title"], @"Title in glossary obj not same");
}

@end
