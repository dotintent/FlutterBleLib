#import "ScannedPeripheral.h"

@interface DartCallArgumentsConverter : NSObject

+ (ScannedPeripheral * _Nonnull)scannedPeripheralFromCallArguments:(NSDictionary<NSString *, id> * _Nonnull)callArguments;

@end
