import Foundation

public struct Day6: SolutionEngine {
    
    public var input: String = ""
    public var lines: [String] = []
    
    public init() {
        do {
            try getInput("day6")
            processInput()
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        let times = lines[0].split(separator: " ").dropFirst()
        let distances = lines[1].split(separator: " ").dropFirst()
        let races = zip(times, distances).map { Race(timeInput: $0, recordInput: $1) }
        let winningTimes = races.map { $0.amountOfWinningTimes() }
        let answer = winningTimes.reduce(1, { $0 * $1 })
        print("Mutiplied ways of winning:", answer)
    }
    
    public func partTwo() {
        let times = lines[0].replacingOccurrences(of: " ", with: "").split(separator: ":").dropFirst()
        let distances = lines[1].replacingOccurrences(of: " ", with: "").split(separator: ":").dropFirst()
        let races = zip(times, distances).map { Race(timeInput: $0, recordInput: $1) }
        let answer = races[0].amountOfWinningTimes()
        print("Number of ways to win:", answer)
    }
}

extension Day6 {
    struct Race {
        let time: Int
        let recordDistance: Int
        
        init(timeInput: any StringProtocol, recordInput: any StringProtocol) {
            time = Int(timeInput) ?? 0
            recordDistance = Int(recordInput) ?? 0
        }
        
        func winningTimes() -> [Int] {
            var runningTimes: [Int] = []
            for milliseconds in 1..<time {
                let speed = milliseconds
                let remainingTime = time - milliseconds
                let distance = speed * remainingTime
                if distance > recordDistance {
                    runningTimes.append(distance)
                }
            }
            return runningTimes
        }
        
        func amountOfWinningTimes() -> Int {
            var runningTimes: Int = 0
            for milliseconds in 1..<time {
                let speed = milliseconds
                let remainingTime = time - milliseconds
                let distance = speed * remainingTime
                if distance > recordDistance {
                    runningTimes += 1
                }
            }
            return runningTimes
        }
    }
}
