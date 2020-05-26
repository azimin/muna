//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Cocoa/Cocoa.h>

typedef int CGSConnectionID;
CGError CGSSetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef value);
int _CGSDefaultConnection();
