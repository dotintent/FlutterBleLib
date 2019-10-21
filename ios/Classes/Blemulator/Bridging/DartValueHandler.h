#import "FlutterMethodCallHandler.h"
#import "ScannedPeripheral.h"
#import "ConnectionStateEvent.h"
#import "Characteristic.h"
#import "BleError.h"

@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(ScannedPeripheral *)scannedPeripheral;

@end

@protocol DartValueHandlerConnectionEventDelegate

- (void)dispatchDartValueHandlerConnectionStateEvent:(ConnectionStateEvent *)connectionStateEvent;

@end

@protocol DartValueHandlerReadEventDelegate

- (void)dispatchDartValueHandlerReadEvent:(Characteristic *)characteristic
                            transactionId:(NSString *)transactionId;

- (void)dispatchDartValueHandlerReadError:(BleError *)bleError
                            transactionId:(NSString *)transactionId;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property NSMutableArray<NSString *> *observedDeviceIdentifiers;
@property NSMutableArray<NSString *> *monitoredCharacteristics;

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;
@property id <DartValueHandlerConnectionEventDelegate> connectionEventDelegate;
@property id <DartValueHandlerReadEventDelegate> readEventDelegate;

@end
