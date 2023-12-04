//
//  day04.swift
//  aoc23
//
//  Created by Oliver Hofmann on 04.12.23.
//

import Foundation

public struct Day04Solution : DailySolution {


    func solvePart1(puzzle: [String]) -> String {
        let cards = puzzle.compactMap { try? Card(line: $0) }
        let sum = cards.map {$0.points}.reduce(0, +)
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let cards = puzzle.compactMap { try? Card(line: $0) }
        var pile = Pile(cards: cards)
        pile.expand()
        return String(pile.count)
    }
}

enum ParsingError: Error {
    case obvious
}


struct Card {
    
    let id: Int
    let winningNumbers: [Int]
    let ownedNumbers: [Int]
    
    init(line: String) throws {
        let search = /^Card.+(?<id>\d+):(?<win>.*)\|(?<own>.*)$/
        if let result = try? search.wholeMatch(in: line) {
            id = Int(result.id) ?? -1
            winningNumbers = result.win.components(separatedBy: " ").compactMap { Int($0) }
            ownedNumbers = result.own.components(separatedBy: " ").compactMap { Int($0) }
        }
        else {
            throw ParsingError.obvious
        }
    }
    
    var countWinningNumbers: Int {
        let winSet: Set<Int> = Set(winningNumbers)
        let hits = ownedNumbers.filter { winSet.contains($0) }
        return hits.count
    }
    
    var points: Int {
        let count = countWinningNumbers
        return count == 0 ? 0 : Int(pow(2.0, Double(count - 1)))
    }
}


struct Pile {
    
    var pile: [(card: Card, count: Int)]
    
    init(cards: [Card]) {
        pile = cards.map { ($0, 1) }
    }
    
    mutating func expand() {
        for idx in 0...pile.count-1 {
            let wins = pile[idx].card.countWinningNumbers
            var affected = idx+1
            while (affected <= idx+wins && affected < pile.count) {
                pile[affected].count += pile[idx].count
                affected += 1
            }
        }
    }
    
    var count: Int {
        return pile.map {$0.count}.reduce(0, +)
    }
}

