//
//  Checkers_iPadTests.m
//  Checkers_iPadTests
//
//  Created by Dennis Lewandowski on 28/02/14.
//  Copyright (c) 2014 laewahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface Checkers_iPadTests : XCTestCase

@end

@implementation Checkers_iPadTests

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

-(void)testOCMock
{
    id arrayMock = [OCMockObject mockForClass:[NSMutableArray class]];
    [[arrayMock expect] addObject:@"foo"];
    
    [arrayMock addObject:@"foo"];
    
    [arrayMock verify];
}

@end
