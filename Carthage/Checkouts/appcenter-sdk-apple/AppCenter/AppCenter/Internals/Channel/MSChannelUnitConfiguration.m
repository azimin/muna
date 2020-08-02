// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSChannelUnitConfiguration.h"

@implementation MSChannelUnitConfiguration

- (instancetype)initWithGroupId:(NSString *)groupId
                       priority:(MSPriority)priority
                  flushInterval:(NSUInteger)flushInterval
                 batchSizeLimit:(NSUInteger)batchSizeLimit
            pendingBatchesLimit:(NSUInteger)pendingBatchesLimit {
  if ((self = [super init])) {
    _groupId = groupId;
    _priority = priority;
    _flushInterval = flushInterval;
    _batchSizeLimit = batchSizeLimit;
    _pendingBatchesLimit = pendingBatchesLimit;
  }
  return self;
}

- (instancetype)initDefaultConfigurationWithGroupId:(NSString *)groupId flushInterval:(NSUInteger)flushInterval {
  return [self initWithGroupId:groupId priority:MSPriorityDefault flushInterval:flushInterval batchSizeLimit:50 pendingBatchesLimit:3];
}

- (instancetype)initDefaultConfigurationWithGroupId:(NSString *)groupId {
  return [self initDefaultConfigurationWithGroupId:groupId flushInterval:kMSFlushIntervalDefault];
}

@end
