#import "FlutterMethodCallHandler.h"

@protocol DartValueHandlerDelegate

- (void)dispatchDartValueHandlerEvent:(NSString *)bleEvent
                                value:(id)value;

@end

@interface DartValueHandler : NSObject<FlutterMethodCallHandler>

@property id <DartValueHandlerDelegate> delegate;

@end
