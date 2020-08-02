// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSAbstractLogInternal.h"
#import "MSLogWithProperties.h"
#import "MSTestFrameworks.h"
#import "MSUtility.h"

@interface MSLogWithPropertiesTests : XCTestCase

@property(nonatomic) MSLogWithProperties *sut;

@end

@implementation MSLogWithPropertiesTests

#pragma mark - Housekeeping

- (void)setUp {
  [super setUp];
  self.sut = [MSLogWithProperties new];
}

- (void)tearDown {
  [super tearDown];
}

#pragma mark - Tests

- (void)testSerializingDeviceToDictionaryWorks {

  // If
  NSDictionary *properties = @{ @"key1" : @"value1", @"key2" : @"value" };
  self.sut.properties = properties;

  // When
  NSMutableDictionary *actual = [self.sut serializeToDictionary];

  // Then
  assertThat(actual, notNilValue());
  assertThat(actual[@"properties"], equalTo(properties));
}

- (void)testNSCodingSerializationAndDeserializationWorks {

  // If
  NSDictionary *properties = @{ @"key1" : @"value1", @"key2" : @"value" };
  self.sut.properties = properties;

  // When
  NSData *serializedEvent = [MSUtility archiveKeyedData:self.sut];
  id actual = [MSUtility unarchiveKeyedData:serializedEvent];

  // Then
  assertThat(actual, notNilValue());
  assertThat(actual, instanceOf([MSLogWithProperties class]));

  MSLogWithProperties *actualLogWithProperties = actual;
  assertThat(actualLogWithProperties.properties, equalTo(properties));
}

- (void)testIsEqual {

  // If
  NSDictionary *properties = @{ @"key1" : @"value1", @"key2" : @"value" };
  self.sut.properties = properties;

  // When
  NSData *serializedEvent = [MSUtility archiveKeyedData:self.sut];
  id actual = [MSUtility unarchiveKeyedData:serializedEvent];
  MSLogWithProperties *actualLogWithProperties = actual;

  // then
  XCTAssertTrue([self.sut.properties isEqual:actualLogWithProperties.properties]);
}

- (void)testIsNotEqualToNil {

  // Then
  XCTAssertFalse([self.sut isEqual:nil]);
}

@end
