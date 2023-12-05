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
        let answer = game.processAllCards()
        print("Your total number of scratchcards:", answer)
    }
}

extension Day4 {
    struct ScratchCardGame {
        let cards: [Card]
        
        init(input: [String]) {
            cards = input.map { Card(input: $0) }
        }
        
        func sumOfCardPoints() -> Int {
            let cardScores = cards.map { $0.cardScore() }
            return cardScores.reduce(0, { $0 + $1 })
        }
        
        func processAllCards() -> Int {
            var processedCards = 0
            
            for (index, card) in cards.enumerated() {
                let cardsToCopy = card.numberOfWinningScratches()
                
                if cardsToCopy > 0 {
                    let copiedCards = processCard(indexOfCardsToCopy: (index + 1)...(index + cardsToCopy))
                    processedCards += copiedCards
                }
                
                processedCards += 1
            }
            
            return processedCards
        }
        
        private func processCard(indexOfCardsToCopy range: ClosedRange<Int>) -> Int {
            var runningTotal = 0
            
            for index in range {
                let cardsToCopy = cards[index].numberOfWinningScratches()
                
                if cardsToCopy > 0 {
                    runningTotal += processCard(indexOfCardsToCopy: (index + 1)...(index + cardsToCopy))
                }
                runningTotal += 1
            }
            
            return runningTotal
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
    }
}
