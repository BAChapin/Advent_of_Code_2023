import Foundation

public struct Day2: SolutionEngine {
    
    public var input: String = ""
    public var lines: [String] = []
    
    let bagLimit: (red: Int, green: Int, blue: Int) = (red: 12, green: 13, blue: 14)
    var games: [Game] {
        return lines.map { Game(input: $0) }
    }
    
    public init() {
        do {
            try getInput("day2")
            processInput()
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        let possibleGames = games.filter { $0.isPossible(bagLimit) }
        let answer = possibleGames.reduce(0, { $0 + $1.id })
        print("The sum of the value game IDs:", answer)
    }
    
    public func partTwo() {
        let gamePowers = games.map { $0.gamePower() }
        let answer = gamePowers.reduce(0, { $0 + $1 })
        print("The sum of the games powers:", answer)
    }
}

extension Day2 {
    struct Game {
        var id: Int
        var red: [Int] = []
        var green: [Int] = []
        var blue: [Int] = []
        
        init(input: String) {
            let dataSplit = input.split(separator: ": ")
            let gamesSplit = dataSplit[1].split(separator: "; ")
            let gameData = gamesSplit.flatMap { $0.split(separator: ", ") }
            let id = dataSplit[0].dropFirst(5)
            self.id = Int(id) ?? 0
            gameData.forEach { value in
                let splitValue = value.split(separator: " ")
                if let value = Int(splitValue[0]) {
                    switch splitValue[1] {
                    case "red": self.red.append(value)
                    case "green": self.green.append(value)
                    case "blue": self.blue.append(value)
                    default: break
                    }
                }
            }
        }
        
        func isPossible(_ limits: (red: Int, green: Int, blue: Int)) -> Bool {
            let redFiltered = red.filter { $0 > limits.red }
            let greenFiltered = green.filter { $0 > limits.green }
            let blueFiltered = blue.filter { $0 > limits.blue }
            
            return redFiltered.count == 0 && greenFiltered.count == 0 && blueFiltered.count == 0
        }
        
        func gamePower() -> Int {
            let mins = diceMinimums()
            return mins.red * mins.green * mins.blue
        }
        
        func diceMinimums() -> (red: Int, green: Int, blue: Int) {
            let red = red.sorted()
            let green = green.sorted()
            let blue = blue.sorted()
            
            return (red.last ?? 0, green.last ?? 0, blue.last ?? 0)
        }
    }
}
