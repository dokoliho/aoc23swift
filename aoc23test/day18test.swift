//
//  day18test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 18.12.23.
//

import XCTest

final class day18test: XCTestCase {

    let testPuzzle = [
        "R 6 (#70c710)",
        "D 5 (#0dc571)",
        "L 2 (#5713f0)",
        "D 2 (#d2c081)",
        "R 2 (#59c680)",
        "D 2 (#411b91)",
        "L 5 (#8ceee2)",
        "U 2 (#caa173)",
        "L 1 (#1b58a2)",
        "U 2 (#caa171)",
        "R 2 (#7807d2)",
        "U 3 (#a77fa3)",
        "L 2 (#015232)",
        "U 2 (#7a21e3)",
        "",
    ]
    
    let solution = Day18Solution()
    

    func testShoelace() throws {
        let testpos = [Day18Solution.Position(row:6, col:1),
                       Day18Solution.Position(row:1, col:3),
                       Day18Solution.Position(row:2, col:7),
                       Day18Solution.Position(row:4, col:4),
                       Day18Solution.Position(row:5, col:8)]
        let result = Day18Solution.shoelace(testpos)
        XCTAssertEqual(33/2, result)
    }
    
    
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("62", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("952408144115", result)
    }
}
