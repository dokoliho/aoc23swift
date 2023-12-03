//
//  day01test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 01.12.23.
//

import XCTest
@testable import aoc23

final class day01test: XCTestCase {

    func testSolvePart1() throws {
        let currentPuzzle = ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]
        let solution = Day01Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("142", result)
    }
    
    func testSolvePart2() throws {
        let currentPuzzle = ["two1nine", "eightwothree", "abcone2threexyz", "xtwone3four", "4nineeightseven2", "zoneight234", "7pqrstsixteen"]
        let solution = Day01Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("281", result)
    }


}
