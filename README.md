# ResumableCombine

[![CI Status](https://img.shields.io/travis/Hai\ Feng\ Kao/ResumableCombine.svg?style=flat)](https://travis-ci.org/Hai\ Feng\ Kao/ResumableCombine)
[![Version](https://img.shields.io/cocoapods/v/ResumableCombine.svg?style=flat)](https://cocoapods.org/pods/ResumableCombine)
[![License](https://img.shields.io/cocoapods/l/ResumableCombine.svg?style=flat)](https://cocoapods.org/pods/ResumableCombine)
[![Platform](https://img.shields.io/cocoapods/p/ResumableCombine.svg?style=flat)](https://cocoapods.org/pods/ResumableCombine)


Swift Combine lacks of support for proper backpressure handling. Many of its operators just send `request(.unlimited)` for the first demand request. It renders the pull mechanism utterly uselesss. This project aims to fix this problem.

## Example

Sink that will request one item at a time
```swift
let subscription = [1,2,3,4,5].publisher
    .rm.sink(
        receiveCompletion: { completion in
            print("Completion: \(completion)")
        },
        receiveValue: { value -> Bool in
             print("Receive value: \(value)")
             return true
        }
    )
```

Sink that will request one item then stop.
We can use subscription.resume() to request for additional items
```swift
let subscription = (0 ... Int.max).publisher
    .rm.sink(
        receiveCompletion: { completion in
            print("Completion: \(completion)")
        },
        receiveValue: { value -> Bool in
             print("Receive value: \(value)")
             return false
        }
    )

// Receive value: 1
subscription.resume()

// Receive value: 2
subscription.resume()

// Receive value: 3
subscription.resume()
```

Assign that will request one item at a time
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
```

Assign that will request one item then stop
We can use subscription.resume() to request for additional items
```swift
let subscription = (0 ... Int.max).publisher.rm.assign(to: \.value, on: object, mode: .singleDemand)

// object.value == 1
subscription.resume()

// object.value == 2
subscription.resume()
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
