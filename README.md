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

We can use subscription.resume() to request for additional items.
```swift
let subscription = (1 ... Int.max).publisher
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

We can use subscription.resume() to request for additional items.
```swift
let subscription = (1 ... Int.max).publisher.rm.assign(to: \.value, on: object, mode: .singleDemand)

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
