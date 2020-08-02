// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSConstants+Internal.h"
#import "MSDispatcherUtil.h"
#import "MSTestFrameworks.h"
#import "MSUtility+ApplicationPrivate.h"
#import "MSUtility+Date.h"
#import "MSUtility+Environment.h"
#import "MSUtility+File.h"
#import "MSUtility+PropertyValidation.h"
#import "MSUtility+StringFormatting.h"

static NSTimeInterval const kMSTestTimeout = 1.0;

@interface MSUtilityTests : XCTestCase

@property(nonatomic) id utils;

@end

@implementation MSUtilityTests

- (void)setUp {
  [super setUp];

  // Set up application mock.
  self.utils = OCMClassMock([MSUtility class]);
}

- (void)tearDown {
  [super tearDown];
  [self.utils stopMocking];
  [MSUtility deleteItemForPathComponent:@"testing"];
}

#pragma mark - MSUtility.h

- (void)testSdkName {
  NSString *name = [NSString stringWithUTF8String:APP_CENTER_C_NAME];
  XCTAssertTrue([[MSUtility sdkName] isEqualToString:name]);
}

- (void)testSdkVersion {
  NSString *version = [NSString stringWithUTF8String:APP_CENTER_C_VERSION];
  XCTAssertTrue([[MSUtility sdkVersion] isEqualToString:version]);
}

#pragma mark - MSUtility+Application.h

#if !TARGET_OS_OSX && !TARGET_OS_MACCATALYST
- (void)testMSAppStateMatchesUIAppStateWhenAvailable {

  // Then
  assertThat(@([MSUtility applicationState]), is(@([UIApplication sharedApplication].applicationState)));
}
#endif

- (void)testMSAppReturnsUnknownOnAppExtensions {

  // If
  // Mock the helper itself to monitor method calls.
  id bundleMock = OCMClassMock([NSBundle class]);
  OCMStub([bundleMock executablePath]).andReturn(@"/apath/coolappext.appex/coolappext");
  OCMStub([bundleMock mainBundle]).andReturn(bundleMock);
  OCMReject([self.utils sharedAppState]);

  // Then
  assertThat(@([MSUtility applicationState]), is(@(MSApplicationStateUnknown)));

  // Make sure the sharedApplication as not been called, it's forbidden within
  // app extensions
  [bundleMock stopMocking];
}

- (void)testAppActive {

// If
#if TARGET_OS_OSX
  MSApplicationState expectedState = MSApplicationStateActive;
  OCMStub([self.utils sharedAppState]).andReturn(expectedState);
#else
  UIApplicationState expectedState = UIApplicationStateActive;
  OCMStub([self.utils sharedAppState]).andReturn(expectedState);
#endif

  // When
  MSApplicationState state = [MSUtility applicationState];

  // Then
  assertThat(@(state), is(@(expectedState)));
}

#if !TARGET_OS_OSX && !TARGET_OS_MACCATALYST
- (void)testAppInactive {

  // If
  UIApplicationState expectedState = UIApplicationStateInactive;
  OCMStub([self.utils sharedAppState]).andReturn(expectedState);

  // When
  MSApplicationState state = [MSUtility applicationState];

  // Then
  assertThat(@(state), is(@(expectedState)));
}
#endif

- (void)testAppInBackground {

// If
#if TARGET_OS_OSX
  MSApplicationState expectedState = MSApplicationStateBackground;
  OCMStub([self.utils sharedAppState]).andReturn(expectedState);
#else
  UIApplicationState expectedState = UIApplicationStateBackground;
  OCMStub([self.utils sharedAppState]).andReturn(expectedState);
#endif

  // When
  MSApplicationState state = [MSUtility applicationState];

  // Then
  assertThat(@(state), is(@(expectedState)));
}

- (void)testCurrentAppEnvironment {

  // When
  MSEnvironment env = [MSUtility currentAppEnvironment];

  // Then
  // Tests always run in simulators.
  XCTAssertEqual(env, MSEnvironmentOther);
}

#pragma mark - MSUtility+Date.h

