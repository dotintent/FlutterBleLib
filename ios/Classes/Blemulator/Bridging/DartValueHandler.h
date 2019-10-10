#import "FlutterMethodCallHandler.h"

@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(id)value;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;

@end
