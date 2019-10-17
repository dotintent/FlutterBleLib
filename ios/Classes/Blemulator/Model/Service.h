#import <CoreBluetooth/CoreBluetooth.h>
#import "Peripheral.h"

@interface Service : NSObject

@property int objectId;
@property CBUUID * _Nonnull uuid;
@property Peripheral * _Nonnull peripheral;
@property BOOL isPrimary;

- (instancetype _Nonnull)initWithObjectId:(int)objectId
                                     uuid:(CBUUID * _Nonnull)uuid
                               peripheral:(Peripheral * _Nonnull)peripheral
                                isPrimary:(BOOL)isPrimary;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
