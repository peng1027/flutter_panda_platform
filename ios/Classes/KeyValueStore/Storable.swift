//
//  Storable.swift
//  PDFoundation
//
//  Created by Kris Liu on 2018/12/21.
//  Copyright © 2018 Farfetch. All rights reserved.
//

import Foundation

public protocol Storable {
    
    func encoded() -> Any?
    init?(with object: Any?)
    init?(with string: String)
}

extension Storable {
    
    public init?(with string: String) {
        if Self.self == Int.self {
            self = Int(string) as! Self
        } else if Self.self  == Bool.self {
            self = Bool(string) as! Self
        } else if Self.self == Float.self {
            self = Float(string) as! Self
        } else if Self.self == Double.self {
            self = Double(string) as! Self
        }
        self = string as! Self
    }
}

extension Int: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Int else { return nil }
        self = value
    }
}

extension Bool: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Bool else { return nil }
        self = value
    }
}

extension Float: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Float else { return nil }
        self = value
    }
}

extension Double: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Double else { return nil }
        self = value
    }
}

extension String: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? String else { return nil }
        self = value
    }
}

extension URL: Storable {

    public func encoded() -> Any? {
        return self.absoluteString
    }

    public init?(with object: Any?) {
        guard let value = object as? String, let url = URL(string: value) else { return nil }
        self = url
    }
}

extension Array: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Array else { return nil }
        self = value
    }
}

extension Dictionary: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Dictionary else { return nil }
        self = value
    }
}

extension Data: Storable {

    public func encoded() -> Any? {
        return self
    }

    public init?(with object: Any?) {
        guard let value = object as? Data else { return nil }
        self = value
    }
}

extension Set: Storable {

    public func encoded() -> Any? {
        return Array(self)
    }

    public init?(with object: Any?) {
        guard let value = object as? [Element] else { return nil }
        self = Set(value)
    }
}
