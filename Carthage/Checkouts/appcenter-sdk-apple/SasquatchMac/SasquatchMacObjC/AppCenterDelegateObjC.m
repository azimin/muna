// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "AppCenterDelegateObjC.h"
#import "MSEventFilter.h"
#import "Constants.h"

@import AppCenter;
@import AppCenterAnalytics;
@import AppCenterCrashes;
@import AppCenterPush;

/**
 * AppCenterDelegate implementation in Objective C.
 */
@implementation AppCenterDelegateObjC

#pragma mark - MSAppCenter section.

- (BOOL)isAppCenterEnabled {
  return [MSAppCenter isEnabled];
}

- (void)setAppCenterEnabled:(BOOL)isEnabled {
  return [MSAppCenter setEnabled:isEnabled];
}

- (void)setCountryCode:(NSString *)countryCode {
  return [MSAppCenter setCountryCode:countryCode];
}

- (void)setCustomProperties:(MSCustomProperties *)customProperties {
  [MSAppCenter setCustomProperties:customProperties];
}

- (void)startAnalyticsFromLibrary {
  [MSAppCenter startFromLibraryWithServices:@ [[MSAnalytics class]]];
}

- (NSString *)installId {
  return [[MSAppCenter installId] UUIDString];
}

- (NSString *)appSecret {
  return kMSObjcAppSecret;
}

- (BOOL)isDebuggerAttached {
  return [MSAppCenter isDebuggerAttached];
}

- (void)setUserId:(NSString *)userId {
  [MSAppCenter setUserId:userId];
}

- (void)setLogUrl:(NSString *)logUrl {
  [MSAppCenter setLogUrl:logUrl];
}

#pragma mark - Modules section.

- (BOOL)isAnalyticsEnabled {
  return [MSAnalytics isEnabled];
}

- (BOOL)isCrashesEnabled {
  return [MSCrashes isEnabled];
}

- (BOOL)isPushEnabled {
  return [MSPush isEnabled];
}

- (void)setAnalyticsEnabled:(BOOL)isEnabled {
  return [MSAnalytics setEnabled:isEnabled];
}

- (void)setCrashesEnabled:(BOOL)isEnabled {
  return [MSCrashes setEnabled:isEnabled];
}

- (void)setPushEnabled:(BOOL)isEnabled {
  return [MSPush setEnabled:isEnabled];
}

#pragma mark - MSAnalytics section.

- (void)trackEvent:(NSString *)eventName {
  [MSAnalytics trackEvent:eventName];
}

- (void)trackEvent:(NSString *)eventName withProperties:(NSDictionary<NSString *, NSString *> *)properties {
  [MSAnalytics trackEvent:eventName withProperties:properties];
}

- (void)trackEvent:(NSString *)eventName withProperties:(NSDictionary<NSString *, NSString *> *)properties flags:(MSFlags)flags {
  [MSAnalytics trackEvent:eventName withProperties:properties flags:flags];
}

- (void)trackEvent:(NSString *)eventName withTypedProperties:(MSEventProperties *)properties {
  [MSAnalytics trackEvent:eventName withTypedProperties:properties];
}

- (void)trackEvent:(NSString *)eventName withTypedProperties:(MSEventProperties *)properties flags:(MSFlags)flags {
  [MSAnalytics trackEvent:eventName withTypedProperties:properties flags:flags];
}

- (void)trackPage:(NSString *)pageName {

  // TODO: Uncomment when trackPage is moved from internal to public module
  // [MSAnalytics trackPage:pageName];
}

- (void)trackPage:(NSString *)pageName withProperties:(NSDictionary<NSString *, NSString *> *)properties {

  // TODO: Uncomment when trackPage is moved from internal to public module
  // [MSAnalytics trackPage:pageName withProperties:properties];
}

- (void)resume {
  [MSAnalytics resume];
}

- (void)pause {
  [MSAnalytics pause];
}

#pragma mark - MSCrashes section.

- (BOOL)hasCrashedInLastSession {
  return [MSCrashes hasCrashedInLastSession];
}

- (void)generateTestCrash {
  return [MSCrashes generateTestCrash];
}

#pragma mark - Last crash report section.

- (NSString *)lastCrashReportIncidentIdentifier {
  return [[MSCrashes lastSessionCrashReport] incidentIdentifier];
}

- (NSString *)lastCrashReportReporterKey {
  return [[MSCrashes lastSessionCrashReport] reporterKey];
}

- (NSString *)lastCrashReportSignal {
  return [[MSCrashes lastSessionCrashReport] signal];
}

- (NSString *)lastCrashReportExceptionName {
  return [[MSCrashes lastSessionCrashReport] exceptionName];
}

- (NSString *)lastCrashReportExceptionReason {
  return [[MSCrashes lastSessionCrashReport] exceptionReason];
}

- (NSString *)lastCrashReportAppStartTimeDescription {
  return [[[MSCrashes lastSessionCrashReport] appStartTime] description];
}

- (NSString *)lastCrashReportAppErrorTimeDescription {
  return [[[MSCrashes lastSessionCrashReport] appErrorTime] description];
}

- (NSUInteger)lastCrashReportAppProcessIdentifier {
  return [[MSCrashes lastSessionCrashReport] appProcessIdentifier];
}

- (BOOL)lastCrashReportIsAppKill {
  return [[MSCrashes lastSessionCrashReport] isAppKill];
}

- (NSString *)lastCrashReportDeviceModel {
  return [[[MSCrashes lastSessionCrashReport] device] model];
}

- (NSString *)lastCrashReportDeviceOemName {
  return [[[MSCrashes lastSessionCrashReport] device] oemName];
}

- (NSString *)lastCrashReportDeviceOsName {
  return [[[MSCrashes lastSessionCrashReport] device] osName];
}

- (NSString *)lastCrashReportDeviceOsVersion {
  return [[[MSCrashes lastSessionCrashReport] device] osVersion];
}

- (NSString *)lastCrashReportDeviceOsBuild {
  return [[[MSCrashes lastSessionCrashReport] device] osBuild];
}

- (NSString *)lastCrashReportDeviceLocale {
  return [[[MSCrashes lastSessionCrashReport] device] locale];
}

- (NSNumber *)lastCrashReportDeviceTimeZoneOffset {
  return [[[MSCrashes lastSessionCrashReport] device] timeZoneOffset];
}

- (NSString *)lastCrashReportDeviceScreenSize {
  return [[[MSCrashes lastSessionCrashReport] device] screenSize];
}

- (NSString *)lastCrashReportDeviceAppVersion {
  return [[[MSCrashes lastSessionCrashReport] device] appVersion];
}

- (NSString *)lastCrashReportDeviceAppBuild {
  return [[[MSCrashes lastSessionCrashReport] device] appBuild];
}

- (NSString *)lastCrashReportDeviceAppNamespace {
  return [[[MSCrashes lastSessionCrashReport] device] appNamespace];
}

- (NSString *)lastCrashReportDeviceCarrierName {
  return [[[MSCrashes lastSessionCrashReport] device] carrierName];
}

- (NSString *)lastCrashReportDeviceCarrierCountry {
  return [[[MSCrashes lastSessionCrashReport] device] carrierCountry];
}

#pragma mark - MSEventFilter section.

- (BOOL)isEventFilterEnabled {
  return [MSEventFilter isEnabled];
}

- (void)setEventFilterEnabled:(BOOL)isEnabled {
  [MSEventFilter setEnabled:isEnabled];
}

- (void)startEventFilterService {
  [MSAppCenter startService:[MSEventFilter class]];
}

@end
