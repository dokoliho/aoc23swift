//
//  day11test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 11.12.23.
//

import XCTest

final class day11test: XCTestCase {

    let testPuzzle = [
        "..F7.",
        ".FJ|.",
        "SJ.L7",
        "|F--J",
        "LJ...",
        "",
    ]
    
    
    func testSolvePart1() throws {
        let solution = Day11Solution()
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day11Solution()
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }

}
