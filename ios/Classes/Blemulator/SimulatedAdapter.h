#import "DartMethodCaller.h"
#import "DartValueHandler.h"

@protocol BleAdapter;

@interface SimulatedAdapter : NSObject<BleAdapter, DartValueHandlerScanEventDelegate, DartValueHandlerConnectionEventDelegate, DartValueHandlerReadEventDelegate>

- (instancetype)initWithDartMethodCaller:(DartMethodCaller *)dartMethodCaller
                        dartValueHandler:(DartValueHandler *)dartValueHandler;

@end
