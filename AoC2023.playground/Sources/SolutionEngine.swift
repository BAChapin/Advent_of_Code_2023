import Foundation

public enum FileError: Error {
    case unableToFindFile
}

public protocol SolutionEngine {
    var input: String { get set }
    var lines: [String] { get set }
    mutating func getInput(_ fileName: String) throws
    mutating func processInput()
    func partOne()
    func partTwo()
}

public extension SolutionEngine {
    mutating func getInput(_ fileName: String) throws {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            throw FileError.unableToFindFile
        }
        
        do {
            let content = try String(String(contentsOfFile: path, encoding: .utf8))
            input = content
        } catch let error {
            throw error
        }
    }
    
    mutating func processInput() {
        let lines = input.split(separator: "\n")
        self.lines = lines.map { String($0) }
    }
}
