import Flutter
import UIKit

public class SwiftFlutterPandaPlatformPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_panda_platform", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPandaPlatformPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let partsOfCall: [String] = call.method.components(separatedBy: "/")
        guard partsOfCall.count > 0 else {
            result(errorMessage("\(call.method)"))
            return
        }

        switch partsOfCall[0] {
        case CallMethods.Bundle:
            result(handleBundleUtils(withParts: partsOfCall))

        default:
            result(errorMessage("\(call.method)"))
        }
    }

    func errorMessage(_ msg: String) -> String {
        return "fails in \"\(msg)\" is not supported."
    }

    enum CallMethods {
        static let Bundle: String = "bundle"
    }
}

extension SwiftFlutterPandaPlatformPlugin {
    func handleBundleUtils(withParts parts: [String]) -> Any? {
        guard parts.count > 1 else {
            return errorMessage("could not handle the invalid comand: \(parts)")
        }

        switch parts[1] {
        case BundleConstants.ID: return Bundle.main.bundleID;
        case BundleConstants.Name: return Bundle.main.bundleName;
        case BundleConstants.Version: return Bundle.main.version;
        case BundleConstants.BuildNumber: return Bundle.main.buildNumber;
        case BundleConstants.DisplayName: return Bundle.main.displayName;
        case BundleConstants.Copyright: return Bundle.main.copyright;
        case BundleConstants.SuiteName: return Bundle.main.suiteName;
        case BundleConstants.GroupName: return Bundle.main.groupName;
        case BundleConstants.KeyChainName: return Bundle.main.keychainName;
        default: return nil
        }
    }

    enum BundleConstants {
        static let ID: String = "id"
        static let Name: String = "name"
        static let Version: String = "version"
        static let BuildNumber: String = "build_ver"
        static let DisplayName: String = "display_name"
        static let Copyright: String = "copyright"
        static let SuiteName: String = "suite_name"
        static let GroupName: String = "group_name"
        static let KeyChainName: String = "keychain_name"
    }
}
