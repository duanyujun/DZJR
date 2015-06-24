//
//  UIDevice+HUIAddtion.h
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//
//

#import <UIKit/UIKit.h>


#define HUIIsIPAD()                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//System version
#define HUISystemVersionIs(v)           ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] \
== NSOrderedSame)
#define HUISystemVersionAbove(v)        ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] \
== NSOrderedDescending)
#define HUISystemVersionAboveOrIs(v)    ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] \
!= NSOrderedAscending)
#define HUISystemVersionBelow(v)        ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] \
== NSOrderedAscending)
#define HUISystemVersionBelowOrIs(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] \
!= NSOrderedDescending)
#define kHUISystemVersion_4_3           @"4.3"
#define kHUISystemVersion_5_0           @"5.0"
#define kHUISystemVersion_5_1           @"5.1"
#define kHUISystemVersion_6_0           @"6.0"
#define kHUISystemVersion_6_1           @"6.1"
#define kHUISystemVersion_7_0           @"7.0"
#define kHUISystemVersion_7_1           @"7.1"
#define kHUISystemVersion_8_0           @"8.0"
#define kHUISystemVersion_8_1           @"8.1"

@interface UIDevice (HUIAddtion)

@end
