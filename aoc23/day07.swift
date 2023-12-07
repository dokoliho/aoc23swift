//
//  day07.swift
//  aoc23
//
//  Created by Oliver Hofmann on 07.12.23.
//

import Foundation

public struct Day07Solution : DailySolution {

    func solvePart1(puzzle: [String]) -> String {
        let hands = parse(puzzle: puzzle).sorted()
        var sum = 0
        for (idx, hand) in hands.enumerated() {
            sum += (idx+1) * hand.bid
        }
        return String(sum)
    }
    
    func solvePart2(puzzle: [String]) -> String{
        let hands = parse(puzzle: puzzle).map {Hand2(cards: $0.cards, bid: $0.bid)} .sorted()
        var sum = 0
        for (idx, hand) in hands.enumerated() {
            sum += (idx+1) * hand.bid
        }
        return String(sum)
    }
    
    func parse(puzzle: [String]) -> [Hand] {
        var result = [Hand]()
        for line in puzzle {
            if !line.isEmpty {
                let parts = line.components(separatedBy: " ")
                result.append(Hand(cards: parts[0], bid: Int(parts[1]) ?? 0))
            }
        }
        return result
    }
    
}

enum Day07Error: Error {
    case runtimeError(String)
}

enum CamelCard: Int, Comparable {
    
    static func < (lhs: CamelCard, rhs: CamelCard) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case CC2=0, CC3, CC4, CC5, CC6, CC7, CC8, CC9, CCT, CCJ, CCQ, CCK, CCA
}

enum CamelRank: Int, Comparable {
    
    static func < (lhs: CamelRank, rhs: CamelRank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case High=0, OnePair, TwoPairs, Three, FullHouse, Four, Five
}

struct Hand: Comparable {

    static func compareCards(lhs: [CamelCard], rhs: [CamelCard]) -> Bool {
        for (l, r) in zip(lhs, rhs) {
            if l != r {
                return l < r
            }
        }
        return false
    }


    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.rank == rhs.rank {
            return compareCards(lhs: lhs.cc, rhs: rhs.cc)
        }
        return lhs.rank < rhs.rank
    }
    
    
    static func string2cc(_ cards: String) -> [CamelCard] {
        return Array(cards).compactMap { try? char2cc($0)}
    }
    


    
    let cards: String
    let bid: Int

    
    init(cards: String, bid: Int) {
         self.cards = cards
         self.bid = bid
     }
    
    var cc: [CamelCard] {
        return Hand.string2cc(cards)
    }
    
    
    
    var rank: CamelRank {
        let set = Set(cards)
        let sorted = cc.sorted()
        if set.count == 1 {
            return CamelRank.Five
        }
        if set.count == 2 {
            return sorted[1] == sorted[3] ? CamelRank.Four : CamelRank.FullHouse
        }
        if set.count == 3 {
            return sorted[0] == sorted[2] || sorted[2] == sorted[4] || (sorted[1] == sorted[2] && sorted[2] == sorted[3]) ? CamelRank.Three : CamelRank.TwoPairs
        }
        if set.count == 4 {
            return CamelRank.OnePair
        }
        return CamelRank.High
    }
    
    private static func char2cc(_ char: Character) throws -> CamelCard {
        switch (char) {
        case "2":
            return CamelCard.CC2
        case "3":
            return CamelCard.CC3
        case "4":
            return CamelCard.CC4
        case "5":
            return CamelCard.CC5
        case "6":
            return CamelCard.CC6
        case "7":
            return CamelCard.CC7
        case "8":
            return CamelCard.CC8
        case "9":
            return CamelCard.CC9
        case "T":
            return CamelCard.CCT
        case "J":
            return CamelCard.CCJ
        case "Q":
            return CamelCard.CCQ
        case "K":
            return CamelCard.CCK
        case "A":
            return CamelCard.CCA
        default:
            throw Day07Error.runtimeError("Illegal card \(char)")
        }
    }
}


struct Hand2: Comparable {
    
    
    static func < (lhs: Hand2, rhs: Hand2) -> Bool {
        if lhs.bestHand.rank == rhs.bestHand.rank {
            let ccl = Hand.string2cc(lhs.cards) // original cards
            let ccr = Hand.string2cc(rhs.cards) // original cards
            return compareCards(lhs: ccl, rhs: ccr)
        }
        return lhs.bestHand.rank < rhs.bestHand.rank
    }
    
    static func compareCards(lhs: [CamelCard], rhs: [CamelCard]) -> Bool {
        for (l, r) in zip(lhs, rhs) {
            let lr = l == CamelCard.CCJ ? -1 : l.rawValue  // J is worst
            let rr = r == CamelCard.CCJ ? -1 : r.rawValue  // J is worst
            if lr != rr {
                return lr < rr
            }
        }
        return false
    }
    
    let cards: String
    let bid: Int
    let bestHand: Hand

    
    init(cards: String, bid: Int) {
        self.cards = cards
        self.bid = bid
        var candidate = Hand(cards: cards, bid: bid)
        if cards.contains("J") {
            for char in "23456789TQKA" {
                let newCards = cards.replacingOccurrences(of: "J", with: String(char))
                let newHand = Hand(cards: newCards, bid: bid)
                if newHand > candidate {
                    candidate = newHand
                }
            }
        }
        bestHand = candidate
     }
}
