//
//  ResumableAssign.swift
//
//  Created by Hai-Feng Kao on 2020-09-11
//
//

import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
internal enum SubscriptionStatus {
    case awaitingSubscription
    case subscribed(Subscription)
    case terminal
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Subscribers {
    public final class ResumableAssign<Root, Input>: Subscriber,
        Cancellable,
        ResumableProtocol,
        CustomStringConvertible,
        CustomReflectable,
        CustomPlaygroundDisplayConvertible {
        // NOTE: this class has been audited for thread safety.
        // Combine doesn't use any locking here.

        public typealias Failure = Never

        public private(set) var object: Root?

        public let keyPath: ReferenceWritableKeyPath<Root, Input>

        private var status = SubscriptionStatus.awaitingSubscription

        private let mode: ResumableAssignMode

        public var description: String { return "ResumableAssign \(Root.self)." }

        public var customMirror: Mirror {
            let children: [Mirror.Child] = [
                ("object", object as Any),
                ("keyPath", keyPath),
                ("status", status as Any),
            ]
            return Mirror(self, children: children)
        }

        public var playgroundDescription: Any { return description }

        public init(object: Root, keyPath: ReferenceWritableKeyPath<Root, Input>, mode: ResumableAssignMode) {
            self.object = object
            self.keyPath = keyPath
            self.mode = mode
        }

        public func receive(subscription: Subscription) {
            switch status {
            case .subscribed, .terminal:
                subscription.cancel()
            case .awaitingSubscription:
                status = .subscribed(subscription)
                subscription.request(.max(1))
            }
        }

        public func receive(_ value: Input) -> Subscribers.Demand {
            switch status {
            case .subscribed:
                object?[keyPath: keyPath] = value
            case .awaitingSubscription, .terminal:
                break
            }

            switch mode {
            case .singleDemandAllTheTime:
                return .max(1)
            case .singleDemandThenStop:
                return .none
            }
        }

        public func receive(completion _: Subscribers.Completion<Never>) {
            cancel()
        }

        public func cancel() {
            guard case let .subscribed(subscription) = status else {
                return
            }
            subscription.cancel()
            status = .terminal
            object = nil
        }

        public func resume() {
            guard case let .subscribed(subscription) = status else {
                return
            }

            switch mode {
            case .singleDemandAllTheTime:
                // we already send the demand at receive(_ value:)
                break
            case .singleDemandThenStop:
                subscription.request(.max(1))
            }
        }
    }
}

public enum ResumableAssignMode {
    case singleDemandAllTheTime // when it receives the first value, it will always after for the second one
    case singleDemandThenStop // after it receives the first value, it will stop requesting
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ResumableCombine where Base: Publisher, Base.Failure == Never {
    /// Assigns each element from a Publisher to a property on an object.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to assign.
    ///   - object: The object on which to assign the value.
    /// - Returns: A cancellable instance; used when you end assignment
    ///   of the received value. Deallocation of the result will tear down
    ///   the subscription stream.
    func assign<Root>(to keyPath: ReferenceWritableKeyPath<Root, Output>,
                      on object: Root,
                      mode: ResumableAssignMode = .singleDemandAllTheTime) -> AnyResumable {
        let subscriber = Subscribers.ResumableAssign(object: object, keyPath: keyPath, mode: mode)
        base.subscribe(subscriber)
        return subscriber
    }
}
