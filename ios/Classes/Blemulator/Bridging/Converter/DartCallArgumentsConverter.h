#import "ScannedPeripheral.h"
#import "ConnectionStateEvent.h"
#import "Characteristic.h"
#import "BleError.h"

@interface DartCallArgumentsConverter : NSObject

+ (ScannedPeripheral * _Nonnull)scannedPeripheralFromCallArguments:(NSDictionary<NSString *, id> * _Nonnull)callArguments;

+ (ConnectionStateEvent * _Nonnull)connectionStateEventFromCallArguments:(NSDictionary<NSString *, id> * _Nonnull)callArguments;

+ (Characteristic * _Nonnull)characteristicFromCallArguments:(NSDictionary<NSString *,id> * _Nonnull)callArguments;

+ (BleError * _Nonnull)bleErrorFromCallArguments:(NSDictionary<NSString *,id> * _Nonnull)callArguments;

@end
