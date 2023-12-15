//
//  day15test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 15.12.23.
//

import XCTest

final class day15test: XCTestCase {

    let testPuzzle = [
        "O....#....",
        "O.OO#....#",
        ".....##...",
        "OO.#O....O",
        ".O.....O#.",
        "O.#..O.#.#",
        "..O..#O..O",
        ".......O..",
        "#....###..",
        "#OO..#....",
        "",
    ]
    
    let solution = Day15Solution()
    
    
    
    func testSolvePart1() throws {
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
    
    func testSolvePart2() throws {
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }
}
