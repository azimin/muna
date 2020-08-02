// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

@interface MSCrashesUtil ()

/**
 * Method to reset directories when running unit tests only. So calling methods re-generates directories.
 */
+ (void)resetDirectory;

@end