- (void)testNowInMilliseconds {

  // If
  NSDate *date = [NSDate date];
  id dateMock = OCMClassMock([NSDate class]);
  OCMStub([dateMock date]).andReturn(date);

  // When
  long long actual = (long long)([MSUtility nowInMilliseconds] / 10);
  long long expected = (long long)([[NSDate date] timeIntervalSince1970] * 100);

  // Then
  XCTAssertEqual(actual, expected);

  // Negative in case of cast issue.
  XCTAssertGreaterThan(actual, 0);
}

#pragma mark - MSUtility+Environment.h

// FIXME: This method actually opens a dialog to ask to handle the URL on Mac.
#if !TARGET_OS_OSX && !TARGET_OS_MACCATALYST
- (void)testSharedAppOpenEmptyCallCallback {

  // If
  XCTestExpectation *openURLCalledExpectation = [self expectationWithDescription:@"openURL Called."];
  __block BOOL handlerHasBeenCalled = NO;

  // When
  [MSUtility sharedAppOpenUrl:[NSURL URLWithString:@""]
                      options:@{}
            completionHandler:^(MSOpenURLState status) {
              handlerHasBeenCalled = YES;
              XCTAssertEqual(status, MSOpenURLStateFailed);
            }];
  dispatch_async(dispatch_get_main_queue(), ^{
    [openURLCalledExpectation fulfill];
  });

  // Then
  [self waitForExpectationsWithTimeout:kMSTestTimeout
                               handler:^(NSError *error) {
                                 XCTAssertTrue(handlerHasBeenCalled);
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@", error);
                                 }
                               }];
}
#endif

#pragma mark - MSUtility+StringFormatting.h

- (void)testCreateSha256 {

  // When
  NSString *test = @"TestString";
  NSString *result = [MSUtility sha256:test];

  // Then
  XCTAssertTrue([result isEqualToString:@"6dd79f2770a0bb38073b814a5ff000647b37be5abbde71ec9176c6ce0cb32a27"]);
}

- (void)testPrettyPrintNil {
  XCTAssertNil([MSUtility prettyPrintJson:nil]);
}

- (void)testPrettyPrintNotJson {
  NSString *nonJson = @"[test] some non json string";
  XCTAssertTrue([[MSUtility prettyPrintJson:[nonJson dataUsingEncoding:NSUTF8StringEncoding]] isEqualToString:nonJson]);
}

