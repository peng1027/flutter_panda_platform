//
//  Bundle+Utils.swift
//  PDFoundation
//
//  Created by Kris Liu on 2018/11/5.
//  Copyright © 2018 Farfetch. All rights reserved.
//

import Foundation

public extension Bundle {
    
    public var bundleID: String {
        return bundleIdentifier ?? ""
    }
    
    public var bundleName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    public var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    public var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
    public var displayName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    public var copyright: String? {
        return infoDictionary?["NSHumanReadableCopyright"] as? String
    }
    
    public var suiteName: String {
        return bundleID
    }
    
    public var groupName: String {
        let name = "group.\(bundleID)"
        return isExtension ? (name as NSString).deletingPathExtension : name
    }
    
    public var keychainName: String {
        let name = "keychain.\(bundleID)"
        return isExtension ? (name as NSString).deletingPathExtension : name
    }
}

private extension Bundle {
    
    var isExtension: Bool {
        return ((infoDictionary?["NSExtension"] as? [String: Any]) != nil)
    }
}
