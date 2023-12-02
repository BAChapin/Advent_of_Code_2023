import Foundation

public struct Day1: SolutionEngine {

    public var input: String = ""
    public var lines: [String] = []
    let numbers: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let numberStrings: [String] = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    
    public init() {
        do {
            try getInput("day1")
            processInput()
        } catch {
            self.input = ""
        }
    }
    
    public func partOne() {
        print(#function)
        var runningTotal = 0
        for line in lines {
            let lineNumbers = line.filter { c in
                numbers.contains { c == $0 }
            }
            
            if let firstNum = lineNumbers.first, let lastNum = lineNumbers.last, let value = Int("\(firstNum)\(lastNum)") {
                runningTotal += value
            }
        }
        
        print("The calibration value is", runningTotal)
    }
    
    public func partTwo() {
        print(#function)
        var runningTotal = 0
        for line in lines {
            let nums = processInputLine(line)
            if let firstNum = nums.first, let lastNum = nums.last, let value = Int("\(firstNum)\(lastNum)") {
                runningTotal += value
            }
        }
        print("The calibration value is", runningTotal)
    }
    
    private func processInputLine(_ line: String) -> String {
        var runningNumbers = ""
        for (index, char) in line.enumerated() {
            if let foundIndex = numbers.firstIndex(of: char) {
                runningNumbers += String(foundIndex)
            }
            
            let possibleOptions = numberStrings.filter({ $0.starts(with: [char]) { $0 == $1 } })
            if possibleOptions.count > 0 {
                let substring = line.dropFirst(index)
                for option in possibleOptions {
                    if substring.starts(with: option, by: { $0 == $1 }) {
                        if let foundIndex = numberStrings.firstIndex(of: option) {
                            runningNumbers += String(foundIndex)
                        }
                    }
                }
            }
        }
        return runningNumbers
    }

}
