import Foundation

/**
 A helper function for measuring the time it takes to run a particular function.
 It will also allow you to run the given function a number of times and averages the time it takes for them to run
 */
public func speedCheck(runCount: Int = 1, _ fn: () -> Void) {
    let start = Date()
    for _ in 0..<runCount {
        fn()
    }
    let end = Date()
    print(String(repeating: "*", count: 80))
    print("Function Runs:", runCount)
    print("Function Started:", start)
    print("Function Ended:", end)
    let totalElapsedTime = end.timeIntervalSince1970 - start.timeIntervalSince1970
    print("Total Elapsed Time:", "\(calculateTimeOutput(elapsedTime: totalElapsedTime))")
    print("Average Execution Time:", "\(calculateTimeOutput(elapsedTime: totalElapsedTime / Double(runCount)))")
    print(String(repeating: "*", count: 80))
}

func calculateTimeOutput(elapsedTime: TimeInterval) -> String {
    if elapsedTime >= 60 {
        let minutes = floor(elapsedTime / 60)
        let seconds = round(elapsedTime.truncatingRemainder(dividingBy: 60))
        return "\(minutes) m \(seconds) s"
    } else if elapsedTime >= 1 {
        let seconds = floor(elapsedTime)
        let milliseconds = round((elapsedTime * 100000)).truncatingRemainder(dividingBy: 100000) / 100
        return "\(seconds) s \(milliseconds) ms"
    } else {
        let milliseconds = round(elapsedTime * 100000) / 100
        return "\(milliseconds) ms"
    }
}
