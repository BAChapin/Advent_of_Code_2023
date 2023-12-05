import Foundation

public struct Day4: SolutionEngine {
    
    public var input: String = ""
    public var lines: [String] = []
    
    public init() {
        do {
            try getInput("day4")
            processInput()
        } catch {
            input = ""
        }
    }
    
    public func partOne() {
        let game = ScratchCardGame(input: lines)
        let answer = game.sumOfCardPoints()
        print("Your cards are worth: \(answer) points" )
    }
    
    public func partTwo() {
        let game = ScratchCardGame(input: lines)
        let answer = game.processCards()
        print("Your total number of scratchcards:", answer)
    }
}

extension Day4 {
    struct ScratchCardGame {
        let cards: [Card]
        var cardCopies: [ClosedRange<Int>?] = []
        
        init(input: [String]) {
            cards = input.map { Card(input: $0) }
        }
        
        func sumOfCardPoints() -> Int {
            let cardScores = cards.map { $0.cardScore() }
            return cardScores.reduce(0, { $0 + $1 })
        }
        
        mutating func processCards() -> Int {
            cardCopies = cards.enumerated().map { $1.copiedIndicies($0) }
            return cardCopies.map { processIndicies($0) }.reduce(0, { $0 + $1 })
        }
        
        private func processIndicies(_ indicies: ClosedRange<Int>?) -> Int {
            if let indicies {
                let copies = indicies.map { cardCopies[$0] }
                return copies.map { processIndicies($0) }.reduce(0, { $0 + $1 })
            } else {
                return 1
            }
        }
        
        func processCards(_ indicies: ClosedRange<Int>? = nil) -> Int {
            if let indicies {
                let tempCards = indicies.map { ($0, cards[$0]) }.compactMap { $1.copiedIndicies($0) }
                return tempCards.map { processCards($0) }.reduce(0, { $0 + $1 }) + indicies.count
            } else {
                let cardCopies = cards.enumerated().compactMap { $1.copiedIndicies($0) }
                return cardCopies.map { processCards($0) }.reduce(0, { $0 + $1 }) + cards.count
            }
        }
        
        
    }
}

extension Day4.ScratchCardGame {
    struct Card {
        var number: Int
        var winningNumbers: [Int]
        var scratchOffNumbers: [Int]
        
        init(input: String) {
            let dataSplit = input.split(separator: ": ")
            let cardSplit = dataSplit[0].split(separator: " ")
            let numbersSplit = dataSplit[1].split(separator: " | ")
            let winningNumberData = numbersSplit[0].split(separator: " ")
            let scratchedNumbers = numbersSplit[1].split(separator: " ")
            
            number = Int(cardSplit[1]) ?? 0
            winningNumbers = winningNumberData.compactMap { Int($0) }
            scratchOffNumbers = scratchedNumbers.compactMap { Int($0) }
        }
        
        func winningScratchedNumbers() -> [Int] {
            return scratchOffNumbers.filter { num in
                winningNumbers.contains(where: { num == $0 })
            }
        }
        
        func numberOfWinningScratches() -> Int {
            return winningScratchedNumbers().count
        }
        
        func cardScore() -> Int {
            let matchingNumbers = winningScratchedNumbers()
            
            return matchingNumbers.reduce(0) { partialResult, _ in
                if partialResult == 0 {
                    return 1
                } else {
                    return 2 * partialResult
                }
            }
        }
        
        func copiedIndicies(_ index: Int) -> ClosedRange<Int>? {
            let winningScratches = numberOfWinningScratches()
            return winningScratches != 0 ?  (index + 1)...(index + winningScratches) : nil
        }
    }
}
