//
//  DebugHelper.swift
//  ResumableCombine
//
//  Created by Hai Feng Kao on 2020-09-12
//
//

import Combine

extension ResumableCombine where Base: Publisher {
    /// assert when the downstream request a demand which is too large.
    /// useful to detect if any downstream request an unlimited demand
    /// - Parameters:
    ///   - maxDemand: the max demand allowed
    ///   - message: the assert message
    /// - Returns: HandleEvents publisher
    public func assert(maxDemand: Subscribers.Demand, _ message: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.HandleEvents<Base> {
        return base.handleEvents(receiveRequest: { demand in
            Swift.assert(demand <= maxDemand, message, file: file, line: line)
        })
    }

    /// assert when the downstream request total demands which exceed the specified value.
    /// useful to detect if any downstream request too many values
    /// - Parameters:
    ///   - accumulatedDemand: the total accumulated demand allowed
    ///   - message: the assert message
    /// - Returns: HandleEvents publisher
    public func assert(accumulatedDemand: Subscribers.Demand, _ message: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.HandleEvents<Base> {
        var currentDemand: Subscribers.Demand = .max(0)
        return base.handleEvents(receiveRequest: { demand in

            currentDemand += demand
            Swift.assert(currentDemand <= accumulatedDemand, message, file: file, line: line)
        })
    }

    /// assert when the downstream request demands in a very short interval
    /// useful to detect if any downstream requests too fast
    /// - Parameters:
    ///   - minInterval: the minimum time interval allowed to send new demands
    ///   - message: the assert message
    /// - Returns: HandleEvents publisher
    public func assert(minInterval: DispatchTimeInterval, _ message: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.HandleEvents<Base> {
        var lastDemandDate: Date?

        return base.handleEvents(receiveRequest: { _ in
            let currentDate = Date()
            if let lastDate = lastDemandDate,
               lastDate.addingDispatchInterval(minInterval) > currentDate {
                Swift.assertionFailure(message, file: file, line: line)
            } else {
                lastDemandDate = currentDate
            }
        })
    }

    /// convinence method to ensure the publisher will receive the demands in a slow way
    public func assertSingleAndSlow(_ message: String = "", file: StaticString = #file, line: UInt = #line) -> Publishers.HandleEvents<Publishers.HandleEvents<Base>> {
        return self.assert(maxDemand: .max(1)).rm.assert(minInterval: .milliseconds(10), file: file, line: line)
    }
}

import struct Foundation.Date
import struct Foundation.TimeInterval
import enum Dispatch.DispatchTimeInterval

extension DispatchTimeInterval {
    var convertToSecondsFactor: Double {
        switch self {
        case .nanoseconds: return 1_000_000_000.0
        case .microseconds: return 1_000_000.0
        case .milliseconds: return 1_000.0
        case .seconds: return 1.0
        case .never: fatalError()
        @unknown default: fatalError()
        }
    }
}

extension Date {

    internal func addingDispatchInterval(_ dispatchInterval: DispatchTimeInterval) -> Date {
        switch dispatchInterval {
        case .nanoseconds(let value), .microseconds(let value), .milliseconds(let value), .seconds(let value):
            return self.addingTimeInterval(TimeInterval(value) / dispatchInterval.convertToSecondsFactor)
        case .never: return Date.distantFuture
        @unknown default: fatalError()
        }
    }
}
