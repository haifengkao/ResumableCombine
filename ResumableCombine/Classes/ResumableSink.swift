//
//  ResumableSink.swift
//
//  Created by Hai-Feng Kao on 2020-09-11
//
//  copied from https://onevcat.com/2019/12/backpressure-in-combine/

import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Subscribers {
    class ResumableSink<Input, Failure: Error>: Subscriber, Cancellable, ResumableProtocol {
        let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
        let receiveValue: (Input) -> Bool

        var shouldPullNewValue: Bool = false

        var subscription: Subscription?

        init(
            receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
            receiveValue: @escaping (Input) -> Bool
        ) {
            self.receiveCompletion = receiveCompletion
            self.receiveValue = receiveValue
        }

        public func receive(subscription: Subscription) {
            self.subscription = subscription
            resume()
        }

        public func receive(_ input: Input) -> Subscribers.Demand {
            shouldPullNewValue = receiveValue(input)
            return shouldPullNewValue ? .max(1) : .none
        }

        public func receive(completion: Subscribers.Completion<Failure>) {
            receiveCompletion(completion)
            subscription = nil
        }

        public func cancel() {
            subscription?.cancel()
            subscription = nil
        }

        public func resume() {
            guard !shouldPullNewValue else {
                return
            }
            shouldPullNewValue = true
            subscription?.request(.max(1))
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ResumableCombine where Base: Publisher {
    typealias Failure = Base.Failure
    typealias Output = Base.Output

    func sink(
        receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping (Output) -> Bool
    ) -> AnyResumable {
        let sink = Subscribers.ResumableSink<Output, Failure>(
            receiveCompletion: receiveCompletion,
            receiveValue: receiveValue
        )
        base.subscribe(sink)
        return sink
    }
}

// var buffer = [Int]()
// let subscriber = (1...).publisher.print().resumableSink(
//     receiveCompletion: { completion in
//         print("Completion: \(completion)")
//     },
//     receiveValue: { value in
//         print("Receive value: \(value)")
//         buffer.append(value)
//         return buffer.count < 5
//     }
// )

// let cancellable = Timer.publish(every: 1, on: .main, in: .default)
//     .autoconnect()
//     .sink { _ in
//         buffer.removeAll()
//         subscriber.resume()
//     }

/*

 extension Reactive where Base: UIDatePicker {
     /// Reactive wrapper for `date` property.
     public var date: ControlProperty<Date> {
         return value
     }

     /// Reactive wrapper for `date` property.
     public var value: ControlProperty<Date> {
         return base.rx.controlPropertyWithDefaultEvents(
             getter: { datePicker in
                 datePicker.date
             }, setter: { datePicker, value in
                 datePicker.date = value
             }
         )
     }

     /// Reactive wrapper for `countDownDuration` property.
     public var countDownDuration: ControlProperty<TimeInterval> {
         return base.rx.controlPropertyWithDefaultEvents(
             getter: { datePicker in
                 datePicker.countDownDuration
             }, setter: { datePicker, value in
                 datePicker.countDownDuration = value
             }
         )
     }
 }
 */
