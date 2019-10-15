#import "FlutterMethodCallHandler.h"
#import "ScannedPeripheral.h"

@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(ScannedPeripheral *)scannedPeripheral;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;

@end
