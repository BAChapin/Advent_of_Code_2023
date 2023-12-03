import Foundation

public struct Day3: SolutionEngine {
    
    public var input: String = ""
    public var lines: [String] = []
    
    public init() {
        do {
            try getInput("day3")
            processInput()
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        let engineSchematics = EngineSchematic(lines)
        let partNumbers = engineSchematics.partNumbers()
        let answer = partNumbers.reduce(0, { $0 + $1 })
        print("The sum of all the part numbers:", answer)
    }
    
    public func partTwo() {
        let engineSchematics = EngineSchematic(lines)
        let ratios = engineSchematics.gearRatios()
        let answer = ratios.reduce(0, { $0 + $1 })
        print("The sum of all gear ratios:", answer)
    }
    
    func processInputLines() -> [[Character]] {
        return lines.map { $0.map { $0 } }
    }
}

extension Day3 {
    struct EngineSchematic {
        
        typealias NumberPosition = (row: Int, range: ClosedRange<Int>)
        
        struct MAPoint {
            let row: Int
            let column: Int
        }
        
        let data: [[Character]]
        
        var rowCount: Int {
            return data.count
        }
        var columnCount: Int {
            return data.first?.count ?? 0
        }
        
        init(_ lines: [String]) {
            data = lines.map { $0.map { $0 } }
        }
        
        private func accessItem(at pos: MAPoint) -> Character? {
            if pos.row < 0 || pos.column < 0 {
                return nil
            }
            
            if pos.row >= rowCount || pos.column >= columnCount {
                return nil
            }
            
            return data[pos.row][pos.column]
        }
        
        private func surroundingIndicies(of number: NumberPosition) -> [MAPoint] {
            var runningIndicies: [MAPoint] = []
            
            for column in number.range {
                if column == number.range.lowerBound {
                    runningIndicies.append(.init(row: number.row - 1, column: column - 1))
                    runningIndicies.append(.init(row: number.row, column: column - 1))
                    runningIndicies.append(.init(row: number.row + 1, column: column - 1))
                }
                
                if column == number.range.upperBound {
                    runningIndicies.append(.init(row: number.row - 1, column: column + 1))
                    runningIndicies.append(.init(row: number.row, column: column + 1))
                    runningIndicies.append(.init(row: number.row + 1, column: column + 1))
                }
                
                runningIndicies.append(.init(row: number.row - 1, column: column))
                runningIndicies.append(.init(row: number.row + 1, column: column))
            }
            
            return runningIndicies
        }
        
        private func surroundingIndicies(of point: MAPoint) -> [MAPoint] {
            return [
                .init(row: point.row - 1, column: point.column - 1),
                .init(row: point.row - 1, column: point.column),
                .init(row: point.row - 1, column: point.column + 1),
                .init(row: point.row, column: point.column - 1),
                .init(row: point.row, column: point.column + 1),
                .init(row: point.row + 1, column: point.column - 1),
                .init(row: point.row + 1, column: point.column),
                .init(row: point.row + 1, column: point.column + 1)
            ]
        }
        
        func partNumbers() -> [Int] {
            let numbers = numberPositions()
            let filteredNumbers = numbers.filter { isPartNumber($0) }
            let realNumbers = filteredNumbers.compactMap { numberAt($0) }
            return realNumbers
        }
        
        func gearRatios() -> [Int] {
            let numbers = numberPositions()
            let gearPositions = gearPositions()
            let validGears = findGearRatios(gearPositions: gearPositions, numberPositions: numbers)
            let gearRatios = validGears.compactMap { calculateGearRatio($0) }
            return gearRatios
        }
        
        func numberPositions() -> [NumberPosition] {
            var runningPositions: [(Int, ClosedRange<Int>)] = []
            for row in 0..<rowCount {
                var numberStart = 0
                for column in 0..<columnCount {
                    let currentElement = data[row][column]
                    let previousElement = accessItem(at: .init(row: row, column: column - 1))
                    let nextElement = accessItem(at: .init(row: row, column: column + 1))
                    
                    if currentElement.isNumber {
                        if let previousElement, !previousElement.isNumber {
                            numberStart = column
                        }
                        
                        if let nextElement, !nextElement.isNumber {
                            runningPositions.append((row, numberStart...column))
                            continue
                        }
                        
                        if nextElement == nil {
                            runningPositions.append((row, numberStart...column))
                            continue
                        }
                    }
                }
            }
            
            return runningPositions
        }
        
        func gearPositions() -> [MAPoint] {
            var runningPositions: [MAPoint] = []
            
            for row in 0..<rowCount {
                for column in 0..<columnCount {
                    let currentElement = data[row][column]
                    if currentElement == "*" {
                        runningPositions.append(.init(row: row, column: column))
                    }
                }
            }
            
            return runningPositions
        }
        
        func findGearRatios(gearPositions gears: [MAPoint], numberPositions numbers: [NumberPosition]) -> [(NumberPosition, NumberPosition)] {
            var runningValues: [(NumberPosition, NumberPosition)] = []
            
            for gear in gears {
                let foundNumbers = numbers.filter {
                    let check1 = ($0.row <= gear.row + 1) && ($0.row >= gear.row - 1)
                    let check2 = (gear.column >= $0.range.lowerBound - 1) && (gear.column <= $0.range.upperBound + 1)
                    if check1 {
                        if check2 {
                            return true
                        }
                    }
                    return false
                }
                
                if foundNumbers.count == 2 {
                    runningValues.append((foundNumbers[0], foundNumbers[1]))
                }
            }
            
            return runningValues
        }
        
        func isPartNumber(_ number: NumberPosition) -> Bool {
            let checkValues = surroundingIndicies(of: number)
            
            for index in checkValues {
                if let value = accessItem(at: index) {
                    if !value.isNumber && value != "." {
                        return true
                    }
                }
            }
            
            return false
        }
        
        func numberAt(_ position: NumberPosition) -> Int? {
            var runningValue = ""
            
            for column in position.range {
                runningValue += String(data[position.row][column])
            }
            
            return Int(runningValue)
        }
        
        func calculateGearRatio(_ numbers: (NumberPosition, NumberPosition)) -> Int? {
            guard let firstNumber = numberAt(numbers.0) else { return nil }
            guard let secondNumber = numberAt(numbers.1) else { return nil }
            
            return firstNumber * secondNumber
        }
    }
}
