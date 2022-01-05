// https://github.com/Quick/Quick

import Combine
import Foundation
import Nimble
import Quick
import ResumableCombine
class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("CurrentValueSubject") {
            context("with original sink") {
                it("will receive all value") {
                    let subject = CurrentValueSubject<Int, Never>(1)

                    var values: [Int] = []
                    let subscription = subject.delay(for: 0.01, scheduler: DispatchQueue.main).sink(receiveCompletion: { _ in
                    }, receiveValue: { value in

                        values.append(value)

                    })

                    subject.send(2)
                    subject.send(3)

                    expect(values).toEventually(equal([1, 2, 3]))
                }
            }

            context("with resumable sink") {
                it("will receive newest value only") {
                    let subject = CurrentValueSubject<Int, Never>(1)

                    var values: [Int] = []
                    let subscription = subject.delay(for: 0.01, scheduler: DispatchQueue.main).rm.sink(receiveCompletion: { _ in
                    }, receiveValue: { value in

                        values.append(value)
                        return true
                    })

                    subject.send(2)
                    subject.send(3)

                    expect(values).toEventually(equal([1, 3]))
                }
            }
        }
        /*
         describe("these will fail") {

             it("can do maths") {
                 expect(1) == 2
             }

             it("can read") {
                 expect("number") == "string"
             }

             it("will eventually fail") {
                 expect("time").toEventually( equal("done") )
             }

             context("these will pass") {

                 it("can do maths") {
                     expect(23) == 23
                 }

                 it("can read") {
                     expect("🐮") == "🐮"
                 }

                 it("will eventually pass") {
                     var time = "passing"

                     DispatchQueue.main.async {
                         time = "done"
                     }

                     waitUntil { done in
                         Thread.sleep(forTimeInterval: 0.5)
                         expect(time) == "done"

                         done()
                     }
                 }
             }
         }*/
    }
}
