// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSHttpUtil.h"

@implementation MSHttpUtil

+ (BOOL)isRecoverableError:(NSInteger)statusCode {

  // There are some cases when statusCode is 0, e.g., when server is unreachable. If so, the error will contain more details.
  return statusCode >= 500 || statusCode == 408 || statusCode == 429 || statusCode == 0;
}

+ (BOOL)isSuccessStatusCode:(NSInteger)statusCode {
  return statusCode >= 200 && statusCode < 300;
}

+ (BOOL)isNoInternetConnectionError:(NSError *)error {
  return ([error.domain isEqualToString:NSURLErrorDomain] &&
          ((error.code == NSURLErrorNotConnectedToInternet) || (error.code == NSURLErrorNetworkConnectionLost)));
}

+ (BOOL)isSSLConnectionError:(NSError *)error {

  // Check for error domain and if the error.code falls in the range of SSL connection errors (between -2000 and -1200).
  return ([error.domain isEqualToString:NSURLErrorDomain] &&
          ((error.code >= NSURLErrorCannotLoadFromNetwork) && (error.code <= NSURLErrorSecureConnectionFailed)));
}

+ (NSString *)hideSecret:(NSString *)secret {

  // Hide everything if secret is shorter than the max number of displayed characters.
  NSUInteger appSecretHiddenPartLength =
      (secret.length > kMSMaxCharactersDisplayedForAppSecret ? secret.length - kMSMaxCharactersDisplayedForAppSecret : secret.length);
  NSString *appSecretHiddenPart = [@"" stringByPaddingToLength:appSecretHiddenPartLength
                                                    withString:kMSHidingStringForAppSecret
                                               startingAtIndex:0];
  return [secret stringByReplacingCharactersInRange:NSMakeRange(0, appSecretHiddenPart.length) withString:appSecretHiddenPart];
}

+ (NSString *)hideSecretInString:(NSString *)string secret:(NSString *)secret {
  NSString *encodedSecret = [self hideSecret:secret];
  return [string stringByReplacingOccurrencesOfString:secret withString:encodedSecret];
}

@end
