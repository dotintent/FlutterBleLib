#import <CoreBluetooth/CoreBluetooth.h>
#import "Peripheral.h"

@interface Service : NSObject

@property int objectId;
@property CBUUID * _Nonnull uuid;
@property NSString * _Nonnull peripheralIdentifier;
@property BOOL isPrimary;

- (instancetype _Nonnull)initWithObjectId:(int)objectId
                                     uuid:(CBUUID * _Nonnull)uuid
                     peripheralIdentifier:(NSString * _Nonnull)peripheralIdentifier
                                isPrimary:(BOOL)isPrimary;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
