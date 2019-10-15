#import "FlutterMethodCallHandler.h"

<<<<<<< HEAD
@protocol DartValueHandlerScanEventDelegate

- (void)dispatchDartValueHandlerScanEvent:(id)value;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property id <DartValueHandlerScanEventDelegate> scanEventDelegate;

=======
@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

>>>>>>> blemulator/temp-develop
@end
