#import "MethodName.h"

@implementation MethodName

NSString * const METHOD_NAME_CREATE_CLIENT = @"createClient";
NSString * const METHOD_NAME_DESTROY_CLIENT = @"destroyClient";
NSString * const METHOD_NAME_START_DEVICE_SCAN = @"startDeviceScan";
NSString * const METHOD_NAME_STOP_DEVICE_SCAN = @"stopDeviceScan";

NSString * const METHOD_NAME_CONNECT_TO_DEVICE = @"connectToDevice";
NSString * const METHOD_NAME_IS_DEVICE_CONNECTED = @"isDeviceConnected";
NSString * const METHOD_NAME_OBSERVE_CONNECTION_STATE = @"observeConnectionState";
NSString * const METHOD_NAME_CANCEL_CONNECTION = @"cancelConnection";

NSString * const METHOD_NAME_DISCOVER_ALL_SERVICES_AND_CHARACTERISTICS = @"discoverAllServicesAndCharacteristics";
NSString * const METHOD_NAME_GET_SERVICES = @"services";
NSString * const METHOD_NAME_GET_CHARACTERISTICS = @"characteristics";
NSString * const METHOD_NAME_GET_CHARACTERISTICS_FOR_SERVICE = @"characteristicsForService";

NSString * const METHOD_NAME_LOG_LEVEL = @"logLevel";
NSString * const METHOD_NAME_SET_LOG_LEVEL = @"setLogLevel";

NSString * const METHOD_NAME_RSSI = @"rssi";

NSString * const METHOD_NAME_REQUEST_MTU = @"requestMtu";

NSString * const METHOD_NAME_READ_CHARACTERISTIC_FOR_IDENTIFIER = @"readCharacteristicForIdentifier";
NSString * const METHOD_NAME_READ_CHARACTERISTIC_FOR_DEVICE = @"readCharacteristicForDevice";
NSString * const METHOD_NAME_READ_CHARACTERISTIC_FOR_SERVICE = @"readCharacteristicForService";

@end
