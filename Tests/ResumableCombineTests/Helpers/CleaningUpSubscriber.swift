//
//  CleaningUpSubscriber.swift
//
//
//  Created by Sergej Jaskiewicz on 17.10.2019.
//

#if OPENCOMBINE_COMPATIBILITY_TEST
    import Combine
#else
    import Combine
#endif

@available(macOS 10.15, iOS 13.0, *)
final class CleaningUpSubscriber<Input, Failure: Error>: Subscriber {
    private(set) var subscription: Subscription?

    private let onDeinit: () -> Void

    init(onDeinit: @escaping () -> Void) {
        self.onDeinit = onDeinit
    }

    deinit {
        onDeinit()
    }

    func receive(subscription: Subscription) {
        self.subscription = subscription
    }

    func receive(_: Input) -> Subscribers.Demand {
        return .none
    }

    func receive(completion _: Subscribers.Completion<Failure>) {
        subscription = nil
    }
}