- (void)testPrettyPrintJson {
  XCTAssertTrue([[MSUtility prettyPrintJson:[@"{\"a\":1}" dataUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"{\n  \"a\" : 1\n}"]);
}

#pragma mark - MSUtility+PropertyValidation.h

- (void)testAppSecretFrom {

  // When
  NSString *uuidString = MS_UUID_STRING;

  // Then
  NSString *result = [MSUtility appSecretFrom:uuidString];
  XCTAssertEqualObjects(uuidString, result);

  // When
  NSString *test = nil;
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = [NSString stringWithFormat:@"%@;", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"%@;target={transmissionTargetToken}", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"%@;target={transmissionTargetToken};", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"target={transmissionTargetToken};%@", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"target={transmissionTargetToken};%@;", uuidString];

  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = @"target={transmissionTargetToken}";
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = @"target={transmissionTargetToken};";
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = [NSString stringWithFormat:@"appsecret=%@;target={transmissionTargetToken};", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"appsecret=%@;", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"appsecret=%@", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"target={transmissionTargetToken};appsecret=%@;", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"target={transmissionTargetToken};appsecret=%@", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);
#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST
  // When
  test = [NSString stringWithFormat:@"targetIos={transmissionTargetToken};ios=%@", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = [NSString stringWithFormat:@"macos=fake;ios=%@", uuidString];
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(uuidString, result);

  // When
  test = @"ios={app-secret};macos={fake};appsecret=fake";
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{app-secret}");
#endif
}

- (void)testTransmissionTokenFrom {

  // When
  NSString *test = @"{app-secret}";

  // Then
  NSString *result = [MSUtility transmissionTargetTokenFrom:test];
  XCTAssertNil(result);

  // When
  test = nil;
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = @"{app-secret};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = @"{app-secret};target={transmissionTargetToken}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"{app-secret};target={transmissionTargetToken};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"target={transmissionTargetToken};{app-secret}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"target={transmissionTargetToken};{app-secret};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"target={transmissionTargetToken}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"target={transmissionTargetToken};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"appsecret={app-secret};target={transmissionTargetToken};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"appsecret={app-secret};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = @"appsecret={app-secret}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertNil(result);

  // When
  test = @"target={transmissionTargetToken};appsecret={app-secret};";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"target={transmissionTargetToken};appsecret={app-secret}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");
#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST
  // When
  test = @"target={transmissionTargetToken};ios={app-secret}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");

  // When
  test = @"target={transmissionTargetToken};targetMacos={fake}";
  result = [MSUtility transmissionTargetTokenFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{transmissionTargetToken}");
#endif
}

#if TARGET_OS_MACCATALYST

- (void)testAppSecretCatalystFrom {

  // When
  NSString *test = @"ios={fake};macos={app-secret}";
  NSString *result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{app-secret}");

  // When
  test = @"ios={fake};macos={app-secret};appsecret=fake";
  result = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertEqualObjects(result, @"{app-secret}");
}
#endif

- (void)testInvalidSecretOrTokenInput {

  // When
  NSString *guidString = @"{app-secret}";
  NSString *test = [NSString stringWithFormat:@"target=;appsecret=%@", guidString];
  NSString *tokenResult = [MSUtility transmissionTargetTokenFrom:test];
  NSString *secretResult = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertNil(tokenResult);
  XCTAssertEqualObjects(guidString, secretResult);

  // When
  test = @"target=;target=;appsecret=;appsecret=;";
  tokenResult = [MSUtility transmissionTargetTokenFrom:test];
  secretResult = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertNil(tokenResult);
  XCTAssertNil(secretResult);

  // When
  guidString = MS_UUID_STRING;
  test = [NSString stringWithFormat:@"target=;target={transmissionTargetToken};appsecret=;appsecret=%@;", guidString];
  tokenResult = [MSUtility transmissionTargetTokenFrom:test];
  secretResult = [MSUtility appSecretFrom:test];

  // Then
  XCTAssertNotNil(secretResult);
  XCTAssertEqualObjects(guidString, secretResult);
  XCTAssertEqualObjects(tokenResult, @"{transmissionTargetToken}");
}

- (void)testValidatePropertyType {
  NSString *longStringValue = [@"" stringByPaddingToLength:(kMSMaxPropertyValueLength + 1) withString:@"value" startingAtIndex:0];
  NSString *stringValue125 = [@"" stringByPaddingToLength:kMSMaxPropertyValueLength withString:@"value" startingAtIndex:0];
  NSString *testLogTypeString = @"testLog";

  // Test valid properties
  // If
  NSDictionary *validProperties =
      @{@"Key1" : @"Value1", stringValue125 : @"Value2", @"Key3" : stringValue125, @"Key4" : @"Value4", @"Key5" : @""};

  // When
  NSDictionary *validatedProperties = [MSUtility validateProperties:validProperties forLogName:testLogTypeString type:testLogTypeString];

  // Then
  XCTAssertTrue([validatedProperties count] == [validProperties count]);

  // Test too many properties in one event
  // If
  NSDictionary *tooManyProperties = @{
    @"Key1" : @"Value1",
    @"Key2" : @"Value2",
    @"Key3" : @"Value3",
    @"Key4" : @"Value4",
    @"Key5" : @"Value5",
    @"Key6" : @"Value6",
    @"Key7" : @"Value7",
    @"Key8" : @"Value8",
    @"Key9" : @"Value9",
    @"Key10" : @"Value10",
    @"Key11" : @"Value11",
    @"Key12" : @"Value12",
    @"Key13" : @"Value13",
    @"Key14" : @"Value14",
    @"Key15" : @"Value15",
    @"Key16" : @"Value16",
    @"Key17" : @"Value17",
    @"Key18" : @"Value18",
    @"Key19" : @"Value19",
    @"Key20" : @"Value20",
    @"Key21" : @"Value21",
    @"Key22" : @"Value22"
  };

  // When
  validatedProperties = [MSUtility validateProperties:tooManyProperties forLogName:testLogTypeString type:testLogTypeString];

  // Then
  XCTAssertTrue([validatedProperties count] == kMSMaxPropertiesPerLog);

  // Test invalid properties
  // If
  NSDictionary *invalidKeysInProperties = @{@"Key1" : @"Value1", @(2) : @"Value2", @"" : @"Value4"};

  // When
  validatedProperties = [MSUtility validateProperties:invalidKeysInProperties forLogName:testLogTypeString type:testLogTypeString];

  // Then
  XCTAssertTrue([validatedProperties count] == 1);

  // Test invalid values
  // If
  NSDictionary *invalidValuesInProperties = @{@"Key1" : @"Value1", @"Key2" : @(2)};

  // When
  validatedProperties = [MSUtility validateProperties:invalidValuesInProperties forLogName:testLogTypeString type:testLogTypeString];

  // Then
  XCTAssertTrue([validatedProperties count] == 1);

  // Test long keys and values are truncated.
  // If
  NSDictionary *tooLongKeysAndValuesInProperties = @{longStringValue : longStringValue};

  // When
  validatedProperties = [MSUtility validateProperties:tooLongKeysAndValuesInProperties forLogName:testLogTypeString type:testLogTypeString];

  // Then
  NSString *truncatedKey = (NSString *)[[validatedProperties allKeys] firstObject];
  NSString *truncatedValue = (NSString *)[[validatedProperties allValues] firstObject];
  XCTAssertTrue([validatedProperties count] == 1);
  XCTAssertEqual([truncatedKey length], kMSMaxPropertyKeyLength);
  XCTAssertEqual([truncatedValue length], kMSMaxPropertyValueLength);

  // Test mixed variant
  // If
  NSDictionary *mixedProperties = @{
    @"Key1" : @"Value1",
    @(2) : @"Value2",
    stringValue125 : @"Value3",
    @"Key4" : stringValue125,
    @"Key5" : @"Value5",
    @"Key6" : @(2),
    @"Key7" : longStringValue,
    @"Key8" : @"Value8",
    @(2) : @"Value9",
    stringValue125 : @"Value10",
    @"Key11" : stringValue125,
    @"Key12" : @"Value12",
    @"Key13" : @(2),
    @"Key14" : longStringValue,
    @"Key15" : @"Value15",
    @(2) : @"Value16",
    stringValue125 : @"Value17",
    @"Key18" : stringValue125,
    @"Key19" : @"Value19",
    @"Key20" : @(2),
    @"Key21" : longStringValue,
    @"Key22" : @"Value22",
    @(2) : @"Value23",
    stringValue125 : @"Value124",
    @"Key25" : stringValue125,
    @"Key26" : @"Value26",
    @"Key27" : @(2),
    @"Key28" : @"Value28",
    @(2) : @"Value29",
    stringValue125 : @"Value30",
    @"Key31" : stringValue125,
    @"Key32" : @"Value32",
    @"Key33" : @(2),
    @"Key34" : longStringValue,
  };

  // When
  validatedProperties = [MSUtility validateProperties:mixedProperties forLogName:testLogTypeString type:testLogTypeString];

  // Then
  XCTAssertTrue([validatedProperties count] == kMSMaxPropertiesPerLog);
  XCTAssertNotNil([validatedProperties objectForKey:@"Key1"]);
  XCTAssertNotNil([validatedProperties objectForKey:stringValue125]);
  XCTAssertNotNil([validatedProperties objectForKey:@"Key4"]);
  XCTAssertNotNil([validatedProperties objectForKey:@"Key5"]);
  XCTAssertNil([validatedProperties objectForKey:@"Key6"]);
  XCTAssertNotNil([validatedProperties objectForKey:@"Key7"]);
}

#pragma mark - MSUtility+File.h

- (void)testCreateFile {

  // If
  NSString *expectedString = @"Something";
  NSString *pathComponent = @"testing/afile.test";
  NSData *expectedData = [expectedString dataUsingEncoding:NSUTF8StringEncoding];
  BOOL forceOverwrite = NO;

  // When
  NSURL *url = [MSUtility createFileAtPathComponent:pathComponent withData:expectedData atomically:YES forceOverwrite:forceOverwrite];

  // Then
  XCTAssertNotNil(url);
  NSString *expectedFile;
#if TARGET_OS_TV
  expectedFile = @"/Library/Caches/com.microsoft.appcenter/testing/afile.test";
#else
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
  expectedFile = [self getPathWithBundleIdentifier:@"/Library/Application%%20Support/%@/com.microsoft.appcenter/testing/afile.test"];
#else
  expectedFile = @"/Library/Application%20Support/com.microsoft.appcenter/testing/afile.test";
#endif
#endif
  XCTAssertTrue([[url relativeString] containsString:expectedFile]);
  XCTAssertTrue([url checkResourceIsReachableAndReturnError:nil]);
  NSData *actualData = [NSData dataWithContentsOfURL:url];
  XCTAssertNotNil(actualData);
  NSString *actualContent = [[NSString alloc] initWithData:actualData encoding:NSUTF8StringEncoding];
  XCTAssertTrue([actualContent isEqualToString:expectedString]);

  // When
  NSString *newString = @"Hello";
  NSData *newData = [newString dataUsingEncoding:NSUTF8StringEncoding];

  // Try to create a file that already exists with forceOverwrite set to NO. This shouldn't change the file.
  url = [MSUtility createFileAtPathComponent:pathComponent withData:newData atomically:YES forceOverwrite:NO];

  // Then
  actualData = [NSData dataWithContentsOfURL:url];
  XCTAssertNotNil(actualData);
  actualContent = [[NSString alloc] initWithData:actualData encoding:NSUTF8StringEncoding];
  XCTAssertTrue([actualContent isEqualToString:expectedString]);

  // When
  url = [MSUtility createFileAtPathComponent:pathComponent withData:newData atomically:YES forceOverwrite:YES];

  // Then
  actualData = [NSData dataWithContentsOfURL:url];
  XCTAssertNotNil(actualData);
  actualContent = [[NSString alloc] initWithData:actualData encoding:NSUTF8StringEncoding];
  XCTAssertTrue([actualContent isEqualToString:newString]);
}

- (void)testDeleteItemForPathComponent {

  // If
  NSString *expectedString = @"Something";
  NSString *pathComponent = @"testing/anotherfile.test";
  NSData *expectedData = [expectedString dataUsingEncoding:NSUTF8StringEncoding];
  BOOL forceOverwrite = NO;

  // When
  NSURL *url = [MSUtility createFileAtPathComponent:pathComponent withData:expectedData atomically:YES forceOverwrite:forceOverwrite];

  // Then
  XCTAssertNotNil(url);
  NSString *expectedFile;
#if TARGET_OS_TV
  expectedFile = @"/Library/Caches/com.microsoft.appcenter/testing/anotherfile.test";
#else
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
  expectedFile = [self getPathWithBundleIdentifier:@"/Library/Application%%20Support/%@/com.microsoft.appcenter/testing/anotherfile.test"];
#else
  expectedFile = @"/Library/Application%20Support/com.microsoft.appcenter/testing/anotherfile.test";
#endif
#endif
  XCTAssertTrue([[url relativeString] containsString:expectedFile]);
  XCTAssertTrue([url checkResourceIsReachableAndReturnError:nil]);

  // When
  [MSUtility deleteItemForPathComponent:pathComponent];
  XCTAssertFalse([url checkResourceIsReachableAndReturnError:nil]);
}

- (void)testCreateDirectory {

  // If
  NSString *pathComponent = @"testing";

  // When
  NSURL *url = [MSUtility createDirectoryForPathComponent:pathComponent];

  // Then
  XCTAssertNotNil(url);
  NSString *expectedFile;
#if TARGET_OS_TV
  expectedFile = @"/Library/Caches/com.microsoft.appcenter/testing";
#else
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
  expectedFile = [self getPathWithBundleIdentifier:@"/Library/Application%%20Support/%@/com.microsoft.appcenter/testing"];
#else
  expectedFile = @"/Library/Application%20Support/com.microsoft.appcenter/testing";
#endif
#endif
  XCTAssertTrue([[url relativeString] containsString:expectedFile]);
  XCTAssertTrue([url checkResourceIsReachableAndReturnError:nil]);
}

- (void)testLoadDataForPathComponent {

  // If
  NSString *expectedString = @"Something";
  NSString *pathComponent = @"testing/anotherfile.test";
  NSData *expectedData = [expectedString dataUsingEncoding:NSUTF8StringEncoding];
  BOOL forceOverwrite = NO;
  [MSUtility createFileAtPathComponent:pathComponent withData:expectedData atomically:YES forceOverwrite:forceOverwrite];

  // When
  NSData *actualData = [MSUtility loadDataForPathComponent:pathComponent];

  // Then
  XCTAssertNotNil(actualData);
  NSString *actualContent = [[NSString alloc] initWithData:actualData encoding:NSUTF8StringEncoding];
  XCTAssertTrue([actualContent isEqualToString:expectedString]);
}

- (void)testContentsOfDirectory {

  // If
  NSString *expectedString = @"Something";
  NSString *parentDir = @"testing";
  NSString *pathComponent = [NSString stringWithFormat:@"%@%@", parentDir, @"/testFile."];
  BOOL forceOverwrite = NO;
  BOOL atomical = YES;
  NSUInteger fileCount;
  for (fileCount = 0; fileCount < 3; fileCount++) {
    [MSUtility createFileAtPathComponent:[NSString stringWithFormat:@"%@%lu", pathComponent, (unsigned long)fileCount]
                                withData:[[NSString stringWithFormat:@"%@%lu", expectedString, (unsigned long)fileCount]
                                             dataUsingEncoding:NSUTF8StringEncoding]
                              atomically:atomical
                          forceOverwrite:forceOverwrite];
  }

  // When
  NSArray<NSURL *> *contents = [MSUtility contentsOfDirectory:parentDir propertiesForKeys:nil];

  // Then
  XCTAssertTrue(contents.count == fileCount);
  for (NSURL *fileUrl in contents) {
    NSString *testNb = fileUrl.pathExtension;
    NSString *content = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
    XCTAssertTrue([fileUrl checkResourceIsReachableAndReturnError:nil]);
    BOOL test = [content isEqualToString:[NSString stringWithFormat:@"%@%@", expectedString, testNb]];
    XCTAssertTrue(test);
  }
}

- (void)testFileExistsForPathComponent {

  // If
  NSString *expectedString = @"Something";
  NSString *pathComponent = @"testing/anotherfile.test";
  NSData *expectedData = [expectedString dataUsingEncoding:NSUTF8StringEncoding];
  BOOL forceOverwrite = NO;
  [MSUtility createFileAtPathComponent:pathComponent withData:expectedData atomically:YES forceOverwrite:forceOverwrite];

  // When
  BOOL actual = [MSUtility fileExistsForPathComponent:pathComponent];

  // Then
  XCTAssertTrue(actual);

  // When
  actual = [MSUtility fileExistsForPathComponent:@"thisDoesNotExist"];

  // Then
  XCTAssertFalse(actual);
}

- (void)testDeleteFileAtURL {

  // If
  NSString *expectedString = @"Something";
  NSString *pathComponent = @"testing/anotherfile.test";
  NSData *expectedData = [expectedString dataUsingEncoding:NSUTF8StringEncoding];
  BOOL forceOverwrite = NO;

  // When
  NSURL *url = [MSUtility createFileAtPathComponent:pathComponent withData:expectedData atomically:YES forceOverwrite:forceOverwrite];

  // Then
  XCTAssertNotNil(url);
  NSString *expectedFile;
#if TARGET_OS_TV
  expectedFile = @"/Library/Caches/com.microsoft.appcenter/testing/anotherfile.test";
#else
#if TARGET_OS_OSX || TARGET_OS_MACCATALYST
  expectedFile = [self getPathWithBundleIdentifier:@"/Library/Application%%20Support/%@/com.microsoft.appcenter/testing/anotherfile.test"];
#else
  expectedFile = @"/Library/Application%20Support/com.microsoft.appcenter/testing/anotherfile.test";
#endif
#endif
  XCTAssertTrue([[url relativeString] containsString:expectedFile]);
  XCTAssertTrue([url checkResourceIsReachableAndReturnError:nil]);

  // When
  [MSUtility deleteFileAtURL:url];

  // Then
  XCTAssertFalse([url checkResourceIsReachableAndReturnError:nil]);
}

- (void)testFullURLForPathComponent {

  // If
  NSString *expectedString = @"Something";
  NSString *pathComponent = @"testing/anotherfile.test";
  NSData *expectedData = [expectedString dataUsingEncoding:NSUTF8StringEncoding];
  BOOL forceOverwrite = NO;

  // When
  NSURL *url = [MSUtility createFileAtPathComponent:pathComponent withData:expectedData atomically:YES forceOverwrite:forceOverwrite];
  NSURL *actual = [MSUtility fullURLForPathComponent:pathComponent];

  // Then
  XCTAssertNotNil(url);
  XCTAssertNotNil(url);
  XCTAssertTrue([[url absoluteString] isEqualToString:([actual absoluteString]) ?: @""]);
}

- (void)testIKeyFromTargetToken {

  // When
  NSString *iKey = [MSUtility iKeyFromTargetToken:nil];

  // Then
  XCTAssertNil(iKey);

  // When
  iKey = [MSUtility iKeyFromTargetToken:@""];

  // Then
  XCTAssertNil(iKey);

  // When
  iKey = [MSUtility iKeyFromTargetToken:@"targetId-gu-id"];

  // Then
  XCTAssertEqualObjects(iKey, @"o:targetId");
}

- (void)testTargetIdFromTargetToken {

  // When
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
  NSString *targetId = [MSUtility targetKeyFromTargetToken:nil];
#pragma clang diagnostic pop

  // Then
  XCTAssertNil(targetId);

  // When
  targetId = [MSUtility targetKeyFromTargetToken:@""];

  // Then
  XCTAssertNil(targetId);

  // When
  targetId = [MSUtility targetKeyFromTargetToken:@"targetId-gu-id"];

  // Then
  XCTAssertEqualObjects(targetId, @"targetId");
}

- (void)testObfuscateString {

  // If
  NSString *pattern = @"\"token\":\"[^\"]+\"";
  NSString *template = @"\"token\":\"***\"";

  // Then
  XCTAssertNil([MSUtility obfuscateString:nil searchingForPattern:pattern toReplaceWithTemplate:template]);
  XCTAssertEqualObjects([MSUtility obfuscateString:@"" searchingForPattern:pattern toReplaceWithTemplate:template], @"");
  XCTAssertEqualObjects([MSUtility obfuscateString:@"{\"something\":\"else\"}" searchingForPattern:pattern toReplaceWithTemplate:template],
                        @"{\"something\":\"else\"}");

  // If
  NSString *unObfuscatedString = @"{\"something\":\"else\",\"token\":\"atoken\"}";
  NSString *expectedString = [NSString stringWithFormat:@"{\"something\":\"else\",%@}", template];

  // Then
  XCTAssertEqualObjects([MSUtility obfuscateString:unObfuscatedString searchingForPattern:pattern toReplaceWithTemplate:template],
                        expectedString);
}

- (void)testObfuscateRedirectUri {

  // If
  NSString *payload = @"{\"redirect_uri\": \"abc\"}";

  // When
  NSString *obfuscatedString = [MSUtility obfuscateString:payload
                                      searchingForPattern:kMSRedirectUriPattern
                                    toReplaceWithTemplate:kMSRedirectUriObfuscatedTemplate];

  // Then
  XCTAssertTrue([obfuscatedString rangeOfString:@"abc"].location == NSNotFound);
  XCTAssertFalse([obfuscatedString rangeOfString:kMSRedirectUriObfuscatedTemplate].location == NSNotFound);
}

- (void)testDispatchObjectMacro {

  // If
  NSMutableArray *array = [NSMutableArray new];

  // When
  MS_DISPATCH_SELECTOR((void (*)(id, SEL, id)), array, addObject:, @"test");

  // Then
  XCTAssertEqual([array count], 1);
  XCTAssertEqual([array firstObject], @"test");
}

- (void)testDispatchObjectMacroWithNil {

  // If
  XCTestExpectation *expectation = [self expectationWithDescription:@"Dispatch selector executed."];
  typedef void (^block)(NSString *, NSString *);

  // When
  MS_DISPATCH_SELECTOR((void (*)(id, SEL, NSString *, NSString *, block)), self, methodWithArgs:secondArg:completionHandler:, nil, @"test",
                       ^(NSString *firstArg, NSString *secondArg) {
                         XCTAssertNil(firstArg);
                         XCTAssertEqual(secondArg, @"test");
                         [expectation fulfill];
                       });

  // Then
  [self waitForExpectationsWithTimeout:kMSTestTimeout
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@", error);
                                 }
                               }];
}

