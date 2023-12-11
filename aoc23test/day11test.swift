//
//  day11test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 11.12.23.
//

import XCTest

final class day11test: XCTestCase {

    let testPuzzle = [
        "...#......",
        ".......#..",
        "#.........",
        "..........",
        "......#...",
        ".#........",
        ".........#",
        "..........",
        ".......#..",
        "#...#.....",
        "",
    ]
    
    func testParseGalaxies() throws {
        let solution = Day11Solution()
        let galaxies = solution.parseGalaxies(lines: testPuzzle)
        XCTAssertEqual(9, galaxies.count)
        XCTAssertEqual(11, galaxies.last!.0)
        XCTAssertEqual(5, galaxies.last!.1)
    }
    
    func testFactor() throws {
        let solution = Day11Solution()
        let galaxies10 = solution.parseGalaxies(lines: testPuzzle, factor: 10)
        let galaxies100 = solution.parseGalaxies(lines: testPuzzle, factor: 100)

        XCTAssertEqual(1030, solution.sumDistances(galaxies: galaxies10))
        XCTAssertEqual(8410, solution.sumDistances(galaxies: galaxies100))
    }

    
    
    func testSolvePart1() throws {
        let solution = Day11Solution()
        let result = solution.solvePart1(puzzle: testPuzzle)
        XCTAssertEqual("374", result)
    }
    
    func testSolvePart2() throws {
        let solution = Day11Solution()
        let result = solution.solvePart2(puzzle: testPuzzle)
        XCTAssertEqual("", result)
    }

}
