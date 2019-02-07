#import "FlutterPandaPlatformPlugin.h"
#import <flutter_panda_platform/flutter_panda_platform-Swift.h>

@implementation FlutterPandaPlatformPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPandaPlatformPlugin registerWithRegistrar:registrar];
}
@end
