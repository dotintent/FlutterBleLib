#import <Flutter/Flutter.h>

@protocol FlutterMethodCallHandler

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

@end
