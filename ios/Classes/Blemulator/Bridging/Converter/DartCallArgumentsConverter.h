#import "ScannedPeripheral.h"
#import "ConnectionStateEvent.h"
#import "Characteristic.h"

@interface DartCallArgumentsConverter : NSObject

+ (ScannedPeripheral * _Nonnull)scannedPeripheralFromCallArguments:(NSDictionary<NSString *, id> * _Nonnull)callArguments;

+ (ConnectionStateEvent * _Nonnull)connectionStateEventFromCallArguments:(NSDictionary<NSString *, id> * _Nonnull)callArguments;

+ (Characteristic *)characteristicFromCallArguments:(NSDictionary<NSString *,id> *)callArguments;

@end
