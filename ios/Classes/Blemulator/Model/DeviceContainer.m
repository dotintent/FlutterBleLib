#import "DeviceContainer.h"

@interface DeviceContainer ()

@property (readwrite) NSString *identifier;
@property (readwrite) NSString *name;

@end

@implementation DeviceContainer

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.name = name;
    }
    return self;
}

@end