- (void)testPerformBlockOnMainThread {

  // If
  XCTestExpectation *expectation = [self expectationWithDescription:@"method called."];
  NSString *str = @"expectedString";

  // When
  [MSDispatcherUtil performBlockOnMainThread:^{
    [self methodToCall:str
        completionHandler:^(NSString *string) {
          XCTAssertEqual(str, string);
          [expectation fulfill];
        }];
  }];

  // Then
  [self waitForExpectationsWithTimeout:kMSTestTimeout
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@", error);
                                 }
                               }];
}

- (void)testPerformBlockOnMainThreadFromBackground {

  // If
  XCTestExpectation *expectation = [self expectationWithDescription:@"method called."];
  NSString *str = @"expectedString";

  // When
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [MSDispatcherUtil performBlockOnMainThread:^{
      [self methodToCall:str
          completionHandler:^(NSString *string) {
            XCTAssertEqual(str, string);
            [expectation fulfill];
          }];
    }];
  });

  // Then
  [self waitForExpectationsWithTimeout:kMSTestTimeout
                               handler:^(NSError *error) {
                                 if (error) {
                                   XCTFail(@"Expectation Failed with error: %@", error);
                                 }
                               }];
}

- (void)testArchivingData {

  // If
  id value = @[ @{@"key" : @42}, @[ @1, @2, @3 ], @"value", [NSNull null] ];

  // When
  NSData *data = [MSUtility archiveKeyedData:value];

  // Then
  XCTAssertNotNil(data);

  // When
  id result = [MSUtility unarchiveKeyedData:data];

  // Then
  XCTAssertEqualObjects(value, result);
}

