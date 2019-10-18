@interface Base64Coder : NSObject

+ (NSString *)base64StringFromData:(NSData *)data;

+ (NSData *)dataFromBase64String:(NSString *)string;

@end
