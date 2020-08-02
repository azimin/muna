// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSAppCenterInternal.h"
#import "MSLogger.h"
#import "MSLogContainer.h"
#import "MSSerializableObject.h"

static NSString *const kMSLogs = @"logs";

@implementation MSLogContainer

- (id)initWithBatchId:(NSString *)batchId andLogs:(NSArray<id<MSLog>> *)logs {
  if ((self = [super init])) {
    self.batchId = batchId;
    self.logs = logs;
  }
  return self;
}

- (NSString *)serializeLog {
  return [self serializeLogWithPrettyPrinting:NO];
}

- (NSString *)serializeLogWithPrettyPrinting:(BOOL)prettyPrint {
  NSString *jsonString;
  NSMutableArray *jsonArray = [NSMutableArray array];
  [self.logs enumerateObjectsUsingBlock:^(id<MSLog> _Nonnull obj, __attribute__((unused)) NSUInteger idx,
                                          __attribute__((unused)) BOOL *_Nonnull stop) {
    NSMutableDictionary *dict = [(id<MSSerializableObject>)obj serializeToDictionary];
    if (dict) {
      [jsonArray addObject:dict];
    }
  }];

  NSMutableDictionary *logContainer = [[NSMutableDictionary alloc] init];
  [logContainer setValue:jsonArray forKey:kMSLogs];

  NSError *error;
  NSJSONWritingOptions printOptions = prettyPrint ? NSJSONWritingPrettyPrinted : (NSJSONWritingOptions)0;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:logContainer options:printOptions error:&error];

  if (!jsonData) {
    MSLogError([MSAppCenter logTag], @"Couldn't serialize log container to json: %@", error.localizedDescription);
  } else {
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    /*
     * NSJSONSerialization escapes paths by default.
     * We don't need that extra bytes going over the wire, so we replace them.
     */
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
  }
  return jsonString;
}

- (BOOL)isValid {

  // Check for empty container
  if ([self.logs count] == 0)
    return NO;

  __block BOOL isValid = YES;
  [self.logs enumerateObjectsUsingBlock:^(id<MSLog> _Nonnull obj, __attribute__((unused)) NSUInteger idx, BOOL *_Nonnull stop) {
    if (![obj isValid]) {
      *stop = YES;
      isValid = NO;
      return;
    }
  }];
  return isValid;
}

@end
