// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

#import "AppCenter+Internal.h"
#import "MSAppCenter.h"
#import "MSChannelGroupProtocol.h"
#import "MSServiceInternal.h"

/*
 * Persisted storage keys.
 */
static NSString *const kMSInstallIdKey = @"InstallId";
static NSString *const kMSAppCenterIsEnabledKey = @"AppCenterIsEnabled";

/*
 * Name of the environment variable to check for which services should be disabled.
 */
static NSString *const kMSDisableVariable = @"APP_CENTER_DISABLE";

/*
 * Value that would cause all services to be disabled.
 */
static NSString *const kMSDisableAll = @"All";

/**
 * Name of the environment variable to check to see if we're running in App Center Test.
 */
static NSString *const kMSRunningInAppCenter = @"RUNNING_IN_APP_CENTER";

/**
 * A string value for environment variables denoting `true`.
 */
static NSString *const kMSTrueEnvironmentString = @"1";

@interface MSAppCenter ()

@property(nonatomic) id<MSChannelGroupProtocol> channelGroup;

@property(nonatomic) NSMutableArray<NSObject<MSServiceInternal> *> *services;

@property(nonatomic) NSMutableArray<NSString *> *startedServiceNames;

@property(nonatomic, copy) NSString *appSecret;

@property(nonatomic, copy) NSString *defaultTransmissionTargetToken;

@property(atomic, copy) NSString *logUrl;

@property(nonatomic, readonly) NSUUID *installId;

@property(nonatomic) NSNumber *requestedMaxStorageSizeInBytes;

/**
 * Flag indicating if the SDK is enabled or not as a whole.
 */
@property(nonatomic, getter=isEnabled) BOOL enabled;

/**
 * Flag indicating if the SDK is configured or not.
 */
@property(nonatomic, getter=isSdkConfigured) BOOL sdkConfigured;

/**
 * Flag indicating if the SDK is configured From Application or not.
 */
@property(nonatomic, getter=isConfiguredFromApplication) BOOL configuredFromApplication;

/**
 * Flag indicating if the SDK is enabled state updating or not.
 */
@property(nonatomic, getter=isEnabledStateUpdating) BOOL enabledStateUpdating;

@property(nonatomic, copy) void (^maxStorageSizeCompletionHandler)(BOOL);

@property BOOL setMaxStorageSizeHasBeenCalled;

/**
 * Returns the singleton instance of App Center.
 *
 * @return The singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 * Get the log tag for the AppCenter service.
 *
 * @return A name of logger tag for the AppCenter service.
 */
+ (NSString *)logTag;

/**
 * Get the group ID for the AppCenter service.
 *
 * @return A storage identifier for the AppCenter service.
 */
+ (NSString *)groupId;

/**
 * Get the log URL.
 *
 * @return The log URL.
 */
- (NSString *)logUrl;

/**
 * Get the app secret.
 *
 * @return The app secret.
 */
- (NSString *)appSecret;

/**
 * Sort the array of services in descending order based on their priority.
 *
 * @return The array of services in descending order.
 */
- (NSArray *)sortServices:(NSArray<Class> *)services;

@end
