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
        let expected_values = [467, 114, 35, 633, 617, 58, 592, 755, 664, 598, nil]
        for expected_value in expected_values {
            let (n, _) = parser.nextNumber()
            XCTAssertEqual(expected_value, n)
        }
    }

    func testNumberParserWithAttach() throws {
        var parser = NumberParser(currentPuzzle)
        let expected_values = [(467, true), (114, false), (35, true), (633, true), (617, true), (58, false),
                               (592, true), (755, true), (664, true), (598, true), (nil, false)]
        for expected_value in expected_values {
            let t = parser.nextNumber()
            XCTAssertEqual(expected_value.0, t.0)
            XCTAssertEqual(expected_value.1, t.1)
        }
    }
    
    func testIdentifyGears() throws {
        var parser = NumberParser(currentPuzzle)
        var number : Int?
        repeat {
            (number, _) = parser.nextNumber()
        } while (number != nil)
        XCTAssertTrue(parser.numbersAttachedToStarAtPosition[Position(row:1, col:3)]?.count==2)
    }


    func testSolvePart1() throws {
        let solution = Day03Solution()
        let result = solution.solvePart1(puzzle: currentPuzzle)
        XCTAssertEqual("4361", result)
    }
    
    
    func testSolvePart2() throws {
        let solution = Day03Solution()
        let result = solution.solvePart2(puzzle: currentPuzzle)
        XCTAssertEqual("467835", result)
    }

}
