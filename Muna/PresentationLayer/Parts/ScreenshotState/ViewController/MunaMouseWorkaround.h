//
//  MunaMouseWorkaround.h
//  Muna
//
//  Created by Alexander on 5/29/20.
//  Copyright © 2020 Abstract. All rights reserved.
//

#ifndef MunaMouseWorkaround_h
#define MunaMouseWorkaround_h

#import <Cocoa/Cocoa.h>

typedef int CGSConnectionID;
CGError CGSSetConnectionProperty(CGSConnectionID cid, CGSConnectionID targetCID, CFStringRef key, CFTypeRef value);
int _CGSDefaultConnection();


#endif /* MunaMouseWorkaround_h */
