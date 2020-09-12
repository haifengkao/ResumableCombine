# ResumableCombine

[![CI Status](https://img.shields.io/travis/HaiFengKao/ResumableCombine.svg?style=flat)](https://travis-ci.org/HaiFengKao/ResumableCombine)
[![Version](https://img.shields.io/cocoapods/v/ResumableCombine.svg?style=flat)](https://cocoapods.org/pods/ResumableCombine)
[![License](https://img.shields.io/cocoapods/l/ResumableCombine.svg?style=flat)](https://cocoapods.org/pods/ResumableCombine)
[![Platform](https://img.shields.io/cocoapods/p/ResumableCombine.svg?style=flat)](https://cocoapods.org/pods/ResumableCombine)


Swift Combine lacks of support for proper backpressure handling. Many of its operators just send `request(.unlimited)` for the first demand request. It renders the Combine's pull mechanism utterly uselesss. This project aims to fix this problem.

## Example

Sink that will request one item at a time.
```swift
let subscription = [1,2,3,4,5].publisher
    .rm.sink(
        receiveCompletion: { completion in
            print("Completion: \(completion)")
        },
        receiveValue: { value -> Bool in
             print("Receive value: \(value)")

             // return true indicates that we want to request for another demand
             return true
        }
    )

// Receive value: 1
// Receive value: 2
// Receive value: 3
// Receive value: 4
// Receive value: 5
```




Sink that will request one item then stop.

We can use `subscription.resume()` to request for additional items.
```swift
let subscription = (1 ... Int.max).publisher
    .rm.sink(
        receiveCompletion: { completion in
            print("Completion: \(completion)")
        },
        receiveValue: { value -> Bool in
             print("Receive value: \(value)")

             // return false will stop the demands
             return false
        }
    )
// Receive value: 1

// Receive value: 2
subscription.resume()

// Receive value: 3
subscription.resume()

// Receive value: 4
subscription.resume()
```

Assign that will request one item at a time.
```swift
class SomeObject {
    var value: Int = -1 {
        didSet {
            print(value)
        }
    }
}

let object = SomeObject()
let subscription = [1, 2, 3, 4, 5].publisher.rm.assign(to: \.value, on: object)

// object.value == 1
// object.value == 2
// object.value == 3
// object.value == 4
// object.value == 5
```



Assign that will request one item then stop.

We can use `subscription.resume()` to request for additional items.
```swift
let subscription = (1 ... Int.max).publisher.rm.assign(to: \.value, on: object, mode: .singleDemandThenStop)

// object.value == 1

// object.value == 2
subscription.resume()

// object.value == 3
subscription.resume()
```


## FlatMap
Combine's `FlatMap` works quite unexpectedly. Despite the resumable sink has stooped the demand. `FlatMap` continues sending all its values.

```swift
let subscription = (1 ... 100).publisher.flatMap(maxPublishers: .max(1)) { value -> AnyPublisher<Int, Never> in
    print("Receive flatMap:", value)
    return AnyPublisher([10].publisher) // sends single value then complete
}.rm.sink { (completion) in
    print(completion)
} receiveValue: { (value) -> Bool in
    print("Receive value: ", value)

    return false // stop requesting new demands
}
// Receive flatMap: 1
// Receive value:  10
// Receive flatMap: 2
// Receive flatMap: 3
// Receive flatMap: 4
// Receive flatMap: 5
// Receive flatMap: 6
// Receive flatMap: 7
// Receive flatMap: 8
// Receive flatMap: 9
// Receive flatMap: 10
// ...
// Receive flatMap: 100
```


If we let the publisher inside `flatMap` send 2 values, `FlatMap` will send 2 values, despite the resumable sink only requests single demand.
```swift
let subscription = (1 ... 100).publisher.flatMap(maxPublishers: .max(1)) { value -> AnyPublisher<Int, Never> in
    print("Receive flatMap:", value)
    return AnyPublisher([10, 20].publisher) // sends 2 values then complete
}.rm.sink { (completion) in
    print(completion)
} receiveValue: { (value) -> Bool in
    print("Receive value: ", value)

    return false // stop requesting new demands
}

// Receive flatMap: 1
// Receive value:  10
// Receive flatMap: 2
```

ResumbableCombine provides `rm.FlatMap` will fix these problems

```swift
let subscription = (1 ... 100).publisher.rm.flatMap(maxPublishers: .max(1)) { value -> AnyPublisher<Int, Never> in
    print("Receive flatMap:", value)
    return AnyPublisher([10, 20].publisher)
}.rm.sink { (completion) in
    print(completion)
} receiveValue: { (value) -> Bool in
    print("Receive value: ", value)

    return false // stop requesting new demands
}

// Receive flatMap: 1
// Receive value:  10
```

```swift
let subscription = (1 ... 100).publisher.rm.flatMap(maxPublishers: .max(1)) { value -> AnyPublisher<Int, Never> in
    print("Receive flatMap:", value)
    return AnyPublisher([10].publisher)
}.rm.sink { (completion) in
    print(completion)
} receiveValue: { (value) -> Bool in
    print("Receive value: ", value)

    return false // stop requesting new demands
}

// Receive flatMap: 1
// Receive value:  10
```


## Requirements
ios 13

## Installation

ResumableCombine is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ResumableCombine'
```

## Author

Hai Feng Kao, haifeng@cocoaspice.in

## License

ResumableCombine is available under the MIT license. See the LICENSE file for more info.
