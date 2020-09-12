//
//  ViewController.swift
//  ResumableCombine
//
//  Created by Hai\ Feng\ Kao on 09/11/2020.
//  Copyright (c) 2020 Hai\ Feng\ Kao. All rights reserved.
//

import UIKit

import Combine
import ResumableCombine

class ViewController: UIViewController {
    var subscription: AnyResumable?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        subscription = (1 ... 100).publisher.flatMap(maxPublishers: .max(1)) { value -> AnyPublisher<Int, Never> in
            print("Receive flatMap:", value)
            return AnyPublisher([10, 20].publisher)
        }.rm.sink { (completion) in
            print(completion)
        } receiveValue: { (value) -> Bool in
            print("Receive value: ", value)
            
            return false
        }
        
        
        //subscription?.resume()
        
        //subscription?.resume()
        
        /*subscription?.resume()*/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

