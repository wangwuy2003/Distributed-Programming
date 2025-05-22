import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var A = [Int]()
let semaphore = DispatchSemaphore(value: 1)
let maxIterations = 20

// Hàm kiểm tra số nguyên tố
func isPrime(_ number: Int) -> Bool {
    if number <= 1 { return false }
    if number <= 3 { return true }
    var i = 2
    while i * i <= number {
        if number % i == 0 { return false }
        i += 1
    }
    return true
}

func randomDelay() -> TimeInterval {
    return TimeInterval.random(in: 0.1...1.0)
}

let k = 2
let h = 2
let dispatchGroup = DispatchGroup()

for i in 0..<k {
    dispatchGroup.enter()
    DispatchQueue.global().async {
        var iteration = 0
        while iteration < maxIterations {
            Thread.sleep(forTimeInterval: randomDelay())
            
            let value = Int.random(in: 1...1000)
            
            semaphore.wait()
            DispatchQueue.main.async {
                A.append(value)
                let time = Date().formatted(date: .omitted, time: .complete)
                print("P\(i+1): \(value) - \(time)")
                semaphore.signal()
            }
            
            iteration += 1
        }
        dispatchGroup.leave()
    }
}

for i in 0..<h {
    dispatchGroup.enter()
    DispatchQueue.global().async {
        var iteration = 0
        while iteration < maxIterations {
            Thread.sleep(forTimeInterval: randomDelay())
            
            semaphore.wait()
            DispatchQueue.main.async {
                if let value = A.first {
                    A.removeFirst()
                    let isPrimeResult = isPrime(value)
                    let result = isPrimeResult ? "Là số nguyên tố" : "Không phải số nguyên tố"
                    let time = Date().formatted(date: .omitted, time: .complete)
                    print("C\(i+1): \(value) - \(result) - \(time)")
                }
                semaphore.signal()
            }
            
            iteration += 1
        }
        dispatchGroup.leave()
    }
}

dispatchGroup.notify(queue: .main) {
    print("Tất cả luồng đã hoàn thành.")
    PlaygroundPage.current.finishExecution()
}
