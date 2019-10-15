#import <Flutter/Flutter.h>

@interface DartMethodCaller : NSObject

- (instancetype)initWithDartMethodChannel:(FlutterMethodChannel *)dartMethodChannel;

- (void)createClient;

- (void)startDeviceScan;

@end
