//
//  HUILocationManager.h
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLAvailability.h>

extern const CLLocationDirection kHUILocationManagerDirectionInvalid;
//Notifications
extern NSString *const HUILocationManagerNotificationUserLocationUpdated;
extern NSString *const HUILocationManagerNotificationUserDirectionUpdated;

@protocol HUILocationManagerDelegate;
@interface HUILocationManager : NSObject <CLLocationManagerDelegate>

/*
 *  notificationsEnabled
 *
 *  Discussion:
 *      Indicate whether enable the HUILocationManagerNotifications. Default is NO
 */
@property (nonatomic, assign) BOOL notificationsEnabled;

/*
 *  delegate
 *
 *  Discussion:
 *      If set delegate to nil, the location manager will stop updating heading and location
 */
@property (nonatomic, assign) id<HUILocationManagerDelegate> delegate;


/*
 *  Block style delegate methods
 */
@property (nonatomic, copy) void(^didLocationTimeOut)(void);
@property (nonatomic, copy) void(^didFailWithError)(NSError *error);
@property (nonatomic, copy) void(^didStopUpdateLocation)(void);
@property (nonatomic, copy) void(^didStopUpdateDirection)(void);
@property (nonatomic, copy) void(^didUpdateUserDirection)(CLLocationDirection newDirection);
@property (nonatomic, copy) void(^didUpdateToLocation)(CLLocationCoordinate2D newLocation, CLLocationCoordinate2D oldLocation);


@property (nonatomic, assign) CLLocationAccuracy desiredAccuracy;
@property (nonatomic, assign) CLLocationDistance distanceFilter;

@property (nonatomic, retain) CLLocation * userLocation;

/*
 *  newestLocation
 *
 *  Discussion:
 *      The most recently retrieved user location. kCLLocationCoordinate2DInvalid if no location has ever been retrieved.
 */
@property (readonly)CLLocationCoordinate2D newestLocation;


/*
 *  newestDirection
 *
 *  Discussion:
 *       The most recently retrieved user direction. A negative value indicates aninvalid direction.
 */
@property (readonly)CLLocationDirection newestDirection;

/*
 *  locationTimeOut
 *
 *  Discussion:
 *      If can't retrieve a valid location within this time after start update user location, we will treat the location operation is time out, and will send -locationManagerDidLocationTimeOut: to delegate.
 *		Default is 5 seconds.
 */
@property (nonatomic, assign) NSTimeInterval locationTimeOut;

/*
 *  sharedManager
 *
 *  Discussion:
 *      Global Shared HUILocationManager
 */
+ (id)sharedManager;

/*
 *  startUpdateUserLocation
 *
 *  Discussion:
 *      Call this to update newest userLocation, delegate will receive the message when location is updated.
 */
- (void)startUpdateUserLocation;

/*
 *  stopUpdateUserLocation
 *
 *  Discussion:
 *      Stop updating locations.
 */
- (void)stopUpdateUserLocation;

/*
 *  startUpdateUserHeading
 *
 *  Discussion:
 *      Call this to start update user heading, then delegate will receive the message when user heading is updated
 */
- (void)startUpdateUserHeading;

/*
 *  stopUpdateUserHeading
 *
 *  Discussion:
 *      Stop updating heading
 */
- (void)stopUpdateUserHeading;

/*
 *  correctHeadingOrientation
 *
 *  Discussion:
 *      adjust headingOrientation to same as app userinterface orientation
 */
- (void)correctHeadingOrientation;


#pragma mark - TestModal
@property (nonatomic, assign) BOOL enableTestModal;

//The following test methods only work if test modal enabled
- (void)testLocateToLocation:(CLLocationCoordinate2D)location;
- (void)testAddLongitude:(double)longitudeOffset;
- (void)testAddLatitude:(double)latitudeOffset;

@end



#pragma mark - HUILocationManagerDelegate
@protocol HUILocationManagerDelegate <NSObject>
@optional
- (void)locationManager:(HUILocationManager *)locationManager
    didUpdateToLocation:(CLLocationCoordinate2D)newLocation
           fromLocation:(CLLocationCoordinate2D)oldLocation;
- (void)locationManager:(HUILocationManager *)locationManager didUpdateUserDirection:(CLLocationDirection)newUserDirection;
- (void)locationManager:(HUILocationManager *)locationManager didFailWithError:(NSError *)error;
- (void)locationManagerDidLocationTimeOut:(HUILocationManager *)locationManager;
- (void)locationManagerDidStopUpdateLocation:(HUILocationManager *)locationManager;
- (void)locationManagerDidStopUpdateDirection:(HUILocationManager *)locationManager;
@end
