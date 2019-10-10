#import "FlutterMethodCallHandler.h"

@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(NSDictionary *)value;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;

@end
