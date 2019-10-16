#import <CoreBluetooth/CoreBluetooth.h>
#import "Service.h"

@interface Characteristic : NSObject

@property uint objectId;
@property CBUUID * _Nonnull uuid;
@property NSData * _Nullable value;
@property Service * _Nonnull service;
@property BOOL isNotifying;

- (instancetype _Nonnull)initWithObjectId:(uint)objectId
                            uuid:(CBUUID * _Nonnull)uuid
                           value:(NSData * _Nullable)value
                         service:(Service * _Nonnull)service
                     isNotifying:(BOOL)isNotifying;

- (NSDictionary<NSString *,id> * _Nonnull)jsonObjectRepresentation;

@end
