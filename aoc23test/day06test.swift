//
//  day06test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 06.12.23.
//

import XCTest


final class day06test: XCTestCase {

    let currentPuzzle = [
        "Time:      7  15   30",
        "Distance:  9  40  200",
        "",
    ]
    
    
    func testSqrt() throws {
        let result1 = sqrtUInt64(16)
        XCTAssertEqual(4, result1)
        let result2 = sqrtUInt64(17)
        XCTAssertEqual(4, result2)

        
    }
        
    func testSolvePart1() throws {
        let solution = Day06Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("288", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day06Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("71503", result)
    }

}
