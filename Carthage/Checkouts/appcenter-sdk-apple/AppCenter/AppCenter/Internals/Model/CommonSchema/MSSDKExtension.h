// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

#import "MSModel.h"
#import "MSSerializableObject.h"

static NSString *const kMSSDKEpoch = @"epoch";
static NSString *const kMSSDKInstallId = @"installId";
static NSString *const kMSSDKLibVer = @"libVer";
static NSString *const kMSSDKSeq = @"seq";

/**
 * The SDK extension is used by platform specific library to record field that are specifically required for a specific SDK.
 */
@interface MSSDKExtension : NSObject <MSSerializableObject, MSModel>

/**
 * The SDK version.
 */
@property(nonatomic, copy) NSString *libVer;

/**
 * ID incremented for each SDK initialization.
 */
@property(nonatomic, copy) NSString *epoch;

/**
 * ID incremented for each event.
 */
@property(nonatomic) int64_t seq;

/**
 * ID created on first-time SDK initialization. It may serves as the device.localId.
 */
@property(nonatomic) NSUUID *installId;

@end
