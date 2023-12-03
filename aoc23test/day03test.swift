//
//  day03test.swift
//  aoc23test
//
//  Created by Oliver Hofmann on 03.12.23.
//

import XCTest

final class day03test: XCTestCase {

    let currentPuzzle = [
        "467..114..",
        "...*......",
        "..35..633.",
        "......#...",
        "617*......",
        ".....+.58.",
        "..592.....",
        "......755.",
        "...$.*....",
        ".664.598..",
        ""
        ]
    
    func testNumberParserWithoutAttach() throws {
        var parser = NumberParser(currentPuzzle)
        let (n1, _) = parser.nextNumber()
        XCTAssertEqual(467, n1)
        let (n2, _) = parser.nextNumber()
        XCTAssertEqual(114, n2)
        let (n3, _) = parser.nextNumber()
        XCTAssertEqual(35, n3)


    }

    func testSolvePart1() throws {
        let solution = Day03Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("1", result)
    }
}
