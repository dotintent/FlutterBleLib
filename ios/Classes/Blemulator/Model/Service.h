#import <CoreBluetooth/CoreBluetooth.h>
#import "Peripheral.h"

@interface Service : NSObject

@property uint objectId;
@property CBUUID * _Nonnull uuid;
@property Peripheral * _Nonnull peripheral;
@property BOOL isPrimary;

- (instancetype _Nonnull)initWithObjectId:(uint)objectId
                            uuid:(CBUUID * _Nonnull)uuid
                      peripheral:(Peripheral * _Nonnull)peripheral
                       isPrimary:(BOOL)isPrimary;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
