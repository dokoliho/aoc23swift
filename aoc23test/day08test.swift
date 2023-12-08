//
//  day08test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 08.12.23.
//

import XCTest

final class day08test: XCTestCase {

    let currentPuzzle = [
        "32T3K 765",
        "T55J5 684",
        "KK677 28",
        "KTJJT 220",
        "QQQJA 483",
        "",
    ]

    
    func testSolvePart1() throws {
        let solution = Day08Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day08Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("", result)
    }
}
