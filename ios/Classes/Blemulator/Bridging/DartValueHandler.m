#import "DartValueHandler.h"
#import <flutter_ble_lib-Swift.h>
#import "PlatformMethodName.h"
#import "ScannedPeripheral.h"
#import "DartCallArgumentsConverter.h"

@implementation DartValueHandler

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([PLATFORM_METHOD_NAME_PUBLISH_SCAN_RESULT isEqualToString:call.method]) {
        ScannedPeripheral *scannedPeripheral = [DartCallArgumentsConverter scannedPeripheralFromCallArguments:call.arguments];
        [self.scanEventDelegate dispatchDartValueHandlerScanEvent:[scannedPeripheral jsonObjectRepresentation]];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
