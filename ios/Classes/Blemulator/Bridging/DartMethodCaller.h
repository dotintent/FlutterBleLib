#import "FlutterMethodCallHandler.h"

@interface DartMethodCaller : NSObject<FlutterMethodCallHandler>

- (instancetype)initWithDartMethodChannel:(FlutterMethodChannel *)dartMethodChannel;

@end
