#import "FlutterMethodCallHandler.h"
#import "ScannedPeripheral.h"
#import "ConnectionStateEvent.h"

@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(ScannedPeripheral *)scannedPeripheral;

@end

@protocol DartValueHandlerConnectionEventDelegate

- (void)dispatchDartValueHandlerConnectionStateEvent:(ConnectionStateEvent *)connectionStateEvent;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property NSMutableArray<NSString *> * observedDeviceIdentifiers;

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;
@property id <DartValueHandlerConnectionEventDelegate> connectionEventDelegate;

@end
