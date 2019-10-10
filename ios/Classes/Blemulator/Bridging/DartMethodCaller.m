#import "DartMethodCaller.h"

@interface DartMethodCaller ()

@property (nonatomic) FlutterMethodChannel *dartMethodChannel;

@end

@implementation DartMethodCaller

// MARK: - Synthesize properties

@synthesize dartMethodChannel;

// MARK: - Initializers

- (instancetype)initWithDartMethodChannel:(FlutterMethodChannel *)dartMethodChannel {
    self = [super init];
    if (self) {
        self.dartMethodChannel = dartMethodChannel;
    }
    return self;
}

// MARK: - FlutterMethodCallHandler implementation

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {

}

@end
