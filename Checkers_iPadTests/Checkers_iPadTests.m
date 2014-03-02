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

-(void)testOCMock
{
    id arrayMock = [OCMockObject mockForClass:[NSMutableArray class]];
    [[arrayMock expect] addObject:@"foo"];
    
    [arrayMock addObject:@"foo"];
    
    [arrayMock verify];
}

@end
