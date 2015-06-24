//
//  HUIDebug.h
//  HUIKit
//
//  Created by ZhangTingHui on 12-12-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#if DEBUG

#define DLog(args...) (NSLog(@"%@", [NSString stringWithFormat:args]))

#else  

#define DLog(args...)    // do nothing.

#endif



#define DLogMethodName()	DLog(@"%s", __PRETTY_FUNCTION__)
#define DLogBOOL(b)			DLog(@"%@", b? @"YES": @"NO")
#define DLogCGPoint(p)		DLog(@"CGPoint(%f, %f)", p.x, p.y)
#define DLogCGSize(s)		DLog(@"CGSize(%f, %f)", s.width, s.height)
#define DLogCGRect(r)		DLog(@"{CGRect{origin(%f, %f), size(%f, %f)}", r.origin.x, r.origin.y, r.size.width, r.size.height)
#define DLogObject(obj)		DLog(@"%@", (obj))
