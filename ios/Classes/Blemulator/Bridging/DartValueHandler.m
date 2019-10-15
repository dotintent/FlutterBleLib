#import "DartValueHandler.h"
<<<<<<< HEAD
#import <flutter_ble_lib-Swift.h>
#import "PlatformMethodName.h"
=======
>>>>>>> blemulator/temp-develop

@implementation DartValueHandler

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
<<<<<<< HEAD
    if ([PLATFORM_METHOD_NAME_PUBLISH_SCAN_RESULT isEqualToString:call.method]) {
        [self.scanEventDelegate dispatchDartValueHandlerScanEvent:call.arguments];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
=======
    
>>>>>>> blemulator/temp-develop
}

@end
