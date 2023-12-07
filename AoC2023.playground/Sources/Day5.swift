import Foundation

public struct Day5: SolutionEngine {
    
    public var input: String = ""
    public var lines: [String] = []
    
    public init() {
        do {
            try getInput("day5")
            processInput()
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        let almanac = Almanac(input: input)
        let targets = almanac.runIndividualSeeds()
        let destinationNumbers = targets.map { $0.location }
        guard let answer = destinationNumbers.sorted().first else { return }
        print("The lowest location number:", answer)
    }
    
    public func partTwo() {
        let almanac = Almanac(input: input)
        let targets = almanac.runSeedRanges()
        print("The lowest location in ranges:")
    }
}

extension Day5 {
    struct Almanac {
        typealias SeedToSoil = (seed: Int, location: Int)
        typealias SeedRanges = (start: Int, step: Int)
        var seeds: [Int]
        var seedRanges: [SeedRanges]
        var instructions: [InstructionSet]
        
        init(input: String) {
            let splitInput = input.split(separator: "|\n")
            let splitInstructions = splitInput.dropFirst()
            instructions = splitInstructions.map { InstructionSet(String($0)) }
            let seedSplit = splitInput[0].split(separator: ": ")
            let rawSeeds = seedSplit[1].replacingOccurrences(of: "\n", with: "").split(separator: " ")
            seeds = rawSeeds.map { Int($0) ?? 0 }
            let seedRangesRaw = rawSeeds.enumerated().compactMap { (index, data) in
                if index.isMultiple(of: 2) || index == 0 {
                    return (data, rawSeeds[index + 1])
                }
                
                return nil
            }
            seedRanges = seedRangesRaw.map { (Int($0) ?? 0, Int($1) ?? 0) }
        }
        
        func runIndividualSeeds() -> [SeedToSoil] {
            return processSeeds(seeds)
        }
        
        func runSeedRanges() -> [SeedToSoil] {
            let seeds = generateSeedsFromRanges()
            return processSeed(seedRanges)
        }
        
        private func processSeeds(_ seeds: [Int]) -> [SeedToSoil] {
            var processedValues: [SeedToSoil] = []
            for seed in seeds {
                var currentTarget = seed
                for instruction in instructions {
                    currentTarget = instruction.getDestination(currentTarget)
                }
                
                processedValues.append((seed, currentTarget))
            }
            
            return processedValues
        }
        
        private func processSeed(_ ranges: [SeedRanges]) -> [SeedToSoil] {
            let _ = instructions[0].lowestDesignationFor(range: 0..<1)
//            for instruction in instructions {
//                instruction.lowestDesignationFor(range: 0..<1)
//            }
            return [(1, 1)]
        }
        
        private func generateSeedsFromRanges() -> [Int] {
            var runningSeeds: [Int] = []
            
            for seedRange in seedRanges {
                let seeds = Array(seedRange.start..<(seedRange.start + seedRange.step))
                runningSeeds.append(contentsOf: seeds)
            }
            
            return runningSeeds
        }
    }
}

extension Day5.Almanac {
    struct InstructionSet {
        
        var direction: String
        var designations: [Designation] = []
        
        init(_ input: String) {
            let inputSplit = input.split(separator: ":\n")
            direction = String(inputSplit[0])
            let instructionSplit = inputSplit[1].split(separator: "\n")
            for instruction in instructionSplit {
                let processInfo = instruction.split(separator: " ")
                let from = Int(processInfo[0]) ?? 0
                let to = Int(processInfo[1]) ?? 0
                let steps = Int(processInfo[2]) ?? 0
                
                designations.append(.init(destination: from, source: to, steps: steps))
            }
        }
        
        func getDestination(_ start: Int) -> Int {
            for designation in designations {
                if let destination = designation[start] {
                    return destination
                }
            }
            
            return start
        }
        
        func lowestDesignationFor(range: Range<Int>) -> Designation {
            let organizedDesignations = designations.sorted(by: { $0.destination < $1.destination })
            print(organizedDesignations)
            return organizedDesignations[0]
        }
        
        struct Designation {
            let destination: Int
            let source: Int
            let steps: Int
            
            var sourceRange: Range<Int> {
                return source..<(source + steps)
            }
            
            subscript(_ input: Int) -> Int? {
                if sourceRange.contains(input) {
                    let difference = input - source
                    return destination + difference
                } else {
                    return nil
                }
            }
        }
    }
}
