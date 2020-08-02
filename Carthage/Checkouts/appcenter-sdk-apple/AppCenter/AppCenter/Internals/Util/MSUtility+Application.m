// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSUtility+ApplicationPrivate.h"

/*
 * Workaround for exporting symbols from category object files.
 */
NSString *MSUtilityApplicationCategory;

@implementation MSUtility (Application)

+ (MSApplicationState)applicationState {

  // App extensions must not access sharedApplication.
  if (!MS_IS_APP_EXTENSION) {
    return (MSApplicationState)[[self class] sharedAppState];
  }
  return MSApplicationStateUnknown;
}

#if TARGET_OS_OSX
+ (NSApplication *)sharedApp {

  // Compute selector at runtime for more discretion.
  SEL sharedAppSel = NSSelectorFromString(@"sharedApplication");
  return ((NSApplication * (*)(id, SEL))[[NSApplication class] methodForSelector:sharedAppSel])([NSApplication class], sharedAppSel);
}
#else
+ (UIApplication *)sharedApp {

  // Compute selector at runtime for more discretion.
  SEL sharedAppSel = NSSelectorFromString(@"sharedApplication");
  return ((UIApplication * (*)(id, SEL))[[UIApplication class] methodForSelector:sharedAppSel])([UIApplication class], sharedAppSel);
}
#endif

#if TARGET_OS_OSX
+ (id<NSApplicationDelegate>)sharedAppDelegate {
  return [self sharedApp].delegate;
}
#else
+ (id<UIApplicationDelegate>)sharedAppDelegate {
  return [self sharedApp].delegate;
}
#endif

#if TARGET_OS_OSX
+ (MSApplicationState)sharedAppState {

  // UI API (isHidden) cannot be called from a background thread.
  if ([NSThread isMainThread]) {
    return [[MSUtility sharedApp] isHidden] ? MSApplicationStateBackground : MSApplicationStateActive;
  }
  return MSApplicationStateUnknown;
}
#else
+ (UIApplicationState)sharedAppState {
  return [(NSNumber *)[[MSUtility sharedApp] valueForKey:@"applicationState"] longValue];
}
#endif

+ (void)sharedAppOpenUrl:(NSURL *)url
                 options:(NSDictionary<NSString *, id> *)options
       completionHandler:(void (^)(MSOpenURLState state))completion {
#if TARGET_OS_OSX
  (void)options;

  /*
   * TODO: iOS SDK has an issue that openURL returns NO even though it was able to open a browser. Need to make sure openURL returns YES/NO
   * on macOS properly.
   */
  // Dispatch the open url call to the next loop to avoid freezing the App new instance start up.
  dispatch_async(dispatch_get_main_queue(), ^{
    completion([[NSWorkspace sharedWorkspace] openURL:url]);
  });
#else
  UIApplication *sharedApp = [[self class] sharedApp];

  // FIXME: App extensions does support openURL through NSExtensionContest, we may use this somehow.
  if (MS_IS_APP_EXTENSION || ![sharedApp canOpenURL:url]) {
    if (completion) {
      completion(MSOpenURLStateFailed);
    }
    return;
  }

  // Dispatch the open url call to the next loop to avoid freezing the App new instance start up.
  dispatch_async(dispatch_get_main_queue(), ^{
    SEL selector = NSSelectorFromString(@"openURL:options:completionHandler:");
    if ([sharedApp respondsToSelector:selector]) {
      id resourceUrl = url;
      id urlOptions = options;
      id completionHandler = ^(BOOL success) {
        if (completion) {
          completion(success ? MSOpenURLStateSucceed : MSOpenURLStateUnknown);
        }
      };
      NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[sharedApp methodSignatureForSelector:selector]];
      [invocation setSelector:selector];
      [invocation setTarget:sharedApp];
      [invocation setArgument:&resourceUrl atIndex:2];
      [invocation setArgument:&urlOptions atIndex:3];
      [invocation setArgument:&completionHandler atIndex:4];
      [invocation invoke];
    } else {
      BOOL success = [sharedApp performSelector:@selector(openURL:) withObject:url];
      if (completion) {
        completion(success ? MSOpenURLStateSucceed : MSOpenURLStateFailed);
      }
    }
  });
#endif
}

@end
