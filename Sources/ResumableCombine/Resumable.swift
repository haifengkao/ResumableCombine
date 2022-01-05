//
//  Resumable.swift
//  ResumableCombine
//
//  Created by Hai Feng Kao on 2020-09-11
//
//

import Combine

public typealias AnyResumable = Cancellable & ResumableProtocol
/**
 Use `Reactive` proxy as customization point for constrained protocol extensions.

 General pattern would be:

 // 1. Extend Reactive protocol with constrain on Base
 // Read as: Reactive Extension where Base is a SomeType
 extension Reactive where Base: SomeType {
 // 2. Put any specific reactive extension for SomeType here
 }

 With this approach we can have more specialized methods and properties using
 `Base` and not just specialized on common base type.

 */

public struct ResumableCombine<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ResumableProtocol {
    func resume()
}

public extension Publisher {
    /// Reactive extensions.
    static var rm: ResumableCombine<Self>.Type {
        get {
            return ResumableCombine<Self>.self
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    var rm: ResumableCombine<Self> {
        get {
            return ResumableCombine(self)
        }
        // swiftlint:disable:next unused_setter_value
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}
