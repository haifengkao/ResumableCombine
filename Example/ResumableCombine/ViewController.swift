//
//  ViewController.swift
//  ResumableCombine
//
//  Created by Hai Feng Kao on 09/11/2020.
//  Copyright (c) 2020 Hai Feng Kao. All rights reserved.
//

import UIKit

import Combine
import ResumableCombine

class ViewController: UIViewController {
    var subscription: AnyResumable?
    var subscription2: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let subject = CurrentValueSubject<Int, Never>(1)

        subscription2 = subject.delay(for: 0.1, scheduler: DispatchQueue.global()).sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { value in
            print(value)

            // return true
        })

        subject.send(2)

        subject.send(3)

        /*        subscription = (1 ... 100).publisher.print("flatMap").flatMap(maxPublishers: .max(1)) { _ in
                 return Empty<Int, Never>()
         }
         .rm.sink { (completion) in
         */
        
        // subscription?.resume()
        /*
         subscription = (1 ... 100).publisher.rm.assert(minInterval: .milliseconds(10))
             .flatMap(maxPublishers: .max(1)) { _ in
                 return [1].publisher
             }
             .rm.sink { (completion) in
             print(completion)
         } receiveValue: { (value) in
             print("Receive value: ", value)

             return false
         }
         */

        // subscription?.resume()

        // subscription?.resume()

        /* subscription?.resume() */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