- (void)testArchivingNilData {
  XCTAssertNil([MSUtility archiveKeyedData:nil]);
  XCTAssertNil([MSUtility unarchiveKeyedData:nil]);
}

- (void)testArchivingInvalidData {
  XCTAssertNil([MSUtility archiveKeyedData:self]);
  XCTAssertNil([MSUtility unarchiveKeyedData:[@"invalid" dataUsingEncoding:NSUTF8StringEncoding]]);
}

- (void)methodToCall:(NSString *)str completionHandler:(void (^)(NSString *string))completion {
  completion(str);
}

- (void)methodWithArgs:(NSString *)str secondArg:(NSString *)secondStr completionHandler:(void (^)(NSString *, NSString *))completion {
  completion(str, secondStr);
}

// Before SDK 12.2 (bundled with Xcode 10.*) when running in a unit test bundle the bundle identifier is null.
// 12.2 and after the above bundle identifier is com.apple.dt.xctest.tool.
- (NSString *)getPathWithBundleIdentifier:(NSString *)path {
  NSString *bundleId;
#if ((defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 120200) ||                                            \
     (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 101404))
  bundleId = @"com.apple.dt.xctest.tool";
#else
  bundleId = @"(null)";
#endif
  return [NSString stringWithFormat:path, bundleId];
}

@end
