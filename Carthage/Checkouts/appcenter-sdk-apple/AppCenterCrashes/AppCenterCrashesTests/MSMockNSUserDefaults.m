// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSMockNSUserDefaults.h"
#import "MSTestFrameworks.h"

@interface MSMockNSUserDefaults ()

@property(nonatomic) NSMutableDictionary<NSString *, NSObject *> *dictionary;
@property(nonatomic) id mockNSUserDefaults;

@end

@implementation MSMockNSUserDefaults

- (instancetype)init {
  self = [super init];
  if (self) {
    _dictionary = [NSMutableDictionary new];

    // Mock MSUserDefaults shared method to return this instance.
    _mockNSUserDefaults = OCMClassMock([NSUserDefaults class]);
    OCMStub([_mockNSUserDefaults standardUserDefaults]).andReturn(self);
  }
  return self;
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey {

  // Don't store nil objects.
  if (!anObject) {
    return;
  }
  [self.dictionary setObject:anObject forKey:aKey];
}

- (nullable id)objectForKey:(NSString *)aKey {
  return self.dictionary[aKey];
}

- (void)stopMocking {
  [self.dictionary removeAllObjects];
  [self.mockNSUserDefaults stopMocking];
}

@end
