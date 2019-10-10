#import "DartValueHandler.h"

@implementation DartValueHandler

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"" isEqualToString:call.method]) {

    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
