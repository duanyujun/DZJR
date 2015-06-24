//
//  HUILocationManager.m
//  HUIKit
//
//  Created by lyh on 14-5-7.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "HUILocationManager.h"

const CLLocationDirection kHUILocationManagerDirectionInvalid = -10.0; //Invalid CCLocationDirection value
const CLLocationDegrees kHUILocationManagerHeadingFilter = 0.01; //heading service update peer 0.01 degrees rotated
const NSTimeInterval kHUILocationManagerDefaultLocationTimeOut = 5.00; //located time out if doesn't success in 5.00 seconds
const CLLocationDegrees kHUILocationManagerDirectionOffset = 11.5;	//地磁南北极和地理南北极的差值

NSString *const HUILocationManagerNotificationUserLocationUpdated = @"kHUILocationManagerNotificationUserLocationUpdated";
NSString *const HUILocationManagerNotificationUserDirectionUpdated = @"kHUILocationManagerNotificationUserDirectionUpdated";

@implementation HUILocationManager
{
    CLLocationManager *_locationManager; //core location manager, use it to get user location
    CLGeocoder *_geocoder;
    BOOL _successedUpdateLocation;
    
    struct{
        BOOL respondsDidUpdateToLocation;
        BOOL respondsDidUpdateDirection;
        BOOL respondsDidFailWithError;
        BOOL respondsDidLocationTimeOut;
        BOOL respondsDidStopUpdateLocation;
        BOOL respondsDidStopUpdateDirection;
    }_delegateFlags;
}
//@synthesize userLocation;
@dynamic desiredAccuracy, distanceFilter;
@synthesize userLocation = _userLocation;
- (void)dealloc
{
    [_locationManager setDelegate:nil];
}


+ (id)sharedManager
{
    static HUILocationManager *sharedHUILocationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHUILocationManager = [[HUILocationManager alloc] init];
    });
    
    return sharedHUILocationManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _newestLocation = kCLLocationCoordinate2DInvalid;
        _newestDirection = kHUILocationManagerDirectionInvalid;
        _locationTimeOut = kHUILocationManagerDefaultLocationTimeOut;
        
        //configurate the core location manager
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = 10; //update 1 time peer 10 meters;
    }
    
    return self;
}

- (void)setDelegate:(id<HUILocationManagerDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = delegate;
    
    _delegateFlags.respondsDidFailWithError = [(NSObject*)_delegate respondsToSelector:
                                               @selector(locationManager:didFailWithError:)];
    _delegateFlags.respondsDidLocationTimeOut = [(NSObject*)_delegate respondsToSelector:
                                                 @selector(locationManagerDidLocationTimeOut:)];
    _delegateFlags.respondsDidUpdateDirection = [(NSObject*)_delegate respondsToSelector:
                                                 @selector(locationManager:didUpdateUserDirection:)];
    _delegateFlags.respondsDidUpdateToLocation = [(NSObject*)_delegate respondsToSelector:
                                                  @selector(locationManager:didUpdateToLocation:fromLocation:)];
    _delegateFlags.respondsDidStopUpdateLocation = [(NSObject*)_delegate respondsToSelector:
                                                     @selector(locationManagerDidStopUpdateLocation:)];
    _delegateFlags.respondsDidStopUpdateDirection = [(NSObject*)_delegate respondsToSelector:
                                                     @selector(locationManagerDidStopUpdateDirection:)];
    if (_delegate == nil)
    {
        [self stopUpdateUserLocation];
        [self stopUpdateUserHeading];
    }
}

#pragma mark - Invocation
- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    _locationManager.desiredAccuracy = desiredAccuracy;
}

- (CLLocationAccuracy)desiredAccuracy
{
    return _locationManager.desiredAccuracy;
}

- (void)setDistanceFilter:(CLLocationDistance)distanceFilter
{
    _locationManager.distanceFilter = distanceFilter;
}

- (CLLocationDistance)distanceFilter
{
    return _locationManager.distanceFilter;
}


#pragma mark - Update Location
- (void)_checkIsLocateOperationTimeOut
{
    if (_successedUpdateLocation)
        return;
        
    if (self.didLocationTimeOut)
        self.didLocationTimeOut();
    
    if (_delegateFlags.respondsDidLocationTimeOut)
        [_delegate locationManagerDidLocationTimeOut:self];
}

- (BOOL)_isLocationServicesEnabled
{
    //!!!NOTE: 'locationServicesEnabled' only check iOS device location services setting is Opening
    //'authorizationStatus' checks if user allowed our app to use location services
    //!!!!!!!AND, if a iOS device with cellular connection DOWN, WIFI conection DOWN and has no GPS device,
    //this iOS device can't get location data unless any of the three ways can work.
    if (![CLLocationManager locationServicesEnabled]
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        //TODO: notify delegate?
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)startUpdateUserLocation
{
    if ([self _isLocationServicesEnabled])
    {
        [_locationManager startUpdatingLocation];
        
        //check is locate operation times out after a while
        _successedUpdateLocation = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(_checkIsLocateOperationTimeOut)
                                                   object:nil];
        [self performSelector:@selector(_checkIsLocateOperationTimeOut)
                   withObject:nil
                   afterDelay:self.locationTimeOut];
        
    }
}

