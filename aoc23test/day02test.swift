//
//  day02test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 02.12.23.
//

import XCTest
@testable import aoc23

final class day02: XCTestCase {
    
    let currentPuzzle = [
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
        ]

    func testSolvePart1() throws {
        let solution = Day02Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("8", result)
    }
    
    
    func testSolvePart2() throws {
        let solution = Day02Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("2286", result)
    }


}
