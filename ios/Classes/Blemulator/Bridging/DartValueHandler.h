#import "FlutterMethodCallHandler.h"
#import "ScannedPeripheral.h"
#import "ConnectionStateEvent.h"
#import "Characteristic.h"

@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(ScannedPeripheral *)scannedPeripheral;

@end

@protocol DartValueHandlerConnectionEventDelegate

- (void)dispatchDartValueHandlerConnectionStateEvent:(ConnectionStateEvent *)connectionStateEvent;

@end

@protocol DartValueHandlerReadEventDelegate

- (void)dispatchDartValueHandlerReadEvent:(Characteristic *)characteristic;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property NSMutableArray<NSString *> * observedDeviceIdentifiers;

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;
@property id <DartValueHandlerConnectionEventDelegate> connectionEventDelegate;
@property id <DartValueHandlerReadEventDelegate> readEventDelegate;

@end
