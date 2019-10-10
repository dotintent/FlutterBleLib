#import "DartMethodCaller.h"
#import "DartValueHandler.h"

@protocol BleAdapter;

@interface SimulatedAdapter : NSObject<BleAdapter, DartValueHandlerDelegate>

- (instancetype)initWithDartMethodCaller:(DartMethodCaller *)dartMethodCaller
                        dartValueHandler:(DartValueHandler *)dartValueHandler;

@end