- (void)stopUpdateUserLocation
{
    [_locationManager stopUpdatingLocation];
    
    if (self.didStopUpdateLocation)
        self.didStopUpdateLocation();
    if (_delegateFlags.respondsDidStopUpdateLocation)
        [_delegate locationManagerDidStopUpdateLocation:self];
}

#pragma mark -Start&Stop Update Heading
- (void)correctHeadingOrientation
{
    _locationManager.headingOrientation = [[UIApplication sharedApplication] statusBarOrientation];
}

- (void)startUpdateUserHeading
{
    if ([self _isLocationServicesEnabled])
    {
        //heading services is not avaliable on all iOS devices
        if ([CLLocationManager headingAvailable])
        {
            _locationManager.headingFilter = kHUILocationManagerHeadingFilter;
            [self correctHeadingOrientation];
            [_locationManager startUpdatingHeading];
        }
    }
}

- (void)stopUpdateUserHeading
{
    if ([CLLocationManager headingAvailable])
    {
        [_locationManager stopUpdatingHeading];
        
        if (self.didStopUpdateDirection)
            self.didStopUpdateDirection();
        if (_delegateFlags.respondsDidStopUpdateDirection)
            [_delegate locationManagerDidStopUpdateDirection:self];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    //get newest location info which update within recently 10 seconds
    NSTimeInterval howRecent = [newLocation.timestamp timeIntervalSinceNow];
   // self.userLocation = newLocation;
    if (abs(howRecent) <= 10.0)
    {
        CLLocationCoordinate2D newUserLocation = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,
                                                                            newLocation.coordinate.longitude);

       
        //mark we have successed updtae location
        _successedUpdateLocation = YES;
        
        //save the updated location
        CLLocationCoordinate2D oldLocation = _newestLocation;
        _newestLocation = newUserLocation;
        
        //notice delegate
        if (self.didUpdateToLocation)
            self.didUpdateToLocation(_newestLocation, oldLocation);
        if (_delegateFlags.respondsDidUpdateToLocation)
            [_delegate locationManager:self didUpdateToLocation:_newestLocation fromLocation:oldLocation];
        if (self.notificationsEnabled)
            [[NSNotificationCenter defaultCenter] postNotificationName:HUILocationManagerNotificationUserLocationUpdated
                                                                object:self
                                                              userInfo:nil];
    }
  
    //[self getLocalName];
    // else skip the event and process the next one.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //A negative value means that the reported heading is invalid
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading :
                                       (newHeading.magneticHeading - newHeading.headingAccuracy + kHUILocationManagerDirectionOffset));
    //save the newest direction
    _newestDirection = theHeading;
    
    //call delegate
    if (self.didUpdateUserDirection)
        self.didUpdateUserDirection(_newestDirection);
    if (_delegateFlags.respondsDidUpdateDirection)
        [_delegate locationManager:self didUpdateUserDirection:_newestDirection];
    if (self.notificationsEnabled)
        [[NSNotificationCenter defaultCenter] postNotificationName:HUILocationManagerNotificationUserDirectionUpdated
                                                            object:self
                                                          userInfo:nil];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
    if (self.didFailWithError)
        self.didFailWithError(error);
    if (_delegateFlags.respondsDidFailWithError)
        [_delegate locationManager:self didFailWithError:error];
}

#pragma mark - TestModal
- (void)testLocateToLocation:(CLLocationCoordinate2D)location
{
    if (!self.enableTestModal)
        return;
    [self locationManager:_locationManager
      didUpdateToLocation:[[CLLocation alloc] initWithLatitude:location.latitude
                                                     longitude:location.longitude]
             fromLocation:[[CLLocation alloc] initWithLatitude:self.newestLocation.latitude
                                                     longitude:self.newestLocation.longitude]];
}

- (void)testAddLongitude:(double)longitudeOffset
{
    if (!self.enableTestModal)
        return;
    [self locationManager:_locationManager
      didUpdateToLocation:[[CLLocation alloc] initWithLatitude:self.newestLocation.latitude
                                                     longitude:self.newestLocation.longitude + longitudeOffset]
             fromLocation:[[CLLocation alloc] initWithLatitude:self.newestLocation.latitude
                                                     longitude:self.newestLocation.longitude]];
}

- (void)testAddLatitude:(double)latitudeOffset
{
    if (!self.enableTestModal)
        return;
    [self locationManager:_locationManager
      didUpdateToLocation:[[CLLocation alloc] initWithLatitude:self.newestLocation.latitude + latitudeOffset
                                                     longitude:self.newestLocation.longitude]
             fromLocation:[[CLLocation alloc] initWithLatitude:self.newestLocation.latitude
                                                     longitude:self.newestLocation.longitude]];
}

@end
