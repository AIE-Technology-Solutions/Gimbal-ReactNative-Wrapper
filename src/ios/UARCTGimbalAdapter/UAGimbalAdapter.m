/* Copyright 2017 Urban Airship and Contributors */

#import "UAGimbalAdapter.h"

#import <Gimbal/Gimbal.h>


@interface UAGimbalAdapter() <GMBLPlaceManagerDelegate>
@property (nonatomic, strong) GMBLPlaceManager *placeManager;
@property (nonatomic) GMBLDeviceAttributesManager * deviceAttributesManager;
@end

NSString *const GimbalSource = @"Gimbal";

// NSUserDefault Keys
NSString *const GimbalAlertViewKey = @"gmbl_hide_bt_power_alert_view";
NSString *const UAGimbalAdapterStarted = @"com.gimbal.started";
NSString *const UAGimbalAdapterApiKey = @"com.gimbal.api_key";

@implementation UAGimbalAdapter

static id _sharedObject = nil;

- (void)setGimbalApiKey:(NSString *)gimbalApiKey {

    if (gimbalApiKey) {
        [[NSUserDefaults standardUserDefaults] setValue:gimbalApiKey forKey:UAGimbalAdapterApiKey];
        [Gimbal setAPIKey:gimbalApiKey options:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UAGimbalAdapterApiKey];
    }
}

- (NSString *)gimbalApiKey {
    return [[NSUserDefaults standardUserDefaults] valueForKey:UAGimbalAdapterApiKey];
}

+ (instancetype)shared {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (self.gimbalApiKey) {
            [Gimbal setAPIKey:self.gimbalApiKey options:nil];
        }

        self.placeManager = [[GMBLPlaceManager alloc] init];
        self.placeManager.delegate = self;
        self.deviceAttributesManager = [[GMBLDeviceAttributesManager alloc] init];

        // Hide the power alert by default
        if (![[NSUserDefaults standardUserDefaults] valueForKey:GimbalAlertViewKey]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GimbalAlertViewKey];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateDeviceAttributes)
                                                     name:UAChannelCreatedEvent
                                                   object:nil];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:UAGimbalAdapterStarted]) {
            [self start];
        }
    }

    return self;
}

- (void)dealloc {
    self.placeManager.delegate = nil;
}

- (BOOL)isBluetoothPoweredOffAlertEnabled {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:GimbalAlertViewKey];
}

- (void)setBluetoothPoweredOffAlertEnabled:(BOOL)bluetoothPoweredOffAlertEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:!bluetoothPoweredOffAlertEnabled
                                            forKey:GimbalAlertViewKey];
}

- (void)start {
    [Gimbal start];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UAGimbalAdapterStarted];
}

- (void)stop {
    [Gimbal stop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UAGimbalAdapterStarted];
}

- (BOOL)isStarted {
    return [[NSUserDefaults standardUserDefaults] boolForKey:UAGimbalAdapterStarted] && [Gimbal isStarted];
}

#pragma mark Gimbal place callbacks

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit {
    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didBeginVisit:)]) {
        [strongDelegate placeManager:manager didBeginVisit:visit];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit {
    if (!self.isStarted) {
        return;
    }

    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didEndVisit:)]) {
        [strongDelegate placeManager:manager didEndVisit:visit];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit withDelay:(NSTimeInterval)delayTime {
    if (!self.isStarted) {
        return;
    }

    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didBeginVisit:withDelay:)]) {
        [strongDelegate placeManager:manager didBeginVisit:visit withDelay:delayTime];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didReceiveBeaconSighting:(GMBLBeaconSighting *)sighting forVisits:(NSArray *)visits {
    if (!self.isStarted) {
        return;
    }
    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didReceiveBeaconSighting:forVisits:)]) {
        [strongDelegate placeManager:manager didReceiveBeaconSighting:sighting forVisits:visits];
    }
}

- (void)placeManager:(GMBLPlaceManager *)manager didDetectLocation:(CLLocation *)location {
    if (!self.isStarted) {
        return;
    }
    id strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(placeManager:didDetectLocation:)]) {
        [strongDelegate placeManager:manager didDetectLocation:location];
    }
}

@end
