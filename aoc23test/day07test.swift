//
//  day07test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 07.12.23.
//

import XCTest

final class day07test: XCTestCase {
    
    
    let currentPuzzle = [
        "32T3K 765",
        "T55J5 684",
        "KK677 28",
        "KTJJT 220",
        "QQQJA 483",
        "",
    ]

    
    func testParse() throws {
        let solution = Day07Solution()
        let hands = solution.parse(puzzle: currentPuzzle)
        XCTAssertEqual(5, hands.count)
        XCTAssertEqual(28, hands[2].bid)
        XCTAssertEqual("QQQJA", hands[4].cards)
    }
    
    
    func testRanks() throws {
        let solution = Day07Solution()
        let hands = solution.parse(puzzle: currentPuzzle)
        XCTAssertEqual(CamelRank.OnePair, hands[0].rank)
        XCTAssertEqual(CamelRank.Three, hands[1].rank)
        XCTAssertEqual(CamelRank.TwoPairs, hands[2].rank)
        XCTAssertEqual(CamelRank.TwoPairs, hands[3].rank)
        XCTAssertEqual(CamelRank.Three, hands[4].rank)
    }

    
    
    func testSolvePart1() throws {
        let solution = Day07Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("6440", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day07Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("5905", result)
    }
}
