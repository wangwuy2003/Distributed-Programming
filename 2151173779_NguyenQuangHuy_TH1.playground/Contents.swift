import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var N = 200
var k = 4

var A = [Int]()

for _ in 0..<N {
    A.append(Int.random(in: 1...1000))
}

print("Mang A: \(A)")

// Kiem tra so nguyen to
func isPrime(_ number: Int) -> (isPrime: Bool, executionTime: TimeInterval) {
    let startTime = Date()
    if number <= 1 { return (false, Date().timeIntervalSince(startTime)) }
    if number <= 3 { return (true, Date().timeIntervalSince(startTime)) }
    var i = 2
    while i * i <= number {
        if number % i == 0 { return (false, Date().timeIntervalSince(startTime)) }
        i += 1
    }
    return (true, Date().timeIntervalSince(startTime))
}

let dispatchGroup = DispatchGroup()
var results = [[Int]]()

let chunkSize = N / k
for i in 0..<k {
    let start = i * chunkSize
    let end = (i == k - 1) ? N : start + chunkSize
    let subArray = Array(A[start..<end])
    
    DispatchQueue.global().async(group: dispatchGroup) {
        var localResults = [Int]()
        for num in subArray {
            let (isPrimeResult, executionTime) = isPrime(num)
            if isPrimeResult {
                localResults.append(num)
                print("T\(i+1): \(num) : Thời gian thực thi: \(String(format: "%.6f", executionTime)) giây")
            }
        }
        DispatchQueue.main.async {
            results.append(localResults)
        }
    }
}

dispatchGroup.notify(queue: .main) {
    var allPrimes = [Int]()
    for result in results {
        allPrimes.append(contentsOf: result)
    }
    allPrimes.sort()
    print("Tất cả số nguyên tố tìm được: \(allPrimes)")
    PlaygroundPage.current.finishExecution()
}
