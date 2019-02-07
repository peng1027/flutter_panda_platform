//
//  Keychain.swift
//  PDFoundation
//
//  Created by Kris Liu on 2018/12/15.
//  Copyright © 2018 Farfetch. All rights reserved.
//

import Foundation
import Security

public class Keychain {
    
    public static let shared = Keychain()
    
    public let service: String
    public let accessGroup: String?
    /// The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
    public var accessible: Accessible = .afterFirstUnlock
    /// Specifies that both synchronizable and non-synchronizable results should be returned from a query.
    public let synchronizable = AttributeValue.synchronizableAny
    
    /// - Parameters:
    ///   - service: A key whose value is a string indicating the item's service.
    ///   - accessGroup: A key whose value is a string indicating the access group an item is in.
    public init(service: String = Bundle.main.keychainName, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
        
        buildAttributesQuery()
    }
    
    // Saving Application Password
    private var query: Attributes = [AttributeName.itemClass: String(kSecClassGenericPassword)]
    
    private func buildAttributesQuery() {
        query[AttributeName.service] = service
        query[AttributeName.synchronizable] = synchronizable
        
        if let accessGroup = accessGroup {
            query[AttributeName.accessGroup] = accessGroup
        }
    }
}

extension Keychain {
    
    public func object<T: Storable>(forKey key: String) -> T? {
        var query = self.query
        query[AttributeName.account] = key
        query[AttributeName.returnData] = true
        query[AttributeName.matchLimit] = AttributeValue.matchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        guard T.self != Data.self else { return T(with: data) }
        
        let strValue: String = String(data: data, encoding: .utf8)!
        return T(with: strValue)
    }
    
    @discardableResult
    public func set<T: Storable>(_ value: T?, forKey key: String) -> Bool {
        var query = self.query
        query[AttributeName.account] = key
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        var data: Data?
        if let encodedValue = value?.encoded() {
            data = encodedValue is Data ? encodedValue as? Data : String(describing: encodedValue).data(using: .utf8)
        }
        
        switch status {
        case errSecSuccess:
            let attributes: [String: Any?] = [AttributeName.valueData: data, AttributeName.accessible: accessible.rawValue]
            status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        case errSecItemNotFound:
            var attributes = query
            attributes[AttributeName.valueData] = data
            attributes[AttributeName.accessible] = accessible.rawValue
            status = SecItemAdd(attributes as CFDictionary, nil)
        default:
            break
        }
        
        return status == errSecSuccess
    }
    
    @discardableResult
    public func delete(forKey key: String) -> Bool {
        var query = self.query
        query[AttributeName.account] = key
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
    
    @discardableResult
    public func deleteAll() -> Bool {
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

extension Keychain {
    
    public subscript<T: Storable>(key: String) -> T? {
        get { return object(forKey: key) }
        set { set(newValue, forKey: key) }
    }
}

extension Keychain {
    
    public func hasKey(_ key: String) -> Bool {
        var query = self.query
        query[AttributeName.account] = key
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    public var allKeys: [String] {
        return allAttributes.compactMap({ $0[AttributeName.account] as? String })
    }
    
    public var allAttributes: [Attributes] {
        var query = self.query
        query[AttributeName.returnAttributes] = true
        query[AttributeName.matchLimit] = AttributeValue.matchLimitAll
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let attributes = result as? [Attributes] else { return [] }
        return attributes
    }
}

extension Keychain {
    
    public enum Accessible {
        case whenUnlocked
        case afterFirstUnlock
        case always
        case whenUnlockedThisDeviceOnly
        case afterFirstUnlockThisDeviceOnly
        case alwaysThisDeviceOnly
        
        public var rawValue: String {
            let accessibleValue: CFString
            
            switch self {
            case .whenUnlocked:
                accessibleValue = kSecAttrAccessibleWhenUnlocked
            case .afterFirstUnlock:
                accessibleValue = kSecAttrAccessibleAfterFirstUnlock
            case .always:
                accessibleValue = kSecAttrAccessibleAlways
            case .whenUnlockedThisDeviceOnly:
                accessibleValue = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            case .afterFirstUnlockThisDeviceOnly:
                accessibleValue = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            case .alwaysThisDeviceOnly:
                accessibleValue = kSecAttrAccessibleAlwaysThisDeviceOnly
            }
            
            return String(accessibleValue)
        }
    }
}

extension Keychain {
    
    public typealias Attributes = [String: Any]
    
    private enum AttributeName {
        static let itemClass = String(kSecClass)
        static let service = String(kSecAttrService)
        static let accessGroup = String(kSecAttrAccessGroup)
        static let account = String(kSecAttrAccount)
        static let valueData = String(kSecValueData)
        static let accessible = String(kSecAttrAccessible)
        static let synchronizable = String(kSecAttrSynchronizable)
        static let matchLimit = String(kSecMatchLimit)
        static let returnData = String(kSecReturnData)
        static let returnAttributes = String(kSecReturnAttributes)
    }
    
    private enum AttributeValue {
        static let genericPassword = String(kSecClassGenericPassword)
        static let synchronizableAny = String(kSecAttrSynchronizableAny)
        static let matchLimitOne = String(kSecMatchLimitOne)
        static let matchLimitAll = String(kSecMatchLimitAll)
    }
}
